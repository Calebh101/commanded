import 'dart:math';

import 'package:commanded/src/converters/core.dart';
import 'package:commanded/src/types.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// Various settings for commands.
/// These can be changed without needing to rerun Build Runner.
final class CommandSettings {
  /// Only allow subcommands in this command.
  ///
  /// If the command is run without a subcommand,
  /// an error will be thrown and caught and help will be shown.
  final bool subcommandsOnly;

  /// Take this example:
  ///
  /// ```
  /// mycommand --my-flag positionalArgument --my-other-flag
  /// ```
  ///
  /// If this is true, then both `--my-flag` and `--my-other-flag` will be processed as a flag.
  ///
  /// If this is false, then `--my-flag` will be processed as a flag, but `--my-other-flag` will be processed as a positional argument.
  final bool allowTrailingOptions;

  /// If this is enabled (default), then if the parser comes across an option or flag it doesn't recognize,
  /// it'll error and show help.
  ///
  /// If this is disabled, invalid options and flags will be treated as positional arguments.
  final bool errorOnInvalidOptions;

  /// Various settings for commands.
  /// These can be changed without needing to rerun Build Runner.
  const CommandSettings({this.subcommandsOnly = false, this.allowTrailingOptions = true, this.errorOnInvalidOptions = true});
}

/// Abstract class for defining a command.
///
/// No annotation is needed here;
/// the generator automatically looks for classes that extend [Command] or a different class that extends [Command].
abstract class Command {
  /// Abstract class for defining a command.
  ///
  /// No annotation is needed here;
  /// the generator automatically looks for classes that extend [Command] or a different class that extends [Command].
  new();

  /// The name of this command, for usage.
  String get name;

  /// Settings for this command.
  /// This defaults to a default [CommandSettings] object.
  CommandSettings get settings => .new();

  /// Converters for this command.
  /// For more info, see the readme for this package.
  ///
  /// `super` is not required nor recommended to be called.
  List<Converter> get converters => [];

  /// Use this to validate command input.
  ///
  /// Return a dev-friendly error message if there's an error;
  /// otherwise, return null.
  ///
  /// Help will automatically be shown if a message is returned.
  ///
  /// Calling super is not required, and does nothing.
  String? validate() => null;

  /// This is ran once the arguments are parsed and ready to be used.
  void onRun();

  /// Build the help block that's shown to the user.
  ///
  /// You can customize this as much as you want; it is up to you.
  ///
  /// ### Referencing options, flags, and more:
  ///
  /// Use `flags` for flags, `options` for options, `multiOptions` for multi-options, `arguments` for arguments, and `subcommands` for subcommands.
  ///
  /// These provide type-safe records that reference each of your defined parameters.
  ///
  /// There's also `all<type>`, where type is something such as `Options`, which provide lists.
  ///
  /// ---
  ///
  /// See [HelpBuilder] documentation for more information.
  HelpBuilder buildHelp();

  /// Build the usage line that's shown to the user.
  ///
  /// You can customize this as much as you want; it is up to you.
  /// However, it must stay as 1 line.
  ///
  /// ### Referencing options, flags, and more:
  ///
  /// Use `flags` for flags, `options` for options, `multiOptions` for multi-options, `arguments` for arguments, and `subcommands` for subcommands.
  ///
  /// These provide type-safe records that reference each of your defined parameters.
  ///
  /// There's also `all<type>`, where type is something such as `Options`, which provide lists.
  ///
  /// ---
  ///
  /// Calling super is not required, and does nothing.
  ///
  /// See [UsageBuilder] documentation for more info.
  UsageBuilder? buildUsage() => null;

  /// Tries to get a converter from [converters].
  ///
  /// Types must match exactly.
  ///
  /// If a converter is not found, the built-in converters are tried.
  ///
  /// If nothing is matched, the function will return `null`.
  @nonVirtual
  Converter? getConverter(Type type) {
    for (final c in converters) {
      if (c.type == type) return c;
    }

    for (final c in builtinConverters) {
      if (c.type == type) return c;
    }

    return null;
  }

