// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// CommandGenerator
// **************************************************************************

bool runCommands(List<String> arguments) {
  return ParentCommandData.runFromList(arguments);
}

extension ParentCommandHelp on ParentCommand {
  /// The default usage builder for this command.
  UsageBuilder defaultUsageBuilder() {
    return UsageBuilder()..addCustom(
      settings.restUsageName != null ? "...${settings.restUsageName}" : null,
    );
  }

  /// Builds the usage from either the provided builder or the default builder,
  /// then stringifies it.
  String get usage {
    return (buildUsage() ?? defaultUsageBuilder()).build();
  }

  /// All arguments as a list of [ArgumentData],
  /// ordered from first provided to last provided.
  List<ArgumentData> get allArguments {
    return [];
  }

  /// All Flags as a list of [FlagData],
  /// ordered from first provided to last provided.
  List<FlagData> get allflags {
    return [];
  }

  /// All options as a list of [OptionData],
  /// ordered from first provided to last provided.
  List<OptionData> get allOptions {
    return [];
  }

  /// All multi-options as a list of [MultiOptionData],
  /// ordered from first provided to last provided.
  List<MultiOptionData> get allMultiOptions {
    return [];
  }

  /// All subcommands as a list of [SubcommandData],
  /// ordered from first provided to last provided.
  List<SubcommandData> get allSubcommands {
    return [
      (name: "random", help: "Generate a random number."),
      (name: "echo", help: "Echo some text."),
      (name: "args", help: "Do some positional argument stuff!"),
    ];
  }

  /// All arguments as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get arguments {
    return ();
  }

  /// All flags as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get flags {
    return ();
  }

  /// All options as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get options {
    return ();
  }

  /// All multi-options as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get multiOptions {
    return ();
  }

  /// All subcommands as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  ({
    SubcommandData randomNumberCommand,
    SubcommandData echoCommand,
    SubcommandData printMyPositionalArgumentsCommand,
  })
  get subcommands {
    return (
      randomNumberCommand: (name: "random", help: "Generate a random number."),
      echoCommand: (name: "echo", help: "Echo some text."),
      printMyPositionalArgumentsCommand: (
        name: "args",
        help: "Do some positional argument stuff!",
      ),
    );
  }
}

final class ParentCommandData {
  static final List<PositionalArgumentData> _positional = [];

  // ignore: unused_element
  static void _debug(String Function() input) {}

  static bool runFromList(List<String> arguments) {
    try {
      _runFromList(arguments, 0);

      return true;
    } on ParseException catch (e) {
      if (e.message != null) print(e.message);
      print("Usage: ${e.usage}");
      print("");
      print(e.object.buildHelp().build());

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
        case 'args':
          return PrintMyPositionalArgumentsCommandData._runFromList(
            arguments,
            index + 1,
          );
      }
    }

    final object = ParentCommand();

    for (final converter in object.converters) {
      if (converter is! EnumConverter) continue;

      if (converter.type == Enum) {
        throw Exception(
          "You must specify a type for EnumConverter. Trust me, I learned this the hard way.",
        );
      }
    }

    if (arguments.contains("-h") || arguments.contains("--help")) {
      throw ParseException(null, object, object.usage);
    }

