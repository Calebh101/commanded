// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// CommandGenerator
// **************************************************************************

bool runCommands(List<String> arguments) {
  return MyCommandData.runFromList(arguments);
}

extension MyCommandHelp on MyCommand {
  String usage() {
    return [
      name,
      ...["[--flag]", "--otherflag", "[--verbose]"],
      ...["--option <option>", "[--otheroption <otheroption>]"],
      ...["argument"],
      if (restName != null) "...$restName",
    ].join(" ");
  }

  List<ArgumentData> get allArguments {
    return [(name: "argument", help: "A position argument?", required: true)];
  }

  List<FlagData> get allFlags {
    return [
      (name: "flag", help: "A binary flag!!", abbr: null, negatable: false),
      (
        name: "otherflag",
        help: "A flag that is negatable",
        abbr: null,
        negatable: true,
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
      (name: "option", help: "An option!", type: "String", required: true),
      (
        name: "otheroption",
        help: "Another option?!",
        type: "String?",
        required: false,
      ),
    ];
  }

  List<MultiOptionData> get allMultiOptions {
    return [
      (name: "device", help: "A list of devices.", type: "String", min: null),
    ];
  }

  List<SubcommandData> get allSubcommands {
    return [(name: "subcommand", help: "A subcommand...")];
  }

  ({ArgumentData myArgument}) get arguments {
    return (
      myArgument: (
        name: "argument",
        help: "A position argument?",
        required: true,
      ),
    );
  }

  ({FlagData myFlag, FlagData myOtherFlag, FlagData verbose}) get flags {
    return (
      myFlag: (
        name: "flag",
        help: "A binary flag!!",
        abbr: null,
        negatable: false,
      ),
      myOtherFlag: (
        name: "otherflag",
        help: "A flag that is negatable",
        abbr: null,
        negatable: true,
      ),
      verbose: (
        name: "verbose",
        help: "Enable verbose mode.",
        abbr: null,
        negatable: false,
      ),
    );
  }

  ({OptionData myOption, OptionData otherOption}) get options {
    return (
      myOption: (
        name: "option",
        help: "An option!",
        type: "String",
        required: true,
      ),
      otherOption: (
        name: "otheroption",
        help: "Another option?!",
        type: "String?",
        required: false,
      ),
    );
  }

  ({MultiOptionData devices}) get multiOptions {
    return (
      devices: (
        name: "device",
        help: "A list of devices.",
        type: "String",
        min: null,
      ),
    );
  }

  ({SubcommandData myOtherCommand}) get subcommands {
    return (myOtherCommand: (name: "subcommand", help: "A subcommand..."));
  }
}

final class MyCommandData {
  static final List<PositionalArgumentData> _positional = [
    (
      name: 'argument',
      type: String,
      set: (Command object, dynamic value) =>
          (object as MyCommand).myArgument = value,
      required: true,
    ),
  ];

  // ignore: unused_element
  static void _debug(String Function() input) {}

  static bool runFromList(List<String> arguments) {
    try {
      _runFromList(arguments, 0);
      return true;
    } on ParseException catch (e) {
      _debug(() => e.toString());
      final object = MyCommand();

      print(e.message);
      print("Usage: ${object.usage()}");
      print("");
      print(object.buildHelp());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {
        case 'subcommand':
          return MyOtherCommandData._runFromList(arguments, index + 1);
      }
    }

    // Makes it easy to get the next item when parsing things such as options
    final iterator = arguments.iterator;
    final object = MyCommand();
    final maxPos = 0;

    final List<String> rest = [];
    final Set<String> setOptions = {};
    final Map<String, int> setMultiOptions = {};

    int pos = 0;

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'flag':
            object.myFlag = true;
            break;
          case 'otherflag':
            object.myOtherFlag = true;
            break;
          case 'verbose':
            object.verbose = true;
            break;
          case 'no-otherflag':
            object.myOtherFlag = false;
            break;
          case 'option':
            // Converts strings into the preferred type
            final converter = object.getConverter(String);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for option option and type String.",
              );
            }

            if (!iterator.moveNext()) {
              throw ParseException("Expected value for option 'option'.");
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw AdvancedParseException(
                converter.typePretty ?? "String",
                arg,
                converter.help(),
              );
            }

