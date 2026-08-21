// ignore_for_file: public_member_api_docs

import 'package:commands/src/classes.dart';
import 'package:commands/src/generator_for_superclass.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:source_gen/source_gen.dart';

const bool debug = false;

String suffix(String element) => "${element}Data";

extension on Element {
  String _internalName(String? name) {
    return "${name}Data";
  }

  String get internalName => _internalName(name);
}

extension on VariableElement {
  String get internalNameFromType => _internalName(type.getDisplayString(withNullability: false));
}

extension on String {
  String get quoted => '"$this"';
}

Builder commandBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [CommandGenerator()],
    'commands',
  );
}

enum AnnotationType {
  option("option", "Option"),
  multiOption("multi-option", "MultiOption"),
  argument("argument", "Argument"),
  flag("flag", "Flag"),
  subcommand("subcommand", "Subcommand"),
  ;

  final String pretty;
  final String className;

  const AnnotationType(this.pretty, this.className);
}

abstract class ParameterElement {
  final String name;
  final String? help;

  final FieldElement field;
  final DartObject annotation;

  ParameterElement({required this.name, required this.help, required this.field, required this.annotation});

  String toRecord();

  @protected
  String bracketsIf(bool condition, String string) {
    return condition ? "[$string]" : string;
  }
}

class SubcommandElement extends ParameterElement {
  SubcommandElement({required super.name, required super.field, required super.annotation, required super.help});

  @override
  String toRecord() {
    return "(name: ${name.quoted}, help: ${help?.quoted})";
  }
}

class FlagElement extends ParameterElement {
  final String? abbr;
  final bool negatable;

  bool get hasAbbr => abbr != null;

  FlagElement({required super.name, required this.abbr, required this.negatable, required super.field, required super.annotation, required super.help});

  @override
  String toString() {
    return bracketsIf(!negatable, ["--$name", if (hasAbbr) "-$abbr"].join("/"));
  }

  @override
  String toRecord() {
    return "(name: ${name.quoted}, help: ${help?.quoted}, abbr: ${abbr?.quoted}, negatable: $negatable)";
  }
}

class ArgumentElement extends ParameterElement {
  final DartType type;
  final bool optional;

  ArgumentElement({required super.name, required this.type, required this.optional, required super.field, required super.annotation, required super.help});

  @override
  String toString() {
    return bracketsIf(optional, name);
  }

  @override
  String toRecord() {
    return "(name: ${name.quoted}, help: ${help?.quoted}, required: ${!optional})";
  }
}

class OptionElement extends ParameterElement {
  final DartType type;
  final bool optional;

  OptionElement({required super.name, required this.type, required this.optional, required super.field, required super.annotation, required super.help});

  @override
  String toString() {
    return bracketsIf(optional, "--$name <$name>");
  }

  @override
  String toRecord() {
    return "(name: ${name.quoted}, help: ${help?.quoted}, type: ${type.getDisplayString().quoted}, required: ${!optional})";
  }
}

class MultiOptionElement extends ParameterElement {
  final DartType type;
  final int? min;

  bool get atLeastOne => min != null && min! >= 1;

  MultiOptionElement({required super.name, required this.type, required this.min, required super.field, required super.annotation, required super.help});

  @override
  String toString() {
    return bracketsIf(!atLeastOne, "--$name <$name>");
  }

  @override
  String toRecord() {
    return "(name: ${name.quoted}, help: ${help?.quoted}, type: ${type.getDisplayString().quoted}, min: $min)";
  }
}

class CommandGenerator extends GeneratorForSuperclass<Command> {
  DartObject? getAnnotation(Element x, List<AnnotationType> types) {
    final names = types.map((x) => x.className);

    final a = x.metadata.annotations.firstWhereOrNull((y) {
      final value = y.computeConstantValue();
      final name = value?.type?.element?.name;
      return name != null && names.contains(name);
    });

    if (a == null) return null;
    final annotation = a.computeConstantValue();
    return annotation;
  }

  DartObject? getField(DartObject? object, String name) {
    if (object == null) return null;
    var current = object;

    while (true) {
      final f = current.getField(name);
      if (f != null) return f;

      final s = current.getField("(super)");
      if (s == null) return null;
      current = s;
    }
  }