    if (object.settings.subcommandsOnly) {
      throw ParseException(
        "Subcommand is required.\nAvailable options: random, echo, args",
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
          throw ParseException.fromConversionError(
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
  /// The default usage builder for this command.
  UsageBuilder defaultUsageBuilder() {
    return UsageBuilder()
      ..addFlag(flags.secure)
      ..addFlag(flags.timed)
      ..addFlag(flags.verbose)
      ..addOption(options.min)
      ..addOption(options.max)
      ..addMultiOption(multiOptions.avoids)
      ..addCustom(
        settings.restUsageName != null ? "...${settings.restUsageName}" : null,
      );
  }

  /// Builds the usage from either the provided builder or the default builder,
  /// then stringifies it.
  String get usage {
    return (buildUsage() ?? defaultUsageBuilder()).build();
  }

  /// All arguments as a list of [ArgumentData],
  /// ordered from first provided to last provided.
  List<ArgumentData> get allArguments {
    return [];
  }

  /// All Flags as a list of [FlagData],
  /// ordered from first provided to last provided.
  List<FlagData> get allflags {
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

  /// All options as a list of [OptionData],
  /// ordered from first provided to last provided.
  List<OptionData> get allOptions {
    return [
      (
        name: "min",
        help: "Min number to generate, inclusive. Defaults to 0.",
        abbr: null,
        type: "int",
        required: false,
      ),
      (
        name: "max",
        help: "Max number to generate, inclusive. Defaults to 100.",
        abbr: null,
        type: "int",
        required: false,
      ),
    ];
  }

  /// All multi-options as a list of [MultiOptionData],
  /// ordered from first provided to last provided.
  List<MultiOptionData> get allMultiOptions {
    return [
      (
        name: "avoid",
        help: "Numbers to avoid choosing.",
        abbr: "a",
        type: "int",
        min: null,
      ),
    ];
  }

  /// All subcommands as a list of [SubcommandData],
  /// ordered from first provided to last provided.
  List<SubcommandData> get allSubcommands {
    return [];
  }

  /// All arguments as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get arguments {
    return ();
  }

  /// All flags as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
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

  /// All options as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  ({OptionData min, OptionData max}) get options {
    return (
      min: (
        name: "min",
        help: "Min number to generate, inclusive. Defaults to 0.",
        abbr: null,
        type: "int",
        required: false,
      ),
      max: (
        name: "max",
        help: "Max number to generate, inclusive. Defaults to 100.",
        abbr: null,
        type: "int",
        required: false,
      ),
    );
  }

  /// All multi-options as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  ({MultiOptionData avoids}) get multiOptions {
    return (
      avoids: (
        name: "avoid",
        help: "Numbers to avoid choosing.",
        abbr: "a",
        type: "int",
        min: null,
      ),
    );
  }

  /// All subcommands as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get subcommands {
    return ();
  }
}

final class RandomNumberCommandData {
  static final List<PositionalArgumentData> _positional = [];

  // ignore: unused_element
  static void _debug(String Function() input) {}

