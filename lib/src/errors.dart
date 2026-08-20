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

  @override
  String toString() {
    return "ParseException: $message";
  }
}

class AdvancedParseException extends ParseException {
  final String type;
  final String got;
  final String? help;

  AdvancedParseException(this.type, this.got, this.help, Command object, String usage) : super(["Couldn't parse input to type '$type': $got", ?help].join("\n"), object, usage);
}