class HelpBuilder {
  final String usage;
  final List<HelpItem> items;

  new({required this.usage, required this.items});
}

class HelpItem {
  final HelpType type;
  final String left;
  final String? right;

  HelpItem(this.type, this.left, [this.right]);

  factory HelpItem.separator() {
    return .new(.separator, "");
  }
}

enum HelpType {
  separator,
  option,
  multiOption,
  argument,
  flag,
  subcommand,
  ;
}