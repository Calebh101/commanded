// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// CommandGenerator
// **************************************************************************

bool runCommands(List<String> arguments) {
  return ParentCommandData.runFromList(arguments);
}

extension ParentCommandHelp on ParentCommand {
  UsageBuilder defaultUsageBuilder() {
    return UsageBuilder()..addCustom(
      settings.restUsageName != null ? "...${settings.restUsageName}" : null,
    );
  }

  String get usage {
    return (buildUsage() ?? defaultUsageBuilder()).toString();
  }

  List<ArgumentData> get allArguments {
    return [];
  }

  List<FlagData> get allFlags {
    return [];
  }

  List<OptionData> get allOptions {
    return [];
  }

  List<MultiOptionData> get allMultiOptions {
    return [];
  }

  List<SubcommandData> get allSubcommands {
    return [
      (name: "random", help: "Generate a random number."),
      (name: "echo", help: "Echo some text."),
    ];
  }

  () get arguments {
    return ();
  }

  () get flags {
    return ();
  }

  () get options {
    return ();
  }

  () get multiOptions {
    return ();
  }

  ({SubcommandData randomNumberCommand, SubcommandData echoCommand})
  get subcommands {
    return (
      randomNumberCommand: (name: "random", help: "Generate a random number."),
      echoCommand: (name: "echo", help: "Echo some text."),
    );
  }
}

final class ParentCommandData {
  static final List<PositionalArgumentData> _positional = [];

  // ignore: unused_element
  static void _debug(String Function() input) {
    print('[Debug] [ParentCommand] ${input()}');
  }

  static bool runFromList(List<String> arguments) {
    try {
      final stopwatch = Stopwatch()..start();
      _runFromList(arguments, 0);
      stopwatch.stop();
      _debug(() => "Elapsed time: ${stopwatch.elapsedMicroseconds}us");
      return true;
    } on ParseException catch (e) {
      if (e.message != null) print(e.message);
      print("Usage: ${e.usage}");
      print("");
      print(e.object.buildHelp());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {
        case 'random':
          return RandomNumberCommandData._runFromList(arguments, index + 1);
        case 'echo':
          return EchoCommandData._runFromList(arguments, index + 1);
      }
    }

    final object = ParentCommand();

    if (arguments.contains("-h") || arguments.contains("--help")) {
      throw ParseException(null, object, object.usage);
    }

    if (object.settings.subcommandsOnly) {
      throw ParseException(
        "Subcommand is required.\nAvailable options: random, echo",
        object,
        object.usage,
      );
    }

    // Makes it easy to get the next item when parsing things such as options
    final iterator = arguments.iterator;
    final maxPos = -1;

    final List<String> rest = [];
    final Set<String> setOptions = {};
    final Map<String, int> setMultiOptions = {};

    int pos = 0;
    bool foundArgument = false;

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;
      final noOptions = foundArgument && !object.settings.allowTrailingOptions;

      if (!noOptions && arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'help':
            throw ParseException(null, object, object.usage);

          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage,
            );
        }
      } else if (!noOptions && arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          case 'h':
            throw ParseException(null, object, object.usage);

          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage,
            );
        }
      } else if (pos <= maxPos) {
        final target = _positional[pos];
        final converter = object.getConverter(
          target.type,
        ); // Converts strings into the preferred type

        if (converter == null) {
          throw ConverterNotFoundError(
            "Converter not found for positional argument ${target.name} and type ${target.type}.",
          );
        }

        final value = converter.convert(arg);

        if (value == null) {
          throw ParseException.advanced(
            converter.typePretty ?? target.type.toString(),
            arg,
            converter.help(),
            object,
            object.usage,
          );
        }

        target.set(object, value);
        pos++;
        foundArgument = true;
      } else {
        if (!object.settings.allowRest) {
          throw ParseException(
            "Too many arguments. Expected 0, but got an extra: '$arg'",
            object,
            object.usage,
          );
        }

        rest.add(arg);
        pos++;
        foundArgument = true;
      }
    }

    if (_positional.elementAtOrNull(pos)?.required == true) {
      throw ParseException(
        "Positional argument '${_positional[pos].name}' is required.",
        object,
        object.usage,
      );
    }

    for (final String name in []) {
      if (!setOptions.contains(name)) {
        throw ParseException(
          "Option '$name' is required.",
          object,
          object.usage,
        );
      }
    }

    for (final (String name, int? min) in []) {
      if (min == null || min <= 0) continue;
      final count = setMultiOptions[name];

      if (count == null) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
          object,
          object.usage,
        );
      }

      if (count < min) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
          object,
          object.usage,
        );
      }
    }

    object.rest = rest;
    final validate = object.validate();

    if (validate != null) throw ParseException(validate, object, object.usage);
    object.onRun();
  }
}

