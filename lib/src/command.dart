import 'package:collection/collection.dart';

abstract class Command {
  String get name;
  String get description;

  List<Converter> get converters => [];

  void onRun();

  Converter? checkConverter(Type type) {
    return converters.firstWhereOrNull((x) => x.type == type);
  }
}

abstract class Converter<T> {
  T? convert(String input);

  String? help() => null;

  Type get type => T;
}