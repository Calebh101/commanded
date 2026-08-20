// Here, let's create a simple command-line application with a bunch of subcommands that do various things.
// We're totally not doing this just for example for the package.
//
//
// Our first utility: **Random number generator**
// This will be able to:
// - Generate a random number between 1 and 100.
// - Have optional `--min` and `--max` options for tuning the range.
// - Have an optional `--secure` flag for making the RNG use `Random.secure`. For a bonus, we'll also let this have a `-s` abbreviation!
// - We'll also have a `--timed` flag for debugging.
library;

import 'dart:math';

import 'package:advanced_cli/advanced_cli.dart';

part 'example.g.dart';

// First, we're gonna set up a base command class. This gives us global options.
// For now, we'll just have --verbose.
// This allows all fields of this class to pass down to other command classes that extends `BaseCommand`!
abstract class BaseCommand extends Command {
  @Flag("verbose", help: "Enable verbose mode.")
  bool verbose = false;
}

@MainCommand()
class ParentCommand extends BaseCommand {
  // The binary name. This appears in the usage.
  @override
  String get name => "example";

  // We only have subcommands in this command, so we error if someone runs our command without any subcommands.
  @override
  CommandSettings get settings => .new(subcommandsOnly: true);

  // Define a subcommand. We can put `late` here instead of creating a new command.
  // The build runner only looks at the type, which is RandomNumberCommand here.
  @Subcommand("random", help: "Generate a random number.")
  late RandomNumberCommand randomNumberCommand;

  // Build what shows up when --help is called.
  // This is very customizable, to fit whatever style you prefer!
  @override
  HelpBuilder buildHelp() {
    return .new()
      ..addSubcommand(subcommands.randomNumberCommand)
      ;
  }

  // This will never be called.
  @override
  void onRun() {}
}

class RandomNumberCommand extends BaseCommand {
  // This also shows up in the usage.
  @override
  String get name => "random";

  // Define converters for options, multi-options, and arguments.
  // If we don't do this, we'll get a runtime error.
  // We don't have to do this for flags.
  @override
  List<Converter<dynamic>> get converters => [
    IntConverter(),
  ];

  // Since it's not late, and we put a default, the option is not required, and will default to 0.
  @Option("min", help: "Min number to generate, inclusive. Defaults to 0.")
  int min = 0;

  // Since it's not late, and we put a default, the option is not required, and will default to 100.
  @Option("max", help: "Max number to generate, inclusive. Defaults to 100.")
  int max = 100;

  // Since it's not late, and we put a default, the flag will default to false.
  @Flag("secure", abbr: "s", help: "Whether to make this RNG secure. Defaults to false.")
  bool secure = false;

  // Since this one is also not late, and we put a default, the flag will default to false.
  @Flag("timed", abbr: "t", help: "Whether to time how long it takes to generate the number. Defaults to false.")
  bool timed = false;

  // Run our program! All of our properties, like min, max, secure, and even random, are available here!
  @override
  void onRun() {
    if (min < 0 || max < 0) throw RangeError("Both min and max must be positive.");
    if (min >= max) throw RangeError("min must be lesser than max.");

    final Random random = (secure ? .secure() : .new());
    final stopwatch = Stopwatch()..start();

    final result = random.nextInt((max - min) + 1) + min;
    stopwatch.stop();

    print(result);
    if (timed) print("Time: ${stopwatch.elapsedMicroseconds}mcs");
  }

  // Build our help, but this time with options instead of subcommands.
  // We can even add separators and custom text! How cool is that!
  @override
  HelpBuilder buildHelp() {
    return .new()
      ..addCustom("Options:")
      ..addOption(options.min)
      ..addOption(options.max)
      ..addSeparator()
      ..addCustom("Flags:")
      ..addFlag(flags.secure)
      ..addFlag(flags.verbose)
      ;
  }
}

// Since we put `@MainCommand()` above our... main command, we get this special function called `runCommands`.
// This simply points to `ParentCommandData.runFromList`. We could call this manually, but using `runCommands` feels so much more professional, ya know?
void main(List<String> arguments) {
  runCommands(arguments);
}