extension RandomNumberCommandHelp on RandomNumberCommand {
  UsageBuilder defaultUsageBuilder() {
    return UsageBuilder()
      ..addFlag(flags.secure)
      ..addFlag(flags.timed)
      ..addFlag(flags.verbose)
      ..addOption(options.min)
      ..addOption(options.max)
      ..addCustom(
        settings.restUsageName != null ? "...${settings.restUsageName}" : null,
      );
  }

  String get usage {
    return (buildUsage() ?? defaultUsageBuilder()).toString();
  }

  List<ArgumentData> get allArguments {
    return [];
  }

  List<FlagData> get allFlags {
    return [
      (
        name: "secure",
        help: "Whether to make this RNG secure. Defaults to false.",
        abbr: "s",
        negatable: false,
      ),
      (
        name: "timed",
        help:
            "Whether to time how long it takes to generate the number. Defaults to false.",
        abbr: "t",
        negatable: false,
      ),
      (
        name: "verbose",
        help: "Enable verbose mode.",
        abbr: "v",
        negatable: false,
      ),
    ];
  }

  List<OptionData> get allOptions {
    return [
      (
        name: "min",
        help: "Min number to generate, inclusive. Defaults to 0.",
        type: "int",
        required: false,
      ),
      (
        name: "max",
        help: "Max number to generate, inclusive. Defaults to 100.",
        type: "int",
        required: false,
      ),
    ];
  }

  List<MultiOptionData> get allMultiOptions {
    return [];
  }

  List<SubcommandData> get allSubcommands {
    return [];
  }

  () get arguments {
    return ();
  }

  ({FlagData secure, FlagData timed, FlagData verbose}) get flags {
    return (
      secure: (
        name: "secure",
        help: "Whether to make this RNG secure. Defaults to false.",
        abbr: "s",
        negatable: false,
      ),
      timed: (
        name: "timed",
        help:
            "Whether to time how long it takes to generate the number. Defaults to false.",
        abbr: "t",
        negatable: false,
      ),
      verbose: (
        name: "verbose",
        help: "Enable verbose mode.",
        abbr: "v",
        negatable: false,
      ),
    );
  }

  ({OptionData min, OptionData max}) get options {
    return (
      min: (
        name: "min",
        help: "Min number to generate, inclusive. Defaults to 0.",
        type: "int",
        required: false,
      ),
      max: (
        name: "max",
        help: "Max number to generate, inclusive. Defaults to 100.",
        type: "int",
        required: false,
      ),
    );
  }

  () get multiOptions {
    return ();
  }

  () get subcommands {
    return ();
  }
}

final class RandomNumberCommandData {
  static final List<PositionalArgumentData> _positional = [];

  // ignore: unused_element
  static void _debug(String Function() input) {
    print('[Debug] [RandomNumberCommand] ${input()}');
  }

  static bool runFromList(List<String> arguments) {
    try {
      final stopwatch = Stopwatch()..start();
      _runFromList(arguments, 0);
      stopwatch.stop();
      _debug(() => "Elapsed time: ${stopwatch.elapsedMicroseconds}us");
      return true;
    } on ParseException catch (e) {
      if (e.message != null) print(e.message);
      print("Usage: ${e.usage}");
      print("");
      print(e.object.buildHelp());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {}
    }

    final object = RandomNumberCommand();

    if (arguments.contains("-h") || arguments.contains("--help")) {
      throw ParseException(null, object, object.usage);
    }

    if (object.settings.subcommandsOnly) {
      throw ParseException(
        "Subcommand is required.\nAvailable options: ",
        object,
        object.usage,
      );
    }

    // Makes it easy to get the next item when parsing things such as options
    final iterator = arguments.iterator;
    final maxPos = -1;

    final List<String> rest = [];
    final Set<String> setOptions = {};
    final Map<String, int> setMultiOptions = {};

    int pos = 0;
    bool foundArgument = false;

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;
      final noOptions = foundArgument && !object.settings.allowTrailingOptions;

      if (!noOptions && arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'help':
            throw ParseException(null, object, object.usage);
          case 'secure':
            object.secure = true;
            break;
          case 'timed':
            object.timed = true;
            break;
          case 'verbose':
            object.verbose = true;
            break;

          case 'min':
            // Converts strings into the preferred type
            final converter = object.getConverter(int);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for option min and type int.",
              );
            }

