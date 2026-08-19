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

  // ignore: unused_element
  static void _debug(String Function() input) {}

  static void runFromList(List<String> arguments, [int index = 0]) {
    if (arguments.length > index) {
      switch (arguments[index]) {
        case 'subcommand':
          return MyOtherCommandCommandData.runFromList(arguments, index + 1);
      }
    }

    final iterator = arguments.iterator;
    final object = MyCommand();
    final maxPos = 0;

    int pos = 0;
    final List<String> rest = [];

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'flag':
            object.myFlag = !object.myFlag;
            break;
          case 'verbose':
            object.verbose = !object.verbose;
            break;
          case 'option':
            final converter = object.getConverter(String);

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
          case 'device':
            final converter = object.getConverter(String);

            if (converter == null) {
              throw ConverterNotFoundError(
                "Converter not found for multi-option device and type List<String>.",
              );
            }

            if (!iterator.moveNext()) {
              throw CustomParseException("Expected value for option device.");
            }

            final value = converter.convert(iterator.current);

            if (value == null) {
              throw ParseException("String", arg, converter.help());
            }

            object.devices.add(value);
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {}
      } else if (pos <= maxPos) {
        final target = positional[pos];
        final converter = object.getConverter(target.type);

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
        pos++;
      } else {
        rest.add(arg);
      }
    }

    object.rest = rest;
    object.onRun();
  }
}

final class MyOtherCommandCommandData {
  static final positional = [];

  // ignore: unused_element
  static void _debug(String Function() input) {}

  static void runFromList(List<String> arguments, [int index = 0]) {
    if (arguments.length > index) {
      switch (arguments[index]) {}
    }

    final iterator = arguments.iterator;
    final object = MyOtherCommand();
    final maxPos = -1;

    int pos = 0;
    final List<String> rest = [];

    for (int i = 0; i < index; i++) {
      iterator.moveNext();
    }

    while (iterator.moveNext()) {
      final arg = iterator.current;

      if (arg.startsWith("--")) {
        switch (arg.replaceFirst("--", "")) {
          case 'flag':
            object.myOtherFlag = !object.myOtherFlag;
            break;
          case 'verbose':
            object.verbose = !object.verbose;
            break;
        }
      } else if (arg.startsWith("-")) {
        switch (arg.replaceFirst("-", "")) {
          case 'f':
            object.myOtherFlag = !object.myOtherFlag;
            break;
        }
      } else if (pos <= maxPos) {
        final target = positional[pos];
        final converter = object.getConverter(target.type);

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
        pos++;
      } else {
        rest.add(arg);
      }
    }

    object.rest = rest;
    object.onRun();
  }
}
