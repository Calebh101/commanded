abstract class Parameter {
  final String name;
  final String? help;

  const Parameter(this.name, {this.help});
}

class Option extends Parameter {
  const Option(super.name, {super.help});
}

class MultiOption extends Parameter {
  const MultiOption(super.name, {super.help});
}

class Argument extends Parameter {
  const Argument(super.name, {super.help});
}

class Flag extends Parameter {
  final String? abbr;

  const Flag(super.name, {this.abbr, super.help});
}

class Subcommand extends Parameter {
  const Subcommand(super.name, {super.help});
}

class MainCommand {
  const MainCommand();
}