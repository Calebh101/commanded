import 'package:commanded/src/classes.dart';
import 'package:collection/collection.dart';

/// All built-in converters.
///
/// These will be used if they match a type that you didn't provide in your command's `converters` getter.
List<Converter> get builtinConverters => [
  BoolConverter(),
  DoubleConverter(),
  IntConverter(),
  NumConverter(),
  StringConverter(),
];

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

    if (number == 0 || number == 1) return number == 1;
    if (value == "y" || value == "yes" || value == "true") return true;
    if (value == "n" || value == "no" || value == "false") return false;
    return null;
  }

  @override
  String help() {
    return "Supported values: 0/1, y/n, yes/no, true/false";
  }
}

/// Converts into `double` using `tryParse`.
class DoubleConverter extends Converter<double> {
  /// Converts into `double` using `tryParse`.
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
  /// A list of the enum's values.
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
  String? validate() {
    if (T == Enum) return "You must specify a type for EnumConverter. Trust me, I learned this the hard way.";
    return null;
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

/// Converts into `num` using `tryParse`.
class NumConverter extends Converter<num> {
  /// Converts into `num` using `tryParse`.
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