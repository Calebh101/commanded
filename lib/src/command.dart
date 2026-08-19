import 'package:meta/meta.dart';

abstract class Command {
  String get name;
  String get description;

  List<Converter> get converters => [];

  @nonVirtual
  late List<String> rest;

  void onRun();

  @nonVirtual
  Converter? getConverter(Type type) {
    for (final c in converters) {
      if (c.type == type) return c;
    }

    return null;
  }
}

abstract class Converter<T> {
  T? convert(String input);

  String? help() => null;

  @nonVirtual
  Type get type => T;
}