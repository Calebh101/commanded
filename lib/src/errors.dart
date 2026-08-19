class ConverterNotFoundError extends Error {
  final String message;

  ConverterNotFoundError(this.message);

  @override
  String toString() {
    return "ConverterNotFoundError: $message";
  }
}

class ParseException implements Exception {
  final String message;

  new(this.message);

  @override
  String toString() {
    return "ParseException: $message";
  }
}

class AdvancedParseException extends ParseException {
  final String type;
  final String got;
  final String? help;

  AdvancedParseException(this.type, this.got, this.help) : super(["Couldn't parse input to type '$type': $got", ?help].join("\n"));
}