            if (!iterator.moveNext()) {
              throw ParseException(
                "Expected value for option 'min'.",
                object,
                object.usage,
              );
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw ParseException.advanced(
                converter.typePretty ?? "int",
                arg,
                converter.help(),
                object,
                object.usage,
              );
            }

            object.min = value;
            setOptions.add("min");
            break;
          case 'max':
            // Converts strings into the preferred type
            final converter = object.getConverter(int);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for option max and type int.",
              );
            }

            if (!iterator.moveNext()) {
              throw ParseException(
                "Expected value for option 'max'.",
                object,
                object.usage,
              );
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw ParseException.advanced(
                converter.typePretty ?? "int",
                arg,
                converter.help(),
                object,
                object.usage,
              );
            }

            object.max = value;
            setOptions.add("max");
            break;

          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage,
            );
        }
      } else if (!noOptions && arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          case 'h':
            throw ParseException(null, object, object.usage);
          case 's':
            object.secure = !object.secure;
            break;
          case 't':
            object.timed = !object.timed;
            break;
          case 'v':
            object.verbose = !object.verbose;
            break;
          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage,
            );
        }
      } else if (pos <= maxPos) {
        final target = _positional[pos];
        final converter = object.getConverter(
          target.type,
        ); // Converts strings into the preferred type

        if (converter == null) {
          throw ConverterNotFoundError(
            "Converter not found for positional argument ${target.name} and type ${target.type}.",
          );
        }

        final value = converter.convert(arg);

        if (value == null) {
          throw ParseException.advanced(
            converter.typePretty ?? target.type.toString(),
            arg,
            converter.help(),
            object,
            object.usage,
          );
        }

        target.set(object, value);
        pos++;
        foundArgument = true;
      } else {
        if (!object.settings.allowRest) {
          throw ParseException(
            "Too many arguments. Expected 0, but got an extra: '$arg'",
            object,
            object.usage,
          );
        }

        rest.add(arg);
        pos++;
        foundArgument = true;
      }
    }

    if (_positional.elementAtOrNull(pos)?.required == true) {
      throw ParseException(
        "Positional argument '${_positional[pos].name}' is required.",
        object,
        object.usage,
      );
    }

    for (final String name in []) {
      if (!setOptions.contains(name)) {
        throw ParseException(
          "Option '$name' is required.",
          object,
          object.usage,
        );
      }
    }

    for (final (String name, int? min) in []) {
      if (min == null || min <= 0) continue;
      final count = setMultiOptions[name];

      if (count == null) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
          object,
          object.usage,
        );
      }

      if (count < min) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
          object,
          object.usage,
        );
      }
    }

    object.rest = rest;
    final validate = object.validate();

    if (validate != null) throw ParseException(validate, object, object.usage);
    object.onRun();
  }
}

extension EchoCommandHelp on EchoCommand {
  UsageBuilder defaultUsageBuilder() {
    return UsageBuilder()
      ..addFlag(flags.capitalize)
      ..addFlag(flags.verbose)
      ..addOption(options.repeat)
      ..addCustom(
        settings.restUsageName != null ? "...${settings.restUsageName}" : null,
      );
  }

  String get usage {
    return (buildUsage() ?? defaultUsageBuilder()).toString();
  }

  List<ArgumentData> get allArguments {
    return [];
  }

  List<FlagData> get allFlags {
    return [
      (
        name: "capitalize",
        help: "Whether to capitalize this string, or make it all lowercase.",
        abbr: null,
        negatable: true,
      ),
      (
        name: "verbose",
        help: "Enable verbose mode.",
        abbr: "v",
        negatable: false,
      ),
    ];
  }

  List<OptionData> get allOptions {
    return [
      (
        name: "repeat",
        help: "How many times to repeat the text. Defaults to 1.",
        type: "int",
        required: false,
      ),
    ];
  }

  List<MultiOptionData> get allMultiOptions {
    return [];
  }

  List<SubcommandData> get allSubcommands {
    return [];
  }

  () get arguments {
    return ();
  }

  ({FlagData capitalize, FlagData verbose}) get flags {
    return (
      capitalize: (
        name: "capitalize",
        help: "Whether to capitalize this string, or make it all lowercase.",
        abbr: null,
        negatable: true,
      ),
      verbose: (
        name: "verbose",
        help: "Enable verbose mode.",
        abbr: "v",
        negatable: false,
      ),
    );
  }