  Iterable<FieldElement> allFields(ClassElement element) {
    final Set<String> elements = {};
    final Set<String> names = {};
    final List<FieldElement> result = [];

    for (final field in [
      ...element.fields,
      ...element.allSupertypes.expand((t) => t.element.fields),
    ]) {
      if (field.isStatic) continue;
      final annotation = getAnnotation(field, AnnotationType.values);
      final name = getField(annotation, "name")?.toStringValue();

      if (field.name != null && elements.add(field.name!) && name != null && names.add(name)) {
        result.add(field);
      }
    }

    return result;
  }

  String validateName(String name, AnnotationType type) {
    if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(name)) {
      throw InvalidGenerationSourceError("Invalid name for ${type.pretty}: '$name'\nNames need to be in strict snake-case, with no capitals");
    }

    return name;
  }

  String? validateAbbr(String? abbr, AnnotationType type) {
    if (abbr == null) return null;
    if (abbr.length != 1) throw InvalidGenerationSourceError("Invalid abbreviation: '$abbr'\nAbbreviations can only be 1 character.");
    if (!RegExp(r'^[a-z0-9]$').hasMatch(abbr)) throw InvalidGenerationSourceError("Invalid abbreviation: '$abbr'\nAbbreviations can only be a lowercase letter or a number.");
    return abbr;
  }

  @override
  dynamic generateForClass(ClassElement element, BuildStep buildStep) {
    if (element.isAbstract) return "";

    final isMain = element.metadata.annotations.any((x) {
      final value = x.computeConstantValue();
      return value?.type?.element?.name == "MainCommand";
    });

    final subcommands = allFields(element).map((x) {
      final annotation = getAnnotation(x, [.subcommand]);
      if (annotation == null) return null;
      return SubcommandElement(name: validateName(getField(annotation, "name")!.toStringValue()!, .subcommand), help: getField(annotation, "help")?.toStringValue(), field: x, annotation: annotation);
    }).whereType<SubcommandElement>();

    final flags = allFields(element).map((x) {
      final annotation = getAnnotation(x, [.flag]);
      if (annotation == null) return null;

      final name = validateName(getField(annotation, "name")!.toStringValue()!, .flag);
      final abbr = validateAbbr(getField(annotation, "abbr")?.toStringValue(), .flag);

      if (name == "help") throw InvalidGenerationSourceError("Flag --help is already automatically generated.");
      if (abbr == "h") throw InvalidGenerationSourceError("Flag --help (abbreviation -h) is already automatically generated.");

      return FlagElement(name: name, help: getField(annotation, "help")?.toStringValue(), negatable: getField(annotation, "negatable")?.toBoolValue() ?? false, abbr: abbr, field: x, annotation: annotation);
    }).whereType<FlagElement>();

    final arguments = allFields(element).map((x) {
      final annotation = getAnnotation(x, [.argument]);
      if (annotation == null) return null;
      return ArgumentElement(name: validateName(getField(annotation, "name")!.toStringValue()!, .argument), help: getField(annotation, "help")?.toStringValue(), type: x.type, field: x, annotation: annotation, optional: !x.isLate);
    }).whereType<ArgumentElement>();

    final options = allFields(element).map((x) {
      final annotation = getAnnotation(x, [.option]);
      if (annotation == null) return null;
      return OptionElement(name: validateName(getField(annotation, "name")!.toStringValue()!, .option), help: getField(annotation, "help")?.toStringValue(), type: x.type, field: x, annotation: annotation, optional: !x.isLate);
    }).whereType<OptionElement>();

    final multiOptions = allFields(element).map((x) {
      final annotation = getAnnotation(x, [.multiOption]);
      if (annotation == null) return null;
      final name = validateName(getField(annotation, "name")!.toStringValue()!, .multiOption);

      if (!x.type.isDartCoreList) {
        throw InvalidGenerationSourceError("Multi-option $name needs to be of type List.");
      }

      return MultiOptionElement(name: name, help: getField(annotation, "help")?.toStringValue(), type: (x.type as InterfaceType).typeArguments.first, field: x, annotation: annotation, min: getField(annotation, "min")?.toIntValue());
    }).whereType<MultiOptionElement>();

    for (final subcommand in subcommands) {
      if (!TypeChecker.typeNamed(Command).isAssignableFromType(subcommand.field.type)) {
        throw InvalidGenerationSourceError("Subcommand ${subcommand.name} needs to be of type Command.");
      }
    }

    for (final flag in flags) {
      final type = flag.field.type;

      if (!type.isDartCoreBool) {
        throw InvalidGenerationSourceError("Flag ${flag.name} needs to be of type bool.");
      }

      if (flag.field.isLate) {
        throw InvalidGenerationSourceError("Flag ${flag.name} cannot be late.");
      }
    }

    for (final option in multiOptions) {
      if (option.field.isLate) {
        throw InvalidGenerationSourceError("Multi-option ${option.name} needs to be of type List and cannot be late.");
      }
    }

    String ifEmptyRecord(String input) {
      return input == "({})" ? "()" : input;
    }

    String allBlank(String name, String type, Iterable<ParameterElement> elements) {
      return """
List<$type> get all$name {
  return [${elements.map((x) {
    return x.toRecord();
  }).join(", ")}];
}""".trim();
    }

    String allBlankRecords(String name, String type, Iterable<ParameterElement> elements) {
      return """
${ifEmptyRecord("({${elements.map((x) => "$type ${x.field.name}").join(", ")}})")} get $name {
  return (${elements.map((x) => "${x.field.name}: ${x.toRecord()}").join(", ")});
}""".trim();
    }

    return """
${isMain ? """
bool runCommands(List<String> arguments) {
  return ${element.internalName}.runFromList(arguments);
}
""" : ""}

extension ${element.name}Help on ${element.name} {
  UsageBuilder defaultUsageBuilder() {
    return UsageBuilder()${flags.map((x) => "..addFlag(flags.${x.field.name})").join("")}${options.map((x) => "..addOption(options.${x.field.name})").join("")}${multiOptions.map((x) => "..addMultiOption(multiOptions.${x.field.name})").join("")}${arguments.map((x) => "..addArgument(arguments.${x.field.name})").join("")}..addCustom(settings.restUsageName != null ? "...\${settings.restUsageName}" : null);
  }

  String get usage {
    return (buildUsage() ?? defaultUsageBuilder()).toString();
  }

  ${allBlank("Arguments", "ArgumentData", arguments)}

  ${allBlank("Flags", "FlagData", flags)}

  ${allBlank("Options", "OptionData", options)}

  ${allBlank("MultiOptions", "MultiOptionData", multiOptions)}

  ${allBlank("Subcommands", "SubcommandData", subcommands)}

  ${allBlankRecords("arguments", "ArgumentData", arguments)}

  ${allBlankRecords("flags", "FlagData", flags)}

  ${allBlankRecords("options", "OptionData", options)}

  ${allBlankRecords("multiOptions", "MultiOptionData", multiOptions)}

  ${allBlankRecords("subcommands", "SubcommandData", subcommands)}
}

final class ${element.internalName} {
  static final List<PositionalArgumentData> _positional = [${arguments.map((arg) {
    return "(name: '${arg.name}', type: ${arg.type.getDisplayString(withNullability: false)}, set: (Command object, dynamic value) => (object as ${element.name}).${arg.field.name} = value, required: ${!arg.optional})";
  }).join(", ")}];

  // ignore: unused_element
  static void _debug(String Function() input) {
    ${debug ? "print('[Debug] [${element.name}] \${input()}');" : ''}
  }

  static bool runFromList(List<String> arguments) {
    try {
      ${debug ? "final stopwatch = Stopwatch()..start();" : ""}
      _runFromList(arguments, 0);
      ${debug ? 'stopwatch.stop(); _debug(() => "Elapsed time: \${stopwatch.elapsedMicroseconds}us");' : ""}
      return true;
    } on ParseException catch (e) {
      if (e.message != null) print(e.message);
      print("Usage: \${e.usage}");
      print("");
      print(e.object.buildHelp());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {
        ${subcommands.map((element) {
          return "case '${element.name}': return ${element.field.internalNameFromType}._runFromList(arguments, index + 1);";
        }).join("\n")}
      }
    }

    final object = ${element.name}();

    for (final converter in object.converters) {
      if (converter is! EnumConverter) continue;
      if (converter.type == Enum) throw Exception("You must specify a type for EnumConverter. Trust me, I learned this the hard way.");
    }

    if (arguments.contains("-h") || arguments.contains("--help")) {
      throw ParseException(null, object, object.usage);
    }

    if (object.settings.subcommandsOnly) {
      throw ParseException("Subcommand is required.\\nAvailable options: ${subcommands.map((x) => x.name).join(", ")}", object, object.usage);
    }

    // Makes it easy to get the next item when parsing things such as options
    final iterator = arguments.iterator;
    final maxPos = ${arguments.length - 1};

    final List<String> rest = [];
    final Set<String> setOptions = {};
    final Map<String, int> setMultiOptions = {};

    int pos = 0;
    bool foundArgument = false;

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;
      final noOptions = foundArgument && !object.settings.allowTrailingOptions;

      if (!noOptions && arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'help': throw ParseException(null, object, object.usage);
          ${flags.map((element) {
            return "case '${element.name}': object.${element.field.name} = true; break;";
          }).join("\n")}
          ${flags.where((x) => x.negatable).map((element) {
            return "case 'no-${element.name}': object.${element.field.name} = false; break;";
          }).join("\n")}
          ${options.map((element) {
            return """case '${element.name}':
              // Converts strings into the preferred type
              final converter = object.getConverter(${element.type.getDisplayString(withNullability: false)});

              if (converter == null) {
                throw ConverterNotFoundError("Converter not found for option ${element.name} and type ${element.type.getDisplayString(withNullability: false)}.");
              }

              if (!iterator.moveNext()) {
                throw ParseException("Expected value for option '${element.name}'.", object, object.usage);
              }

              final value = converter.convert(iterator.current);

              if (value == null) {
                throw ParseException.fromConversionError(converter.typePretty ?? "${element.type.getDisplayString(withNullability: false)}", arg, converter.help(), object, object.usage);
              }

              object.${element.field.name} = value;
              setOptions.add("${element.name}");
              break;
            """.trim();
          }).join("\n")}
          ${multiOptions.map((element) {
            return """case '${element.name}':
              // Converts strings into the preferred type
              final converter = object.getConverter(${element.type.getDisplayString(withNullability: false)});

              if (converter == null) {
                throw ConverterNotFoundError("Converter not found for multi-option ${element.name} and type List<${element.type.getDisplayString(withNullability: false)}>.");
              }

              if (!iterator.moveNext()) {
                throw ParseException("Expected value for option '${element.name}'.", object, object.usage);
              }

              final value = converter.convert(iterator.current);

              if (value == null) {
                throw ParseException.fromConversionError(converter.typePretty ?? "${element.type.getDisplayString(withNullability: false)}", arg, converter.help(), object, object.usage);
              }

              object.${element.field.name}.add(value);
              setMultiOptions["${element.name}"] = (setMultiOptions["${element.name}"] ?? 0) + 1;
              break;
            """.trim();
          }).join("\n")}
          default: throw ParseException("Invalid flag/option: \$arg", object, object.usage);
        }
      } else if (!noOptions && arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          case 'h': throw ParseException(null, object, object.usage);
          ${flags.where((x) => x.hasAbbr).map((element) {
            return "case '${element.abbr}': object.${element.field.name} = !object.${element.field.name}; break;";
          }).join("\n")}
          default: throw ParseException("Invalid flag/option: \$arg", object, object.usage);
        }
      } else if (pos <= maxPos) {
        final target = _positional[pos];
        final converter = object.getConverter(target.type); // Converts strings into the preferred type

        if (converter == null) {
          throw ConverterNotFoundError("Converter not found for positional argument \${target.name} and type \${target.type}.");
        }

        final value = converter.convert(arg);

        if (value == null) {
          throw ParseException.fromConversionError(converter.typePretty ?? target.type.toString(), arg, converter.help(), object, object.usage);
        }

        target.set(object, value);
        pos++;
        foundArgument = true;
      } else {
        if (!object.settings.allowRest) {
          throw ParseException("Too many arguments. Expected ${arguments.length}, but got an extra: '\$arg'", object, object.usage);
        }

        rest.add(arg);
        pos++;
        foundArgument = true;
      }
    }

    if (_positional.elementAtOrNull(pos)?.required == true) {
      throw ParseException("Positional argument '\${_positional[pos].name}' is required.", object, object.usage);
    }

    for (final String name in [${options.where((x) => !x.optional).map((x) => x.name.quoted).join(", ")}]) {
      if (!setOptions.contains(name)) {
        throw ParseException("Option '\$name' is required.", object, object.usage);
      }
    }

    for (final (String name, int? min) in [${multiOptions.map((x) => '(${x.name.quoted}, ${x.min})').join(", ")}]) {
      if (min == null || min <= 0) continue;
      final count = setMultiOptions[name];

      if (count == null) {
        throw ParseException("Multi-option '\$name' requires at least \$min items.", object, object.usage);
      }

      if (count < min) {
        throw ParseException("Multi-option '\$name' requires at least \$min items.", object, object.usage);
      }
    }

    object.rest = rest;
    final validate = object.validate();

    if (validate != null) throw ParseException(validate, object, object.usage);
    object.onRun();
  }
}
""".trim();
  }
}
