import 'package:advanced_cli/src/command.dart';
import 'package:advanced_cli/src/generator_for_superclass.dart';
import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

Builder commandBuilder(BuilderOptions options) {
  return SharedPartBuilder(
    [CommandGenerator()],
    'advanced_cli',
  );
}

enum AnnotationType {
  option("Option"),
  argument("Argument"),
  flag("Flag"),
  subcommand("Subcommand"),
  ;

  static AnnotationType? getType(Element element) {
    return values.firstWhereOrNull((x) => x.className == element.name);
  }

  final String className;
  const AnnotationType(this.className);
}

class SubcommandElement {
  final String name;
  final FieldElement field;
  final DartObject annotation;

  SubcommandElement({required this.name, required this.field, required this.annotation});
}

class FlagElement {
  final String name;
  final String? abbr;

  final FieldElement field;
  final DartObject annotation;

  bool get hasAbbr => abbr != null;

  FlagElement({required this.name, required this.abbr, required this.field, required this.annotation});
}

class ArgumentElement {
  final String name;
  final DartType type;

  final FieldElement field;
  final DartObject annotation;

  ArgumentElement({required this.name, required this.type, required this.field, required this.annotation});
}

class OptionElement {
  final String name;
  final DartType type;

  final FieldElement field;
  final DartObject annotation;

  OptionElement({required this.name, required this.type, required this.field, required this.annotation});
}

class CommandGenerator extends GeneratorForSuperclass<Command> {
  @override
  dynamic generateForClass(ClassElement element, BuildStep buildStep) {
    final isMain = element.metadata.annotations.any((x) {
      final value = x.computeConstantValue();
      return value?.type?.element?.name == "MainCommand";
    });

    final subcommands = element.fields.map((x) {
      final a = x.metadata.annotations.firstWhereOrNull((y) {
        final value = y.computeConstantValue();
        return value?.type?.element?.name == "Subcommand";
      });

      if (a == null) return null;
      final annotation = a.computeConstantValue();
      if (annotation == null) return null;
      return SubcommandElement(name: annotation.getField("name")!.toStringValue()!, field: x, annotation: annotation);
    }).whereType<SubcommandElement>();

    final flags = element.fields.map((x) {
      final a = x.metadata.annotations.firstWhereOrNull((y) {
        final value = y.computeConstantValue();
        return value?.type?.element?.name == "Flag";
      });

      if (a == null) return null;
      final annotation = a.computeConstantValue();
      if (annotation == null) return null;
      return FlagElement(name: annotation.getField("name")!.toStringValue()!, abbr: annotation.getField("abbr")?.toStringValue(), field: x, annotation: annotation);
    }).whereType<FlagElement>();

    final arguments = element.fields.map((x) {
      final a = x.metadata.annotations.firstWhereOrNull((y) {
        final value = y.computeConstantValue();
        return value?.type?.element?.name == "Argument";
      });

      if (a == null) return null;
      final annotation = a.computeConstantValue();
      if (annotation == null) return null;
      return ArgumentElement(name: annotation.getField("name")!.toStringValue()!, type: x.type, field: x, annotation: annotation);
    }).whereType<ArgumentElement>();

    final options = element.fields.map((x) {
      final a = x.metadata.annotations.firstWhereOrNull((y) {
        final value = y.computeConstantValue();
        return value?.type?.element?.name == "Option";
      });

      if (a == null) return null;
      final annotation = a.computeConstantValue();
      if (annotation == null) return null;
      return OptionElement(name: annotation.getField("name")!.toStringValue()!, type: x.type, field: x, annotation: annotation);
    }).whereType<OptionElement>();

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

  static void runFromList(List<String> arguments, [int i = 0]) {
    if (arguments.length > i) {
      switch (arguments[i]) {
        ${subcommands.map((element) {
          return "case '${element.name}': return ${element.field.type.getDisplayString(withNullability: false)}CommandData.runFromList(arguments, i + 1);";
        }).join("\n")}
      }
    }

    final object = ${element.name}();
    final iterator = arguments.iterator;
    int pos = 0;

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          ${flags.map((element) {
            return "case '${element.name}': object.${element.field.name} = !object.${element.field.name}; break;";
          }).join("\n")}
          ${options.map((element) {
            return """case '${element.name}':
              final converter = object.checkConverter(${element.type});

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
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          ${flags.where((x) => x.hasAbbr).map((element) {
            return "case '${element.abbr}': object.${element.field.name} = !object.${element.field.name}; break;";
          }).join("\n")}
        }
      } else if (pos < ${arguments.length}) {
        final target = positional[i];
        final converter = object.checkConverter(target.runtimeType);

        if (converter == null) {
          throw ConverterNotFoundError("Converter not found for positional argument \${target.name} and type \${target.type}.");
        }

        final value = converter.convert(arg);

        if (value == null) {
          throw ParseException("\${target.type}", arg, converter.help());
        }

        target.set(object, value);
      }
    }

    object.onRun();
  }
}
""".trim();
  }
}
