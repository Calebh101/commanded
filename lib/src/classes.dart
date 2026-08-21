import 'dart:math';

import 'package:commands/src/types.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

class CommandSettings {
  final bool subcommandsOnly;
  final bool allowRest;
  final bool allowTrailingOptions;
  final String? restUsageName;

  const CommandSettings({this.subcommandsOnly = false, this.allowRest = false, this.allowTrailingOptions = true, this.restUsageName});
}

abstract class Command {
  String get name;
  CommandSettings get settings => .new();
  List<Converter> get converters => [];

  @nonVirtual
  late List<String> rest;

  void onRun();

  String? validate() => null;

  HelpBuilder buildHelp();

  UsageBuilder? buildUsage() => null;

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

  _Item(this.type, this.left, this.right);

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

class UsageBuilder {
  final List<String> _items = [];

  void addArgument(ArgumentData data) {
    _items.add(data.name.bracketsIf(!data.required));
  }

  void addFlag(FlagData data) {
    _items.add(["--${data.name}", if (data.abbr != null) "-${data.abbr}"].join("/").brackets);
  }

  void addOption(OptionData data) {
    _items.add(["--${data.name} <${data.name}>"].join("/").bracketsIf(!data.required));
  }

  void addMultiOption(MultiOptionData data) {
    _items.add(["--${data.name} <${data.name}>"].join("/").bracketsIf((data.min ?? 0) < 1));
  }

  void addCustom(String? value) {
    if (value != null) _items.add(value);
  }

  @override
  String toString([String separator = " "]) {
    return _items.join(separator);
  }
}

extension on String {
  String get brackets {
    return "[$this]";
  }

  String bracketsIf(bool condition) {
    return condition ? brackets : this;
  }
}