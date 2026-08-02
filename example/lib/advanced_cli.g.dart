// GENERATED CODE

// ignore_for_file: unused_field

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
  "my": _Command(
    help: "my [--flag] [--option=String]",
    parameters: {
      "option": _Param(annotation: .option, type: "String", name: "option"),
      "flag": _Param(annotation: .flag, type: "bool", name: "flag"),
    },
  ),
};

class MyCommandData extends CommandData {
  final String myOption;
  final bool myFlag;

  const MyCommandData({required this.myOption, required this.myFlag});
}