            object.myOption = value;
            setOptions.add("option");
            break;
          case 'otheroption':
            // Converts strings into the preferred type
            final converter = object.getConverter(String);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for option otheroption and type String.",
              );
            }

            if (!iterator.moveNext()) {
              throw ParseException("Expected value for option 'otheroption'.");
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw AdvancedParseException(
                converter.typePretty ?? "String",
                arg,
                converter.help(),
              );
            }

            object.otherOption = value;
            setOptions.add("otheroption");
            break;
          case 'device':
            // Converts strings into the preferred type
            final converter = object.getConverter(String);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for multi-option device and type List<String>.",
              );
            }

            if (!iterator.moveNext()) {
              throw ParseException("Expected value for option 'device'.");
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw AdvancedParseException(
                converter.typePretty ?? "String",
                arg,
                converter.help(),
              );
            }

            object.devices.add(value);
            setMultiOptions["device"] = (setMultiOptions["device"] ?? 0) + 1;
            break;
          default:
            throw ParseException("Invalid flag/option: $arg");
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          default:
            throw ParseException("Invalid flag/option: $arg");
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
          );
        }

        target.set(object, value);
        pos++;
      } else {
        rest.add(arg);
      }
    }

    if (_positional.elementAtOrNull(pos)?.required == true) {
      throw ParseException(
        "Positional argument '${_positional[pos].name}' is required.",
      );
    }

    for (final String name in ["option"]) {
      if (!setOptions.contains(name)) {
        throw ParseException("Option '$name' is required.");
      }
    }

    for (final (String name, int? min) in [("device", null)]) {
      if (min == null || min <= 0) continue;
      final count = setMultiOptions[name];

      if (count == null) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
        );
      }

      if (count < min) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
        );
      }
    }

    object.rest = rest;
    object.onRun();
  }
}

extension MyOtherCommandHelp on MyOtherCommand {
  String usage() {
    return [
      name,
      ...["[--flag/-f]", "[--verbose]"],
      ...[],
      ...[],
      if (restName != null) "...$restName",
    ].join(" ");
  }

  List<ArgumentData> get allArguments {
    return [];
  }

  List<FlagData> get allFlags {
    return [
      (name: "flag", help: null, abbr: "f", negatable: false),
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
    return [];
  }

  () get arguments {
    return ();
  }

  ({FlagData myOtherFlag, FlagData verbose}) get flags {
    return (
      myOtherFlag: (name: "flag", help: null, abbr: "f", negatable: false),
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

  () get subcommands {
    return ();
  }
}

final class MyOtherCommandData {
  static final List<PositionalArgumentData> _positional = [];

  // ignore: unused_element
  static void _debug(String Function() input) {}

  static bool runFromList(List<String> arguments) {
    try {
      _runFromList(arguments, 0);
      return true;
    } on ParseException catch (e) {
      _debug(() => e.toString());
      final object = MyOtherCommand();

      print(e.message);
      print("Usage: ${object.usage()}");
      print("");
      print(object.buildHelp());

      return false;
    }
  }

  static void _runFromList(List<String> arguments, int index) {
    if (arguments.length > index) {
      switch (arguments[index]) {}
    }

    // Makes it easy to get the next item when parsing things such as options
    final iterator = arguments.iterator;
    final object = MyOtherCommand();
    final maxPos = -1;

    final List<String> rest = [];
    final Set<String> setOptions = {};
    final Map<String, int> setMultiOptions = {};

    int pos = 0;

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'flag':
            object.myOtherFlag = true;
            break;
          case 'verbose':
            object.verbose = true;
            break;

          default:
            throw ParseException("Invalid flag/option: $arg");
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          case 'f':
            object.myOtherFlag = !object.myOtherFlag;
            break;
          default:
            throw ParseException("Invalid flag/option: $arg");
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
          );
        }

        target.set(object, value);
        pos++;
      } else {
        rest.add(arg);
      }
    }

    if (_positional.elementAtOrNull(pos)?.required == true) {
      throw ParseException(
        "Positional argument '${_positional[pos].name}' is required.",
      );
    }

    for (final String name in []) {
      if (!setOptions.contains(name)) {
        throw ParseException("Option '$name' is required.");
      }
    }

    for (final (String name, int? min) in []) {
      if (min == null || min <= 0) continue;
      final count = setMultiOptions[name];

      if (count == null) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
        );
      }

      if (count < min) {
        throw ParseException(
          "Multi-option '$name' requires at least $min items.",
        );
      }
    }

    object.rest = rest;
    object.onRun();
  }
}
