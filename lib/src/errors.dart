import 'package:advanced_cli/advanced_cli.dart';

class ConverterNotFoundError extends Error {
  final String message;

  ConverterNotFoundError(this.message);

  @override
  String toString() {
    return "ConverterNotFoundError: $message";
  }
}

class ParseException implements Exception {
  final String? message;
  final Command object;
  final String usage;

  new(this.message, this.object, this.usage);
  ParseException.advanced(String type, String got, String? help, this.object, this.usage) : message = ["Couldn't parse input to type '$type': $got", ?help].join("\n");

  @override
  String toString() {
    return "ParseException: $message";
  }
}