import 'dart:convert';

import 'package:commands/src/classes.dart';
import 'package:collection/collection.dart';

class BoolConverter extends Converter<bool> {
  @override
  convert(String input) {
    final value = input.trim().toLowerCase();
    final number = num.tryParse(value);

    if (number != null) return number > 0;
    return value == "y" || value == "yes" || value == "true";
  }

  @override
  String help() {
    return "Supported values: 0/1, y, yes, true";
  }
}

class DoubleConverter extends Converter<double> {
  @override
  convert(String input) {
    return .tryParse(input);
  }
}

class BasicEnumConverter<T extends Enum> extends Converter<T> {
  final List<T> values;

  BasicEnumConverter(this.values);

  @override
  convert(String input) {
    final value = input.trim().toLowerCase();
    final i = int.tryParse(value);

    if (i != null && i < values.length) return values[i];
    return values.firstWhereOrNull((x) => x.name == value);
  }

  @override
  String help() {
    return "Supported values: ${values.map((x) => x.name).join(", ")}";
  }
}

class IntConverter extends Converter<int> {
  @override
  convert(String input) {
    return .tryParse(input);
  }
}

class JsonConverter extends Converter<dynamic> {
  @override
  convert(String input) {
    try {
      return jsonDecode(input);
    } catch (_) {
      return null;
    }
  }
}

class NumConverter extends Converter<num> {
  @override
  convert(String input) {
    return .tryParse(input);
  }
}

class StringConverter extends Converter<String> {
  @override
  convert(String input) {
    return input;
  }
}