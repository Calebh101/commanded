import 'package:advanced_cli/advanced_cli.dart';

@Command("my")
class MyCommand {
  @Option("option")
  late String myOption;

  @Flag("flag")
  bool myFlag = false;
}

class MyOtherClass {}