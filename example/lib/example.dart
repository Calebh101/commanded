import 'package:advanced_cli/advanced_cli.dart';

part 'example.g.dart';

@MainCommand()
class MyCommand extends Command {
  @override String get name => "command";
  @override String get description => "A command.";

  @override
  List<Converter<dynamic>> get converters => [
    StringConverter(),
  ];

  @Option("option")
  late String myOption;

  @Argument("argument")
  late String myArgument;

  @Flag("flag")
  bool myFlag = false;

  @Subcommand("subcommand")
  MyOtherCommand myOtherCommand = .new();

  @override
  void onRun() {
    print("myFlag: $myFlag");
  }
}

class MyOtherCommand extends Command {
  @override String get name => "subcommand";
  @override String get description => "Another command.";

  @Flag("flag", abbr: "f")
  bool myOtherFlag = false;

  @override
  void onRun() {
    print("myOtherFlag: $myOtherFlag");
  }
}

void main(List<String> arguments) {
  processArgs(arguments);
}