  static bool runFromList(List<String> arguments) {
    try {
      _runFromList(arguments, 0);

      return true;
    } on ParseException catch (e) {
      if (e.message != null) print(e.message);
      print("Usage: ${e.usage}");
      print("");
      print(e.object.buildHelp().build());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {}
    }

    final object = RandomNumberCommand();

    for (final converter in object.converters) {
      if (converter is! EnumConverter) continue;

      if (converter.type == Enum) {
        throw Exception(
          "You must specify a type for EnumConverter. Trust me, I learned this the hard way.",
        );
      }
    }

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

            try {
              final value = converter.convert(iterator.current);

              if (value == null) {
                throw ParseException.fromConversionError(
                  converter.typePretty ?? "int",
                  arg,
                  converter.help(),
                  object,
                  object.usage,
                );
              }

              object.min = value;
              setOptions.add("min");
            } catch (e) {
              throw ParseException(
                "An unexpected error happened while parsing argument 'min':\n$e\nParsing: '$arg' to int\nIf you are a developer, please change your converter to catch its own exceptions.",
                object,
                object.usage,
              );
            }

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

            try {
              final value = converter.convert(iterator.current);

              if (value == null) {
                throw ParseException.fromConversionError(
                  converter.typePretty ?? "int",
                  arg,
                  converter.help(),
                  object,
                  object.usage,
                );
              }

              object.max = value;
              setOptions.add("max");
            } catch (e) {
              throw ParseException(
                "An unexpected error happened while parsing argument 'max':\n$e\nParsing: '$arg' to int\nIf you are a developer, please change your converter to catch its own exceptions.",
                object,
                object.usage,
              );
            }

            break;
          case 'avoid':
            // Converts strings into the preferred type
            final converter = object.getConverter(int);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for multi-option avoid and type List<int>.",
              );
            }

            if (!iterator.moveNext()) {
              throw ParseException(
                "Expected value for option 'avoid'.",
                object,
                object.usage,
              );
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw ParseException.fromConversionError(
                converter.typePretty ?? "int",
                arg,
                converter.help(),
                object,
                object.usage,
              );
            }

            object.avoids.add(value);
            setMultiOptions["avoid"] = (setMultiOptions["avoid"] ?? 0) + 1;
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

          case 'a':
            // Converts strings into the preferred type
            final converter = object.getConverter(int);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for multi-option avoid and type List<int>.",
              );
            }

            if (!iterator.moveNext()) {
              throw ParseException(
                "Expected value for option 'avoid'.",
                object,
                object.usage,
              );
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw ParseException.fromConversionError(
                converter.typePretty ?? "int",
                arg,
                converter.help(),
                object,
                object.usage,
              );
            }

            object.avoids.add(value);
            setMultiOptions["avoid"] = (setMultiOptions["avoid"] ?? 0) + 1;
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
          throw ParseException.fromConversionError(
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

    for (final (String name, int? min) in [("avoid", null)]) {
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
  /// The default usage builder for this command.
  UsageBuilder defaultUsageBuilder() {
    return UsageBuilder()
      ..addFlag(flags.capitalize)
      ..addFlag(flags.verbose)
      ..addOption(options.repeat)
      ..addCustom(
        settings.restUsageName != null ? "...${settings.restUsageName}" : null,
      );
  }

  /// Builds the usage from either the provided builder or the default builder,
  /// then stringifies it.
  String get usage {
    return (buildUsage() ?? defaultUsageBuilder()).build();
  }

  /// All arguments as a list of [ArgumentData],
  /// ordered from first provided to last provided.
  List<ArgumentData> get allArguments {
    return [];
  }

  /// All Flags as a list of [FlagData],
  /// ordered from first provided to last provided.
  List<FlagData> get allflags {
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

  /// All options as a list of [OptionData],
  /// ordered from first provided to last provided.
  List<OptionData> get allOptions {
    return [
      (
        name: "repeat",
        help: "How many times to repeat the text. Defaults to 1.",
        abbr: "r",
        type: "int",
        required: false,
      ),
    ];
  }

  /// All multi-options as a list of [MultiOptionData],
  /// ordered from first provided to last provided.
  List<MultiOptionData> get allMultiOptions {
    return [];
  }

  /// All subcommands as a list of [SubcommandData],
  /// ordered from first provided to last provided.
  List<SubcommandData> get allSubcommands {
    return [];
  }

  /// All arguments as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get arguments {
    return ();
  }

  /// All flags as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
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

  /// All options as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  ({OptionData repeat}) get options {
    return (
      repeat: (
        name: "repeat",
        help: "How many times to repeat the text. Defaults to 1.",
        abbr: "r",
        type: "int",
        required: false,
      ),
    );
  }

  /// All multi-options as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get multiOptions {
    return ();
  }

  /// All subcommands as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get subcommands {
    return ();
  }
}

final class EchoCommandData {
  static final List<PositionalArgumentData> _positional = [];

  // ignore: unused_element
  static void _debug(String Function() input) {}