  /// Tries to find a converter from [converters].
  ///
  /// Types must match exactly.
  ///
  /// If a converter is not found, the built-in converters are tried.
  ///
  /// Returns `true` if found.
  @nonVirtual
  bool checkConverter(Type type) {
    return getConverter(type) != null;
  }
}

/// Abstract class for converters.
///
/// A converter is a very simple object that takes in a string and converts it into an output object.
///
/// For example, we could make a converter like so:
///
/// ```dart
/// class DoubleConverter extends Converter<double> {
///   @override
///   convert(String input) {
///     return double.tryParse(input);
///   }
/// }
/// ```
///
/// When an argument expecting a double is inputted, the converter takes in the input, and tries to parse it into a double.
abstract class Converter<T> {
  /// Abstract class for converters.
  ///
  /// A converter is a very simple object that takes in a string and converts it into an output object.
  ///
  /// For example, we could make a converter like so:
  ///
  /// ```dart
  /// class DoubleConverter extends Converter<double> {
  ///   @override
  ///   convert(String input) {
  ///     return double.tryParse(input);
  ///   }
  /// }
  /// ```
  ///
  /// When an argument expecting a double is inputted, the converter takes in the input, and tries to parse it into a double.
  new();

  /// Take in the raw string input and try to convert it into a value.
  ///
  /// If the input is invalid, return null.
  T? convert(String input);

  /// This is used to validate that this converter is set up correctly.
  ///
  /// This is called when the program is ran.
  /// If a string is returned, an error will be thrown.
  ///
  /// This is only for very specific cases, like type checking.
  /// For an example on how this can be used,
  /// see `EnumConverter.validate` in `converters/core.dart`.
  String? validate() => null;

  /// Generate a help message for when a value fails to convert.
  ///
  /// Use this to put supported values or tips.
  String? help() => null;

  /// A pretty name for the type this converter represents.
  /// The user will see this.
  ///
  /// Defaults to a string representation of [T].
  String? get typePretty => null;

  /// The type this converter represents.
  @nonVirtual
  Type get type => T;
}

extension on String {
  String get brackets {
    return "[$this]";
  }

  String bracketsIf(bool condition) {
    return condition ? brackets : this;
  }
}

/// Class representing an item for [HelpBuilder].
class HelpItem {
  /// Left column.
  final String? left;

  /// Right column.
  final String? right;

  /// Class representing an item for [HelpBuilder].
  HelpItem(this.left, this.right);

  /// Turn this into a string.
  String pretty(int padding) {
    return "${(left ?? "").padRight(padding)}  ${right ?? ""}";
  }
}

/// Class representing builders.
abstract class Builder {
  /// Class representing builders.
  new();

  /// Build the current state of the object into an output string.
  ///
  /// This should not modify state.
  String build();
}

/// Helper class for building help messages.
///
/// This builder collects a list of items and renders them from top to bottom,
/// with 2 columns: one for the names of the items, and the other for help messages.
///
/// If you'd like to create your own functionality or stringification method,
/// you are able to extend this class.
class HelpBuilder extends Builder {
  /// Helper class for building help messages.
  ///
  /// This builder collects a list of items and renders them from top to bottom,
  /// with 2 columns: one for the names of the items, and the other for help messages.
  ///
  /// If you'd like to create your own functionality or stringification method,
  /// you are able to extend this class.
  new();

  /// The current list of items of this builder.
  ///
  /// This is stateful.
  final List<HelpItem> items = [];

  /// Add an argument from an [ArgumentData] to the list of items.
  ///
  /// Arguments will be represented as their name, like so:
  ///
  /// ```
  /// argument
  /// ```
  void addArgument(ArgumentData data) {
    items.add(.new(data.name, data.help));
  }

  /// Add a flag from a [FlagData] to the list of items.
  ///
  /// Flags will be represented as 2 dashes before their name, with an optional abbreviation, like so:
  ///
  /// ```
  /// --my-flag/-f
  /// ```
  void addFlag(FlagData data) {
    items.add(.new(["--${data.name}", if (data.abbr != null) "-${data.abbr}"].join("/"), data.help));
  }

