class Command {
  final String name;

  const Command(this.name);
}

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

  const Flag(this.name);
}

class Subcommand extends Parameter {
  const Subcommand();
}