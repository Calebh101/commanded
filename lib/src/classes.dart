import 'dart:math';

import 'package:advanced_cli/src/types.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

abstract class Command {
  String get name;
  String? get restName => null;

  List<Converter> get converters => [];

  @nonVirtual
  late List<String> rest;

  void onRun();

  HelpBuilder buildHelp();

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

  String? get typePretty => null;

  @nonVirtual
  Type get type => T;
}

final class HelpBuilder {
  final List<_Item> _items = [];

  void addArgument(ArgumentData data) {
    _items.add(.new(.arg, data.name, data.help));
  }

  void addFlag(FlagData data) {
    _items.add(.new(.flag, data.name, data.help));
  }

  void addOption(OptionData data) {
    _items.add(.new(.option, data.name, data.help));
  }

  void addMultiOption(MultiOptionData data) {
    _items.add(.new(.multiOption, data.name, data.help));
  }

  void addSubcommand(SubcommandData data) {
    _items.add(.new(.subcommand, data.name, data.help));
  }

  void addSeparator() {
    _items.add(.new(.separator, null, null));
  }

  void addCustom([String? left, String? right]) {
    _items.add(.new(.custom, left, right));
  }

  @override
  String toString() {
    final maxLeft = _items.map((x) => x.getLeft().length).max;
    return _items.map((x) => x.pretty(max(20, maxLeft))).join("\n");
  }
}

enum _Type {
  arg,
  flag,
  option,
  multiOption,
  subcommand,
  separator,
  custom,
  ;
}

class _Item {
  final _Type type;
  final String? left;
  final String? right;

  new(this.type, this.left, this.right);

  String getLeft() {
    return left == null ? "" : switch (type) {
      .arg => left,
      .flag => "--$left",
      .multiOption => "--$left <value>",
      .option => "--$left <value>",
      .subcommand => left,
      .separator => "",
      .custom => left,
    } ?? "";
  }

  String pretty(int padding) {
    return "${getLeft().padRight(padding)}  ${right ?? ""}";
  }
}