  static bool runFromList(List<String> arguments) {
    try {
      _runFromList(arguments, 0);

      return true;
    } on ParseException catch (e) {
      if (e.message != null) print(e.message);
      print("Usage: ${e.usage}");
      print("");
      print(e.object.buildHelp().build());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {}
    }

    final object = EchoCommand();

    for (final converter in object.converters) {
      if (converter is! EnumConverter) continue;

      if (converter.type == Enum) {
        throw Exception(
          "You must specify a type for EnumConverter. Trust me, I learned this the hard way.",
        );
      }
    }

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

            try {
              final value = converter.convert(iterator.current);

              if (value == null) {
                throw ParseException.fromConversionError(
                  converter.typePretty ?? "int",
                  arg,
                  converter.help(),
                  object,
                  object.usage,
                );
              }

              object.repeat = value;
              setOptions.add("repeat");
            } catch (e) {
              throw ParseException(
                "An unexpected error happened while parsing argument 'repeat':\n$e\nParsing: '$arg' to int\nIf you are a developer, please change your converter to catch its own exceptions.",
                object,
                object.usage,
              );
            }

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
          case 'r':
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

            try {
              final value = converter.convert(iterator.current);

              if (value == null) {
                throw ParseException.fromConversionError(
                  converter.typePretty ?? "int",
                  arg,
                  converter.help(),
                  object,
                  object.usage,
                );
              }

              object.repeat = value;
              setOptions.add("repeat");
            } catch (e) {
              throw ParseException(
                "An unexpected error happened while parsing argument 'repeat':\n$e\nParsing: '$arg' to int\nIf you are a developer, please change your converter to catch its own exceptions.",
                object,
                object.usage,
              );
            }

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
          throw ParseException.fromConversionError(
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

extension PrintMyPositionalArgumentsCommandHelp
    on PrintMyPositionalArgumentsCommand {
  /// The default usage builder for this command.
  UsageBuilder defaultUsageBuilder() {
    return UsageBuilder()
      ..addFlag(flags.verbose)
      ..addArgument(arguments.arg1)
      ..addArgument(arguments.arg2)
      ..addArgument(arguments.arg3)
      ..addCustom(
        settings.restUsageName != null ? "...${settings.restUsageName}" : null,
      );
  }

  /// Builds the usage from either the provided builder or the default builder,
  /// then stringifies it.
  String get usage {
    return (buildUsage() ?? defaultUsageBuilder()).build();
  }

  /// All arguments as a list of [ArgumentData],
  /// ordered from first provided to last provided.
  List<ArgumentData> get allArguments {
    return [
      (name: "arg1", help: "An argument!", required: true),
      (name: "arg2", help: "An argument?", required: true),
      (name: "arg3", help: "An argument...", required: false),
    ];
  }

  /// All Flags as a list of [FlagData],
  /// ordered from first provided to last provided.
  List<FlagData> get allflags {
    return [
      (
        name: "verbose",
        help: "Enable verbose mode.",
        abbr: "v",
        negatable: false,
      ),
    ];
  }

  /// All options as a list of [OptionData],
  /// ordered from first provided to last provided.
  List<OptionData> get allOptions {
    return [];
  }

  /// All multi-options as a list of [MultiOptionData],
  /// ordered from first provided to last provided.
  List<MultiOptionData> get allMultiOptions {
    return [];
  }

  /// All subcommands as a list of [SubcommandData],
  /// ordered from first provided to last provided.
  List<SubcommandData> get allSubcommands {
    return [];
  }

  /// All arguments as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  ({ArgumentData arg1, ArgumentData arg2, ArgumentData arg3}) get arguments {
    return (
      arg1: (name: "arg1", help: "An argument!", required: true),
      arg2: (name: "arg2", help: "An argument?", required: true),
      arg3: (name: "arg3", help: "An argument...", required: false),
    );
  }

  /// All flags as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  ({FlagData verbose}) get flags {
    return (
      verbose: (
        name: "verbose",
        help: "Enable verbose mode.",
        abbr: "v",
        negatable: false,
      ),
    );
  }

  /// All options as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get options {
    return ();
  }

  /// All multi-options as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get multiOptions {
    return ();
  }

  /// All subcommands as a type-safe record,
  /// in a similar structure to TypeScript's interfaces.
  () get subcommands {
    return ();
  }
}

final class PrintMyPositionalArgumentsCommandData {
  static final List<PositionalArgumentData> _positional = [
    (
      name: 'arg1',
      type: String,
      set: (Command object, dynamic value) =>
          (object as PrintMyPositionalArgumentsCommand).arg1 = value,
      required: true,
    ),
    (
      name: 'arg2',
      type: int,
      set: (Command object, dynamic value) =>
          (object as PrintMyPositionalArgumentsCommand).arg2 = value,
      required: true,
    ),
    (
      name: 'arg3',
      type: bool,
      set: (Command object, dynamic value) =>
          (object as PrintMyPositionalArgumentsCommand).arg3 = value,
      required: false,
    ),
  ];

  // ignore: unused_element
  static void _debug(String Function() input) {}

  static bool runFromList(List<String> arguments) {
    try {
      _runFromList(arguments, 0);

      return true;
    } on ParseException catch (e) {
      if (e.message != null) print(e.message);
      print("Usage: ${e.usage}");
      print("");
      print(e.object.buildHelp().build());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {}
    }

    final object = PrintMyPositionalArgumentsCommand();

    for (final converter in object.converters) {
      if (converter is! EnumConverter) continue;

      if (converter.type == Enum) {
        throw Exception(
          "You must specify a type for EnumConverter. Trust me, I learned this the hard way.",
        );
      }
    }

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
    final maxPos = 2;

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
          case 'verbose':
            object.verbose = true;
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
          throw ParseException.fromConversionError(
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
            "Too many arguments. Expected 3, but got an extra: '$arg'",
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
