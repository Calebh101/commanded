import 'dart:math';

import 'package:commands/commands.dart';

part 'example.g.dart';

// Here, let's create a simple command-line application with a bunch of subcommands that do various things.
// We're totally not doing this just for example for the package.
//
//
// Our first utility: **Random number generator**
// This will be able to:
// - Generate a random number from 0 and 100, inclusive.
// - Have optional --min and --max options for tuning the range.
// - Have an optional --secure flag for making the RNG use Random.secure. For a bonus, we'll also let this have a -s abbreviation!
// - We'll also have a --timed flag for debugging.
//
//
// Our next utility: **Text Echoer**
// This will be able to:
// - Print inputted text.
// - Repeat said text over and over.
// - Capitalize the text, or make it lowercase.
// Yes, this is basic, but we're gonna use this to show off positional arguments, negatable flags, and more.

// First, we're gonna set up a base command class. This gives us global options.
// For now, we'll just have --verbose.
// This allows of this class to be inherited by command classes that extends BaseCommand!
abstract class BaseCommand extends Command {
  @Flag("verbose", abbr: "v", help: "Enable verbose mode.")
  bool verbose = false;
}

// We're creating this command as a base for our other subcommands.
// One important limitation is that flags defined in this command won't apply to subcommands.
// For global options, we have to create/edit classes like BaseCommand.
//
// See the very bottom of the file for why we use MainCommand here.
@MainCommand()
class ParentCommand extends Command {
  // The binary name. This appears in the usage.
  @override
  String get name => "example";

  // We only have subcommands in this command, so we error if someone runs our command without any subcommands.
  @override
  CommandSettings get settings => .new(subcommandsOnly: true);

  // Define a subcommand. We can put late here instead of creating a new command.
  // The build runner only looks at the type, which is RandomNumberCommand here.
  @Subcommand("random", help: "Generate a random number.")
  late RandomNumberCommand randomNumberCommand;

  @Subcommand("echo", help: "Echo some text.")
  late EchoCommand echoCommand;

  // Build the usage line that shows up when --help is called.
  // This is very customizable, to fit whatever style you prefer!
  // If you don't override this, or return null, a default usage builder is used.
  @override
  UsageBuilder? buildUsage() {
    return .new()
      ..addCustom("example")
      ..addCustom("<${allSubcommands.map((x) => x.name).join(" | ")}>")
      ;
  }

  // Build the block of text that shows up when --help is called.
  // This is also very customizable!
  @override
  HelpBuilder buildHelp() {
    return .new()
      ..addSubcommand(subcommands.randomNumberCommand)
      ..addSubcommand(subcommands.echoCommand)
      ;
  }

  // This will never be called, cuz we only have subcommands defined here.
  @override
  void onRun() {}
}

// Because we extend BaseCommand, we automatically get the --verbose flag passed down to us!
// Isn't that so cool?
class RandomNumberCommand extends BaseCommand {
  // This also shows up in the usage.
  @override
  String get name => "random";

  // Define converters for options, multi-options, and arguments.
  // I won't explain this here, but for more info on this, please see the readme.
  @override
  List<Converter> get converters => [
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

  // This is a validator.
  // This kinda works like Flutter's text field validator, if you've ever used that.
  // If you return a string, the user will see your message, along with usage and help.
  // It's just like when the user provides invalid arguments, and the parser shows a message.
  @override
  String? validate() {
    if (min < 0 || max < 0) return "Both min and max cannot be negative.";
    if (min > max) return "min must be equal to or lesser than max.";
    return null;
  }

  // Run our program! All of our properties, like min, max, secure, and even random, are available here!
  @override
  void onRun() {
    final Random random = (secure ? .secure() : .new());
    final stopwatch = Stopwatch()..start();

    final result = random.nextInt((max - min) + 1) + min;
    stopwatch.stop();

    print(result);
    if (timed) print("Time: ${stopwatch.elapsedMicroseconds}us");
    if (verbose) print("Generated number! (secure: $secure)"); // We're using verbose, from BaseCommand!
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

class EchoCommand extends BaseCommand {
  // This also shows up in the usage.
  @override
  String get name => "echo";

  // These will be explained below.
  @override
  CommandSettings get settings => .new(allowTrailingOptions: false, allowRest: true);

  // Define converters for options, multi-options, and arguments.
  // If we don't do this, we'll get a runtime error.
  // We don't have to do this for flags.
  @override
  List<Converter> get converters => [
    StringConverter(),
    IntConverter(),
  ];

  // An option.
  @Option("repeat", help: "How many times to repeat the text. Defaults to 1.")
  int repeat = 1;

  // We've seen binary flags, but this here is one of em negatable flags.
  // This being negatable, we can now make this nullable, giving it 3 values.
  // There are 3 different cases that we have to account for now:
  // - --capitalize: This value becomes true. We'll take this as capitalize the entire string.
  // - --no-capitalize: This is autogenerated, and if this is used, this value becomes false. We'll take this as make the entire string lowercase.
  // - Not provided: This value stays null. We'll leave the text how it is.
  @Flag("capitalize", negatable: true, help: "Whether to capitalize this string, or make it all lowercase.")
  bool? capitalize;

  // Some basic help building.
  @override
  HelpBuilder buildHelp() {
    return .new()
      ..addOption(options.repeat)
      ..addFlag(flags.capitalize)
      ;
  }

  // Let's build a custom usage line!
  // We did the same in ParentCommand, but here we'll add some extra flare just because.
  // As HelpBuilder allows extra text, so does UsageBuilder!
  @override
  UsageBuilder? buildUsage() {
    return .new()
      ..addFlag(flags.verbose)
      ..addFlag(flags.capitalize)
      ..addOption(options.repeat)
      ..addCustom("...text")
      ;
  }

  // Another validator!
  @override
  String? validate() {
    if (repeat < 1) return "repeat must be positive.";
    if (rest.isEmpty) return "Text must be provided.";
    return null;
  }

  @override
  void onRun() {
    // Oh-ho, what's this 'rest' variable we see?
    // Well, this is in fact a list containing all the positional arguments, even if we haven't defined them.
    // Remember our settings up there, specifically allowRest? This makes it so that our parser doesn't error if it encounters a positional argument that overflows the amount we've defined.
    //
    // Because rest is a List<String>, we will combine all the arguments with spaces.
    // Yes, it might be inaccurate, but the point here is to show off the rest variable.
    // You might use this for better purposes later on.
    //
    // Remember allowTrailingOptions? Well, this makes it so that when we use a positional argument, or start inputting text, then options and flags after that get parsed as a positional argument.
    // Try it out! Use this:
    //   dart run example echo "hey there!" --repeat 3
    // You'll actually see the text:
    //   hey there! --repeat 3
    // Instead of the text being repeated 3 times.
    final text = switch (capitalize) {
      true => rest.join(" ").toUpperCase(),
      false => rest.join(" ").toLowerCase(),
      null => rest.join(" "),
    };

    // A bit anticlimactic, huh
    print(text * repeat);
  }
}

// Since we put @MainCommand() above our... main command, we get this special function called runCommands.
// This simply points to ParentCommandData.runFromList. We could call this manually, but using runCommands feels so much more professional, ya know?
// However, it's absolutely still possible to call ParentCommandData.runFromList, or any other command; this is just a shortcut.
void main(List<String> arguments) {
  runCommands(arguments);
}