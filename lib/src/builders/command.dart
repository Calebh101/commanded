import 'dart:async';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart';

Builder commandBuilder(BuilderOptions options) {
  return CommandBuilder();
}

String getHelp(String command, List<ParameterElement> parameters, {bool flagsBefore = true}) {
  final options = parameters.where((x) => x.type == .option);
  final args = parameters.where((x) => x.type == .argument);
  final flags = parameters.where((x) => x.type == .flag);

  final argsString = args.map((x) => "<${x.name}>").join(" ");

  return [
    command,
    if (!flagsBefore) argsString,
    flags.map((x) => "[--${x.name}]").join(" "),
    options.map((x) => "[--${x.name}=${x.field.type.getDisplayString()}]").join(" "),
    if (flagsBefore) argsString,
  ].where((x) => x.isNotEmpty).join(" ");
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

class ParameterElement {
  final String name;
  final FieldElement field;
  final DartObject annotation;
  final AnnotationType type;

  ParameterElement({required this.name, required this.field, required this.annotation, required this.type});
}

class CommandElement {
  final String name;
  final ClassElement element;
  final List<ParameterElement> parameters;

  CommandElement({required this.name, required this.element, required this.parameters});
}

class CommandBuilder implements Builder {
  @override
  final buildExtensions = {
    r'$lib$': ['advanced_cli.g.dart'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final List<CommandElement> commands = [];

    await for (final asset in buildStep.findAssets(
      .new('lib/**.dart'),
    )) {
      final library = LibraryReader(
        await buildStep.resolver.libraryFor(asset),
      );

      for (final element in library.classes) {
        for (final meta in element.metadata.annotations) {
          final annotation = meta.computeConstantValue();
          final name = annotation?.type?.element?.name;
          if (annotation == null || name != "Command") continue;
          final List<ParameterElement> parameters = [];

          for (final field in element.fields) {
            for (final meta in field.metadata.annotations) {
              final annotation = meta.computeConstantValue();
              final type = AnnotationType.values.firstWhereOrNull((x) => x.className == annotation?.type?.element?.name);

              if (annotation == null || type == null) {
                continue;
              }

              if (type == .flag) {
                if (!field.type.isDartCoreBool) {
                  throw InvalidGenerationSourceError(
                    "Field ${field.name} must be of type bool.",
                    element: field,
                  );
                }
              }

              parameters.add(.new(name: annotation.getField("name")!.toStringValue()!, field: field, annotation: annotation, type: type));
            }
          }

          commands.add(.new(name: annotation.getField("name")!.toStringValue()!, element: element, parameters: parameters));
        }
      }
    }

    final output = '''
// GENERATED CODE

// ignore_for_file: unused_field

import 'package:advanced_cli/advanced_cli.dart';

enum _AnnotationType {
  option,
  argument,
  flag,
  ;
}

abstract class CommandData {
  const CommandData();
}

final class _Param {
  final _AnnotationType annotation;
  final String type;
  final String? name;

  const _Param({required this.annotation, required this.type, required this.name});
}

final class _Command {
  final Map<String, _Param> parameters;
  final String help;

  const _Command({required this.parameters, required this.help});
}

final Map<String, _Command> _commands = {
${commands.map((command) {
  return '''  "${command.name}": _Command(
    help: "${getHelp(command.name, command.parameters)}",
    parameters: {
${command.parameters.map((parameter) {
  return '      "${parameter.name}": _Param(annotation: .${parameter.type.name}, type: "${parameter.field.type.getDisplayString()}", name: "${parameter.annotation.getField("name")?.toStringValue()}")';
}).join(",\n")},
    },
  ),
'''.trimRight();
}).join("\n")}
};

${commands.map((command) {
  final className = "${sentenceCase(command.name).replaceAll("-", "_")}CommandData";

  return '''
class $className extends CommandData {
${command.parameters.map((param) {
  return "  final ${param.field.type.getDisplayString()} ${param.field.name};";
}).join("\n")}

  const $className({${command.parameters.map((param) {
    return "required this.${param.field.name}";
  }).join(", ")}});
}
'''.trim();
}).join("\n\n")}
''';

    final outputId = AssetId(
      buildStep.inputId.package,
      'lib/advanced_cli.g.dart',
    );

    await buildStep.writeAsString(
      outputId,
      output,
    );
  }
}

String sentenceCase(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}