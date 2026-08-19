class ConverterNotFoundError extends Error {
  final String message;

  ConverterNotFoundError(this.message);

  @override
  String toString() {
    return "ConverterNotFoundError: $message";
  }
}

class ParseException implements Exception {
  final String type;
  final String got;
  final String? help;

  ParseException(this.type, this.got, this.help);

  @override
  String toString() {
    return "ParseException(type=$type, help=${help.runtimeType}), got: $got";
  }
}

class CustomParseException implements Exception {
  final String message;

  CustomParseException(this.message);

  @override
  String toString() {
    return "ParseException: $message";
  }
}