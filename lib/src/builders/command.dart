import 'package:advanced_cli/src/command.dart';
import 'package:advanced_cli/src/generator_for_superclass.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

const bool debug = false;

Builder commandBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [CommandGenerator()],
    'advanced_cli',
  );
}

enum AnnotationType {
  option("Option"),
  multiOption("MultiOption"),
  argument("Argument"),
  flag("Flag"),
  subcommand("Subcommand"),
  ;

  final String className;
  const AnnotationType(this.className);
}

abstract class ParameterElement {
  final String name;
  final String? help;

  new({required this.name, required this.help});
}

class SubcommandElement extends ParameterElement {
  final FieldElement field;
  final DartObject annotation;

  SubcommandElement({required super.name, required this.field, required this.annotation, required super.help});
}

class FlagElement extends ParameterElement {
  final String? abbr;

  final FieldElement field;
  final DartObject annotation;

  bool get hasAbbr => abbr != null;

  FlagElement({required super.name, required this.abbr, required this.field, required this.annotation, required super.help});
}

class ArgumentElement extends ParameterElement {
  final DartType type;
  final FieldElement field;
  final DartObject annotation;

  ArgumentElement({required super.name, required this.type, required this.field, required this.annotation, required super.help});
}

class OptionElement extends ParameterElement {
  final DartType type;
  final FieldElement field;
  final DartObject annotation;

  OptionElement({required super.name, required this.type, required this.field, required this.annotation, required super.help});
}

class MultiOptionElement extends ParameterElement {
  final DartType type;
  final FieldElement field;
  final DartObject annotation;

  MultiOptionElement({required super.name, required this.type, required this.field, required this.annotation, required super.help});
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
      final name = annotation?.getField("name")?.toStringValue();
      if (field.name != null && elements.add(field.name!) && name != null && names.add(name)) result.add(field);
    }

    return result;
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
      return SubcommandElement(name: annotation.getField("name")!.toStringValue()!, help: annotation.getField("help")?.toStringValue(), field: x, annotation: annotation);
    }).whereType<SubcommandElement>();

    final flags = allFields(element).map((x) {
      final annotation = getAnnotation(x, [.flag]);
      if (annotation == null) return null;
      return FlagElement(name: annotation.getField("name")!.toStringValue()!, help: annotation.getField("help")?.toStringValue(), abbr: annotation.getField("abbr")?.toStringValue(), field: x, annotation: annotation);
    }).whereType<FlagElement>();

    final arguments = allFields(element).map((x) {
      final annotation = getAnnotation(x, [.argument]);
      if (annotation == null) return null;
      return ArgumentElement(name: annotation.getField("name")!.toStringValue()!, help: annotation.getField("help")?.toStringValue(), type: x.type, field: x, annotation: annotation);
    }).whereType<ArgumentElement>();

    final options = allFields(element).map((x) {
      final annotation = getAnnotation(x, [.option]);
      if (annotation == null) return null;
      return OptionElement(name: annotation.getField("name")!.toStringValue()!, help: annotation.getField("help")?.toStringValue(), type: x.type, field: x, annotation: annotation);
    }).whereType<OptionElement>();

    final multiOptions = allFields(element).map((x) {
      final annotation = getAnnotation(x, [.multiOption]);
      if (annotation == null) return null;
      final name = annotation.getField("name")!.toStringValue()!;

      if (!x.type.isDartCoreList) {
        throw InvalidGenerationSourceError("Multi-option $name needs to be of type List.");
      }

      return MultiOptionElement(name: name, help: annotation.getField("help")?.toStringValue(), type: (x.type as InterfaceType).typeArguments.first, field: x, annotation: annotation);
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
        throw InvalidGenerationSourceError("Flag ${flag.name} cannot be late, and must default to true or false.");
      }
    }

    for (final option in multiOptions) {
      if (option.field.isLate) {
        throw InvalidGenerationSourceError("Multi-option ${option.name} needs to be of type List and cannot be late.");
      }
    }

    return """
${isMain ? """
void processArgs(List<String> arguments) {
  return ${element.name}CommandData.runFromList(arguments);
}
""" : ""}

final class ${element.name}CommandData {
  static final positional = [${arguments.map((arg) {
    return "(name: '${arg.name}', type: ${arg.type.getDisplayString(withNullability: false)}, set: (${element.name} object, dynamic value) => object.${arg.field.name} = value)";
  }).join(", ")}];

  // ignore: unused_element
  static void _debug(String Function() input) {
    ${debug ? "print('[Debug] [${element.name}] \${input()}');" : ''}
  }

  static void runFromList(List<String> arguments, [int index = 0]) {
    if (arguments.length > index) {
      switch (arguments[index]) {
        ${subcommands.map((element) {
          return "case '${element.name}': return ${element.field.type.getDisplayString(withNullability: false)}CommandData.runFromList(arguments, index + 1);";
        }).join("\n")}
      }
    }

    final iterator = arguments.iterator;
    final object = ${element.name}();
    final maxPos = ${arguments.length - 1};

    int pos = 0;
    final List<String> rest = [];

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          ${flags.map((element) {
            return "case '${element.name}': object.${element.field.name} = !object.${element.field.name}; break;";
          }).join("\n")}
          ${options.map((element) {
            return """case '${element.name}':
              final converter = object.getConverter(${element.type});

              if (converter == null) {
                throw ConverterNotFoundError("Converter not found for option ${element.name} and type ${element.type}.");
              }

              if (!iterator.moveNext()) {
                throw CustomParseException("Expected value for option ${element.name}.");
              }

              final value = converter.convert(iterator.current);

              if (value == null) {
                throw ParseException("${element.type}", arg, converter.help());
              }

              object.${element.field.name} = value;
            """.trim();
          }).join("\n")}
          ${multiOptions.map((element) {
            return """case '${element.name}':
              final converter = object.getConverter(${element.type});

              if (converter == null) {
                throw ConverterNotFoundError("Converter not found for multi-option ${element.name} and type List<${element.type}>.");
              }

              if (!iterator.moveNext()) {
                throw CustomParseException("Expected value for option ${element.name}.");
              }

              final value = converter.convert(iterator.current);

              if (value == null) {
                throw ParseException("${element.type}", arg, converter.help());
              }

              object.${element.field.name}.add(value);
            """.trim();
          }).join("\n")}
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          ${flags.where((x) => x.hasAbbr).map((element) {
            return "case '${element.abbr}': object.${element.field.name} = !object.${element.field.name}; break;";
          }).join("\n")}
        }
      } else if (pos <= maxPos) {
        final target = positional[pos];
        final converter = object.getConverter(target.type);

        if (converter == null) {
          throw ConverterNotFoundError("Converter not found for positional argument \${target.name} and type \${target.type}.");
        }

        final value = converter.convert(arg);

        if (value == null) {
          throw ParseException("\${target.type}", arg, converter.help());
        }

        target.set(object, value);
        pos++;
      } else {
        rest.add(arg);
      }
    }

    object.rest = rest;
    object.onRun();
  }
}
""".trim();
  }
}
