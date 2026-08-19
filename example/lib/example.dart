import 'package:advanced_cli/advanced_cli.dart';

part 'example.g.dart';

abstract class BaseCommand extends Command {
  @Flag("verbose", help: "Enable verbose mode.")
  bool verbose = false;
}

@MainCommand()
class MyCommand extends BaseCommand {
  @override
  String get name => "command";

  @override
  String? get restName => "rest";

  @override
  List<Converter<dynamic>> get converters => [
    StringConverter(),
  ];

  @Option("option", help: "An option!")
  late String myOption;

  @Option("otheroption", help: "Another option?!")
  String? otherOption;

  @MultiOption("device", help: "A list of devices.")
  List<String> devices = [];

  @Argument("argument", help: "A position argument?")
  late String myArgument;

  @Flag("flag", help: "A binary flag!!")
  bool myFlag = false;

  @Flag("otherflag", help: "A flag that is negatable", negatable: true)
  bool? myOtherFlag;

  @Subcommand("subcommand", help: "A subcommand...")
  MyOtherCommand myOtherCommand = .new();

  @override
  void onRun() {
    print("myFlag: $myFlag");
    print("myOtherFlag: $myOtherFlag");
    print("devices: $devices");
    print("rest: $rest");
  }

  @override
  HelpBuilder buildHelp() {
    return .new()
      ..addCustom("Subcommands:")
      ..addSubcommand(subcommands.myOtherCommand)
      ..addSeparator()
      ..addCustom("Flags/options:")
      ..addFlag(flags.myFlag)
      ..addFlag(flags.verbose)
      ..addOption(options.myOption)
      ..addMultiOption(multiOptions.devices)
      ..addSeparator()
      ..addCustom("Arguments:")
      ..addArgument(arguments.myArgument)
      ;
  }
}

class MyOtherCommand extends BaseCommand {
  @override
  String get name => "subcommand";

  @Flag("flag", abbr: "f")
  bool myOtherFlag = false;

  @override
  void onRun() {
    print("myOtherFlag: $myOtherFlag");
  }

  @override
  HelpBuilder buildHelp() {
    return .new()
      ..addFlag(flags.myOtherFlag);
  }
}

void main(List<String> arguments) {
  runCommands(arguments);
}