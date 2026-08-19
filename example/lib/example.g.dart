// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// CommandGenerator
// **************************************************************************

void processArgs(List<String> arguments) {
  return MyCommandCommandData.runFromList(arguments);
}

final class MyCommandCommandData {
  static final positional = [
    (
      name: 'argument',
      type: String,
      set: (MyCommand object, dynamic value) => object.myArgument = value,
    ),
  ];

  static void runFromList(List<String> arguments, [int i = 0]) {
    if (arguments.length > i) {
      switch (arguments[i]) {
        case 'subcommand':
          return MyOtherCommandCommandData.runFromList(arguments, i + 1);
      }
    }

    final object = MyCommand();
    final iterator = arguments.iterator;
    int pos = 0;

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'flag':
            object.myFlag = !object.myFlag;
            break;
          case 'option':
            final converter = object.checkConverter(String);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for option option and type String.",
              );
            }

            if (!iterator.moveNext()) {
              throw CustomParseException("Expected value for option option.");
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw ParseException("String", arg, converter.help());
            }

            object.myOption = value;
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {}
      } else if (pos < 1) {
        final target = positional[i];
        final converter = object.checkConverter(target.runtimeType);

        if (converter == null) {
          throw ConverterNotFoundError(
            "Converter not found for positional argument ${target.name} and type ${target.type}.",
          );
        }

        final value = converter.convert(arg);

        if (value == null) {
          throw ParseException("${target.type}", arg, converter.help());
        }

        target.set(object, value);
      }
    }

    object.onRun();
  }
}

final class MyOtherCommandCommandData {
  static final positional = [];

  static void runFromList(List<String> arguments, [int i = 0]) {
    if (arguments.length > i) {
      switch (arguments[i]) {}
    }

    final object = MyOtherCommand();
    final iterator = arguments.iterator;
    int pos = 0;

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'flag':
            object.myOtherFlag = !object.myOtherFlag;
            break;
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          case 'f':
            object.myOtherFlag = !object.myOtherFlag;
            break;
        }
      } else if (pos < 0) {
        final target = positional[i];
        final converter = object.checkConverter(target.runtimeType);

        if (converter == null) {
          throw ConverterNotFoundError(
            "Converter not found for positional argument ${target.name} and type ${target.type}.",
          );
        }

        final value = converter.convert(arg);

        if (value == null) {
          throw ParseException("${target.type}", arg, converter.help());
        }

        target.set(object, value);
      }
    }

    object.onRun();
  }
}
