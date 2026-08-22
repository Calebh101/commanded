import 'dart:convert';

import 'package:commanded/src/classes.dart';
import 'package:collection/collection.dart';

/// Converts into `bool`.
///
/// Accepts `y`, `yes`, `true`, or numbers.
class BoolConverter extends Converter<bool> {
  /// Converts into `bool`.
  ///
  /// Accepts `y`, `yes`, `true`, or numbers.
  new();

  @override
  convert(String input) {
    final value = input.trim().toLowerCase();
    final number = num.tryParse(value);

    if (number != null) return number > 0;
    if (value == "y" || value == "yes" || value == "true") return true;
    if (value == "n" || value == "no" || value == "false") return false;
    return null;
  }

  @override
  String help() {
    return "Supported values: 0/1, y/n, yes/no, true/false";
  }
}

/// Converts into `Double` using `tryParse`.
class DoubleConverter extends Converter<double> {
  /// Converts into `Double` using `tryParse`.
  new();

  @override
  convert(String input) {
    return .tryParse(input);
  }
}

/// Converts enums from strings.
///
/// This converter first tries to see if an index was provided, then tries that.
///
/// Then it uses the enum's values' names (or [getName]).
///
/// **IMPORTANT!** You must specify a type argument with this converter! You **will** see a runtime exception if you ignore this!
class EnumConverter<T extends Enum> extends Converter<T> {
  /// A list of the enum's values.<br>
  /// All that's required here is just writing `.values`.
  final List<T> values;

  /// Use this if you have some other way to get an enum's name other than the builtin `name` property.
  final String Function(T value)? getName;

  /// Converts enums from strings.
  ///
  /// This converter first tries to see if an index was provided, then tries that.
  ///
  /// Then it uses the enum's values' names (or [getName]).
  ///
  /// **IMPORTANT!** You must specify a type argument with this converter! You **will** see a runtime exception if you ignore this!
  EnumConverter(this.values, {this.getName});

  @override
  convert(String input) {
    final value = input.trim().toLowerCase();
    final i = int.tryParse(value);

    if (i != null && i < values.length) return values.elementAtOrNull(i);
    return values.firstWhereOrNull((x) => (getName?.call(x) ?? x.name) == value);
  }

  @override
  String help() {
    return "Supported values: ${values.map((x) => getName?.call(x) ?? x.name).join(", ")}";
  }
}

/// Converts into `int` using `tryParse`.
class IntConverter extends Converter<int> {
  /// Converts into `int` using `tryParse`.
  new();

  @override
  convert(String input) {
    return .tryParse(input);
  }
}

/// Converts the input into `Object` using `jsonDecode` from `dart:convert`.
class JsonConverter extends Converter<Object> {
  /// Converts the input into `Object` using `jsonDecode` from `dart:convert`.
  new();

  @override
  convert(String input) {
    try {
      return jsonDecode(input);
    } catch (_) {
      return null;
    }
  }
}

/// Converts into `Double` using `tryParse`.
class NumConverter extends Converter<num> {
  /// Converts into `Double` using `tryParse`.
  new();

  @override
  convert(String input) {
    return .tryParse(input);
  }
}

/// Returns what's put into it.
/// Cannot return null.
class StringConverter extends Converter<String> {
  /// Returns what's put into it.
  /// Cannot return null.
  new();

  @override
  convert(String input) {
    return input;
  }
}