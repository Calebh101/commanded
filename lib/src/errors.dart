import 'package:commands/commands.dart';

/// This is thrown when a converter was looked for by the parser, but not found.
///
/// Reminder that converter types have to match exactly!
/// `Converter<num>` will not cover `Converter<int>`!
class ConverterNotFoundError extends Error {
  /// Message for this error.
  final String message;

  /// This is thrown when a converter was looked for by the parser, but not found.
  ///
  /// Reminder that converter types have to match exactly!
  /// `Converter<num>` will not cover `Converter<int>`!
  ConverterNotFoundError(this.message);

  @override
  String toString() {
    return "ConverterNotFoundError: $message";
  }
}

/// This is thrown when an exception occurs while parsing arguments,
/// specifically upon invalid arguments from the user.
///
/// This is normally caught in `runFromList` and taken care of.
class ParseException implements Exception {
  /// The message of this error.
  final String? message;

  /// The `Command` object of this error, for showing help.
  final Command object;

  /// The usage of the command of this error, for showing help.
  ///
  /// This has to be provided separately,
  /// because `usage` is generated via extension methods on specific types.
  final String usage;

  /// This is thrown when an exception occurs while parsing arguments,
  /// specifically upon invalid arguments from the user.
  ///
  /// This is normally caught in `runFromList` and taken care of.
  ParseException(this.message, this.object, this.usage);

  /// Represents specifically parse errors from converters.
  ///
  /// So if `Converter<int>` received `123a` and returned null, this would be thrown.
  ParseException.fromConversionError(String type, String got, String? help, this.object, this.usage) : message = ["Couldn't parse input to type '$type': $got", ?help].join("\n");

  @override
  String toString() {
    return "ParseException: $message";
  }
}