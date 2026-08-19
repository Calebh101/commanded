abstract class Parameter {
  const Parameter();
}

class Option extends Parameter {
  final String name;

  const Option(this.name);
}

class Argument extends Parameter {
  final String name;

  const Argument(this.name);
}

class Flag extends Parameter {
  final String name;
  final String? abbr;

  const Flag(this.name, {this.abbr});
}

class Subcommand extends Parameter {
  final String name;

  const Subcommand(this.name);
}

class MainCommand {
  const MainCommand();
}