  /// Add an option from an [OptionData] to the list of items.
  ///
  /// Options will be represented like so:
  ///
  /// ```
  /// --my-option <my-option>
  /// ```
  void addOption(OptionData data) {
    items.add(.new(["--${data.name} <${data.name}>"].join("/"), data.help));
  }

  /// Add a multi-option item from a [MultiOptionData] to the list of items.
  ///
  /// Multi-options will be represented like so:
  ///
  /// ```
  /// --my-multi-option <my-multi-option>
  /// ```
  ///
  /// The option is required if its `min` value is 1 or more.
  void addMultiOption(MultiOptionData data) {
    items.add(.new(["--${data.name} <${data.name}>"].join("/"), data.help));
  }

  /// Add a subcommand from a [SubcommandData] to the list of items.
  ///
  /// Subcommands will simply be represented as their name, like so:
  ///
  /// ```
  /// subcommand
  /// ```
  void addSubcommand(SubcommandData data) {
    items.add(.new(data.name, data.help));
  }

  /// Add a rest parameter from a [RestData] to the list of items.
  ///
  /// Rest parameters will be represented as their name, with an ellipsis, like so:
  ///
  /// ```
  /// ...rest
  /// ```
  void addRest(RestData data) {
    items.add(.new("...${data.name}", data.help));
  }

  /// Add several arguments from [ArgumentData] to the list of items.
  ///
  /// Arguments will be represented as their name, like so:
  ///
  /// ```
  /// argument
  /// ```
  void addArguments(List<ArgumentData> data) {
    for (final x in data) {
      addArgument(x);
    }
  }

  /// Add several flags from [FlagData] to the list of items.
  ///
  /// Flags will be represented as 2 dashes before their name, with an optional abbreviation, like so:
  ///
  /// ```
  /// --my-flag/-f
  /// ```
  void addFlags(List<FlagData> data) {
    for (final x in data) {
      addFlag(x);
    }
  }

  /// Add several options from [OptionData] to the list of items.
  ///
  /// Options will be represented like so:
  ///
  /// ```
  /// --my-option <my-option>
  /// ```
  void addOptions(List<OptionData> data) {
    for (final x in data) {
      addOption(x);
    }
  }

  /// Add several multi-option items from [MultiOptionData] to the list of items.
  ///
  /// Multi-options will be represented like so:
  ///
  /// ```
  /// --my-multi-option <my-multi-option>
  /// ```
  ///
  /// The option is required if its `min` value is 1 or more.
  void addMultiOptions(List<MultiOptionData> data) {
    for (final x in data) {
      addMultiOption(x);
    }
  }

  /// Add several subcommands from [SubcommandData] to the list of items.
  ///
  /// Subcommands will simply be represented as their name, like so:
  ///
  /// ```
  /// subcommand
  /// ```
  void addSubcommands(List<SubcommandData> data) {
    for (final x in data) {
      addSubcommand(x);
    }
  }

  /// Add a blank line to the list of items.
  void addSeparator() {
    items.add(.new(null, null));
  }

  /// Add a custom line to the list of items.
  ///
  /// [left] is the text shown in the left column, and
  /// [right] is the text shown in the right column.
  ///
  /// `null` = blank.
  void addCustom([String? left, String? right]) {
    items.add(.new(left, right));
  }

  @override
  String build() {
    final maxLeft = items.map((x) => x.left?.length ?? 0).maxOrNull ?? 0;
    return items.map((x) => x.pretty(max(20, maxLeft))).join("\n");
  }
}

/// Helper class for building help messages.
///
/// This builder collects a list of items and renders them from left to right,
/// joining them by a space.
///
/// If you'd like to create your own functionality or stringification method,
/// you are able to extend this class.
class UsageBuilder extends Builder {
  /// Helper class for building help messages.
  ///
  /// This builder collects a list of items and renders them from left to right,
  /// joining them by a space.
  ///
  /// If you'd like to create your own functionality or stringification method,
  /// you are able to extend this class.
  new();