  ({OptionData repeat}) get options {
    return (
      repeat: (
        name: "repeat",
        help: "How many times to repeat the text. Defaults to 1.",
        type: "int",
        required: false,
      ),
    );
  }

  () get multiOptions {
    return ();
  }

  () get subcommands {
    return ();
  }
}

final class EchoCommandData {
  static final List<PositionalArgumentData> _positional = [];

  // ignore: unused_element
  static void _debug(String Function() input) {
    print('[Debug] [EchoCommand] ${input()}');
  }

  static bool runFromList(List<String> arguments) {
    try {
      final stopwatch = Stopwatch()..start();
      _runFromList(arguments, 0);
      stopwatch.stop();
      _debug(() => "Elapsed time: ${stopwatch.elapsedMicroseconds}us");
      return true;
    } on ParseException catch (e) {
      if (e.message != null) print(e.message);
      print("Usage: ${e.usage}");
      print("");
      print(e.object.buildHelp());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {}
    }

    final object = EchoCommand();

    if (arguments.contains("-h") || arguments.contains("--help")) {
      throw ParseException(null, object, object.usage);
    }

    if (object.settings.subcommandsOnly) {
      throw ParseException(
        "Subcommand is required.\nAvailable options: ",
        object,
        object.usage,
      );
    }

    // Makes it easy to get the next item when parsing things such as options
    final iterator = arguments.iterator;
    final maxPos = -1;

    final List<String> rest = [];
    final Set<String> setOptions = {};
    final Map<String, int> setMultiOptions = {};

    int pos = 0;
    bool foundArgument = false;

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;
      final noOptions = foundArgument && !object.settings.allowTrailingOptions;

      if (!noOptions && arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'help':
            throw ParseException(null, object, object.usage);
          case 'capitalize':
            object.capitalize = true;
            break;
          case 'verbose':
            object.verbose = true;
            break;
          case 'no-capitalize':
            object.capitalize = false;
            break;
          case 'repeat':
            // Converts strings into the preferred type
            final converter = object.getConverter(int);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for option repeat and type int.",
              );
            }

            if (!iterator.moveNext()) {
              throw ParseException(
                "Expected value for option 'repeat'.",
                object,
                object.usage,
              );
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw ParseException.advanced(
                converter.typePretty ?? "int",
                arg,
                converter.help(),
                object,
                object.usage,
              );
            }

            object.repeat = value;
            setOptions.add("repeat");
            break;

          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage,
            );
        }
      } else if (!noOptions && arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          case 'h':
            throw ParseException(null, object, object.usage);
          case 'v':
            object.verbose = !object.verbose;
            break;
          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage,
            );
        }
      } else if (pos <= maxPos) {
        final target = _positional[pos];
        final converter = object.getConverter(
          target.type,
        ); // Converts strings into the preferred type

        if (converter == null) {
          throw ConverterNotFoundError(
            "Converter not found for positional argument ${target.name} and type ${target.type}.",
          );
        }

        final value = converter.convert(arg);

        if (value == null) {
          throw ParseException.advanced(
            converter.typePretty ?? target.type.toString(),
            arg,
            converter.help(),
            object,
            object.usage,
          );
        }

        target.set(object, value);
        pos++;
        foundArgument = true;
      } else {
        if (!object.settings.allowRest) {
          throw ParseException(
            "Too many arguments. Expected 0, but got an extra: '$arg'",
            object,
            object.usage,
          );
        }

        rest.add(arg);
        pos++;
        foundArgument = true;
      }
    }

    if (_positional.elementAtOrNull(pos)?.required == true) {
      throw ParseException(
        "Positional argument '${_positional[pos].name}' is required.",
        object,
        object.usage,
      );
    }

    for (final String name in []) {
      if (!setOptions.contains(name)) {
        throw ParseException(
          "Option '$name' is required.",
          object,
          object.usage,
        );
      }
    }

    for (final (String name, int? min) in []) {
      if (min == null || min <= 0) continue;
      final count = setMultiOptions[name];

      if (count == null) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
          object,
          object.usage,
        );
      }

      if (count < min) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
          object,
          object.usage,
        );
      }
    }

    object.rest = rest;
    final validate = object.validate();

    if (validate != null) throw ParseException(validate, object, object.usage);
    object.onRun();
  }
}
