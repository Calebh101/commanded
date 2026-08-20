// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// CommandGenerator
// **************************************************************************

bool runCommands(List<String> arguments) {
  return ParentCommandData.runFromList(arguments);
}

extension ParentCommandHelp on ParentCommand {
  String usage() {
    return [
      name,
      ...["[--verbose]"],
      ...[],
      ...[],
      if (settings.restUsageName != null) "...${settings.restUsageName}",
    ].join(" ");
  }

  List<ArgumentData> get allArguments {
    return [];
  }

  List<FlagData> get allFlags {
    return [
      (
        name: "verbose",
        help: "Enable verbose mode.",
        abbr: null,
        negatable: false,
      ),
    ];
  }

  List<OptionData> get allOptions {
    return [];
  }

  List<MultiOptionData> get allMultiOptions {
    return [];
  }

  List<SubcommandData> get allSubcommands {
    return [(name: "random", help: "Generate a random number.")];
  }

  () get arguments {
    return ();
  }

  ({FlagData verbose}) get flags {
    return (
      verbose: (
        name: "verbose",
        help: "Enable verbose mode.",
        abbr: null,
        negatable: false,
      ),
    );
  }

  () get options {
    return ();
  }

  () get multiOptions {
    return ();
  }

  ({SubcommandData randomNumberCommand}) get subcommands {
    return (
      randomNumberCommand: (name: "random", help: "Generate a random number."),
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
      print(e.object.buildHelp());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {
        case 'random':
          return RandomNumberCommandData._runFromList(arguments, index + 1);
      }
    }

    final object = ParentCommand();

    if (arguments.contains("-h") || arguments.contains("--help")) {
      throw ParseException(null, object, object.usage());
    }

    if (object.settings.subcommandsOnly) {
      throw ParseException(
        "Subcommand is required.\nAvailable options: random",
        object,
        object.usage(),
      );
    }

    // Makes it easy to get the next item when parsing things such as options
    final iterator = arguments.iterator;
    final maxPos = -1;

    final List<String> rest = [];
    final Set<String> setOptions = {};
    final Map<String, int> setMultiOptions = {};

    int pos = index;

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'help':
            throw ParseException(null, object, object.usage());
          case 'verbose':
            object.verbose = true;
            break;

          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage(),
            );
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          case 'h':
            throw ParseException(null, object, object.usage());

          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage(),
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
          throw AdvancedParseException(
            converter.typePretty ?? target.type.toString(),
            arg,
            converter.help(),
            object,
            object.usage(),
          );
        }

        target.set(object, value);
        pos++;
      } else {
        if (!object.settings.allowRest) {
          throw ParseException(
            "Too many arguments. Expected 0, but got an extra: '$arg'",
            object,
            object.usage(),
          );
        }

        rest.add(arg);
        pos++;
      }
    }

    if (_positional.elementAtOrNull(pos)?.required == true) {
      throw ParseException(
        "Positional argument '${_positional[pos].name}' is required.",
        object,
        object.usage(),
      );
    }

    for (final String name in []) {
      if (!setOptions.contains(name)) {
        throw ParseException(
          "Option '$name' is required.",
          object,
          object.usage(),
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
          object.usage(),
        );
      }

      if (count < min) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
          object,
          object.usage(),
        );
      }
    }

    object.rest = rest;
    object.onRun();
  }
}

extension RandomNumberCommandHelp on RandomNumberCommand {
  String usage() {
    return [
      name,
      ...["[--secure/-s]", "[--timed/-t]", "[--verbose]"],
      ...["[--min <min>]", "[--max <max>]"],
      ...[],
      if (settings.restUsageName != null) "...${settings.restUsageName}",
    ].join(" ");
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
        abbr: null,
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
        abbr: null,
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
  static void _debug(String Function() input) {}

  static bool runFromList(List<String> arguments) {
    try {
      _runFromList(arguments, 0);
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
      throw ParseException(null, object, object.usage());
    }

    if (object.settings.subcommandsOnly) {
      throw ParseException(
        "Subcommand is required.\nAvailable options: ",
        object,
        object.usage(),
      );
    }

    // Makes it easy to get the next item when parsing things such as options
    final iterator = arguments.iterator;
    final maxPos = -1;

    final List<String> rest = [];
    final Set<String> setOptions = {};
    final Map<String, int> setMultiOptions = {};

    int pos = index;

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'help':
            throw ParseException(null, object, object.usage());
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
                object.usage(),
              );
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw AdvancedParseException(
                converter.typePretty ?? "int",
                arg,
                converter.help(),
                object,
                object.usage(),
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
                object.usage(),
              );
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw AdvancedParseException(
                converter.typePretty ?? "int",
                arg,
                converter.help(),
                object,
                object.usage(),
              );
            }

            object.max = value;
            setOptions.add("max");
            break;

          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage(),
            );
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          case 'h':
            throw ParseException(null, object, object.usage());
          case 's':
            object.secure = !object.secure;
            break;
          case 't':
            object.timed = !object.timed;
            break;
          default:
            throw ParseException(
              "Invalid flag/option: $arg",
              object,
              object.usage(),
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
          throw AdvancedParseException(
            converter.typePretty ?? target.type.toString(),
            arg,
            converter.help(),
            object,
            object.usage(),
          );
        }

        target.set(object, value);
        pos++;
      } else {
        if (!object.settings.allowRest) {
          throw ParseException(
            "Too many arguments. Expected 0, but got an extra: '$arg'",
            object,
            object.usage(),
          );
        }

        rest.add(arg);
        pos++;
      }
    }

    if (_positional.elementAtOrNull(pos)?.required == true) {
      throw ParseException(
        "Positional argument '${_positional[pos].name}' is required.",
        object,
        object.usage(),
      );
    }

    for (final String name in []) {
      if (!setOptions.contains(name)) {
        throw ParseException(
          "Option '$name' is required.",
          object,
          object.usage(),
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
          object.usage(),
        );
      }

      if (count < min) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
          object,
          object.usage(),
        );
      }
    }

    object.rest = rest;
    object.onRun();
  }
}