  /// The current list of items of this builder.
  ///
  /// This is stateful.
  final List<String> items = [];

  /// Add an argument from an [ArgumentData] to the list of items.
  ///
  /// Arguments will be represented as their name, with brackets around it if the argument is optional, like so:
  ///
  /// ```
  /// my-required-argument
  /// [my-optional-argument]
  /// ```
  void addArgument(ArgumentData data) {
    items.add(data.name.bracketsIf(!data.required));
  }

  /// Add a flag from a [FlagData] to the list of items.
  ///
  /// Flags will be represented as 2 dashes before their name, with an optional abbreviation, with brackets around them, like so:
  ///
  /// ```
  /// [--my-flag/-f]
  /// ```
  void addFlag(FlagData data) {
    items.add(["--${data.name}", if (data.abbr != null) "-${data.abbr}"].join("/").brackets);
  }

  /// Add an option from an [OptionData] to the list of items.
  ///
  /// Options will be represented like so:
  ///
  /// ```
  /// --my-required-option <my-required-option>
  /// [--my-optional-option <my-optional-option>]
  /// ```
  void addOption(OptionData data) {
    items.add(["--${data.name} <${data.name}>"].join("/").bracketsIf(!data.required));
  }

  /// Add a multi-option item from a [MultiOptionData] to the list of items.
  ///
  /// Multi-options will be represented like so:
  ///
  /// ```
  /// --my-required-option <my-required-option>
  /// [--my-optional-option <my-optional-option>]
  /// ```
  ///
  /// The option is required if its `min` value is 1 or more.
  void addMultiOption(MultiOptionData data) {
    items.add(["--${data.name} <${data.name}>"].join("/").bracketsIf((data.min ?? 0) < 1));
  }

  /// Add a rest parameter from a [RestData] to the list of items.
  ///
  /// Rest parameters will be represented as their name, with an ellipsis, like so:
  ///
  /// ```
  /// ...rest
  /// [...rest-optional]
  /// ```
  void addRest(RestData data) {
    items.add("...${data.name}".bracketsIf((data.min ?? 0) < 1));
  }

  /// Add several arguments from [ArgumentData] to the list of items.
  ///
  /// Arguments will be represented as their name, with brackets around it if the argument is optional, like so:
  ///
  /// ```
  /// my-required-argument
  /// [my-optional-argument]
  /// ```
  void addArguments(List<ArgumentData> data) {
    for (final x in data) {
      addArgument(x);
    }
  }

  /// Add several flags from [FlagData] to the list of items.
  ///
  /// Flags will be represented as 2 dashes before their name, with an optional abbreviation, with brackets around them, like so:
  ///
  /// ```
  /// [--my-flag/-f]
  /// ```
  void addFlags(List<FlagData> data) {
    for (final x in data) {
      addFlag(x);
    }
  }

  /// Add several options from [OptionData] to the list of items.
  ///
  /// Options will be represented like so:
  ///
  /// ```
  /// --my-required-option <my-required-option>
  /// [--my-optional-option <my-optional-option>]
  /// ```
  void addOptions(List<OptionData> data) {
    for (final x in data) {
      addOption(x);
    }
  }

  /// Add several multi-option items from [MultiOptionData] to the list of items.
  ///
  /// Multi-options will be represented like so:
  ///
  /// ```
  /// --my-required-option <my-required-option>
  /// [--my-optional-option <my-optional-option>]
  /// ```
  ///
  /// The option is required if its `min` value is 1 or more.
  void addMultiOptions(List<MultiOptionData> data) {
    for (final x in data) {
      addMultiOption(x);
    }
  }

  /// Add a custom string into the items.
  ///
  /// This will still be joined by spaces, so you don't need to add a space before or after your string.
  ///
  /// If nothing is provided, nothing is added.
  void addCustom(String? value) {
    if (value != null) items.add(value);
  }

  @override
  String build([String separator = " "]) {
    return items.join(separator);
  }
}