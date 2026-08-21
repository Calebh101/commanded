/// Base class for parameter types for annotations.
abstract class Parameter {
  /// The name of your parameter.
  ///
  /// This must be in `kebab-case`.
  final String name;

  /// The description of your parameter.
  ///
  /// This will be shown in the help output.
  final String? help;

  /// An optional abbreviation for the name of this flag/option.
  ///
  /// For example, for a flag named `--my-flag`,
  /// an abbreviation might be `-f`
  /// (where [abbr] will be `f`).
  ///
  /// This must be 1 character, and either a lowercase letter or a number.
  final String? abbr;

  /// Base class for parameter types for annotations.
  const Parameter(this.name, {this.help, this.abbr});
}

/// Defines an option in this format:<br>
/// `--my-option myValue`
///
/// Order does not matter for these types of parameters.
///
/// If this value is late, the option will be treated as required.
class Option extends Parameter {
  /// Defines an option in this format:<br>
  /// `--my-option myValue`
  ///
  /// Order does not matter for these types of parameters.
  ///
  /// If this value is late, the option will be treated as required.
  const Option(super.name, {super.help});
}

/// Defines a multi-option in this format:<br>
/// `--my-option myValue`
///
/// Because this is a multi-option, multiple values can be provides, like so:<br>
/// `--my-option myValue1 --my-option myValue2`
///
/// Order does not matter for these types of parameters;
/// however, the first provided will be first in the list of values.
class MultiOption extends Parameter {
  /// An optional minimum amount of values required.
  ///
  /// This must not be negative.
  final int? min;

  /// Defines a multi-option in this format:<br>
  /// `--my-option myValue`
  ///
  /// Because this is a multi-option, multiple values can be provides, like so:<br>
  /// `--my-option myValue1 --my-option myValue2`
  ///
  /// Order does not matter for these types of parameters;
  /// however, the first provided will be first in the list of values.
  const MultiOption(super.name, {super.help, this.min});
}

/// Defines a positional argument.
/// This is an argument that depends on position, instead of a named option/flag.
///
/// For example, if you ran this command:<br>
/// `mycommand arg1 arg2`<br>
/// Your positional arguments would be `arg1` and `arg2`.
class Argument extends Parameter {
  const Argument(super.name, {super.help});
}

/// Defines a flag, which is written like:
///
/// `--my-flag`<br>
/// And, if negatable: `--no-my-flag`
///
/// If [negatable] is false (which is the default), then this flag can be of one of two values:
/// - `true`: If the flag is provided.
/// - `false` (or whatever the default is): If the flag is not provided.
///
/// If [negatable] is true, then this flag can be one of three values:
/// - `true`: If the flag is provided.
/// - `false`: If the opposite flag is provided. If the flag was `--my-flag`, then the opposite flag would be `--no-my-flag`.
/// - `null` (or whatever the default is): If neither is provided.
///
/// By the default, I mean the default value of the field this annotation is being used on.<br>
/// For negatable flags, the normal default would be `null`.<br>
/// For non-negatable flags, the normal default would be `false`.
class Flag extends Parameter {
  /// If this is true, then this flag can be one of three values:
  /// - `true`: If the flag is provided.
  /// - `false`: If the opposite flag is provided. If the flag was `--my-flag`, then the opposite flag would be `--no-my-flag`.
  /// - `null` (or whatever the default is): If neither is provided.
  final bool negatable;

  /// Defines a flag, which is written like:
  ///
  /// `--my-flag`<br>
  /// And, if negatable: `--no-my-flag`
  ///
  /// If [negatable] is false (which is the default), then this flag can be of one of two values:
  /// - `true`: If the flag is provided.
  /// - `false` (or whatever the default is): If the flag is not provided.
  ///
  /// If [negatable] is true, then this flag can be one of three values:
  /// - `true`: If the flag is provided.
  /// - `false`: If the opposite flag is provided. If the flag was `--my-flag`, then the opposite flag would be `--no-my-flag`.
  /// - `null` (or whatever the default is): If neither is provided.
  ///
  /// By the default, I mean the default value of the field this annotation is being used on.<br>
  /// For negatable flags, the normal default would be `null`.<br>
  /// For non-negatable flags, the normal default would be `false`.
  const Flag(super.name, {super.abbr, this.negatable = false, super.help});
}

/// Defines a subcommand.
///
/// When defining a field for this one, all you need is:
///
/// ```dart
/// @Subcommand("mysubcommand") // Rest of annotation
/// late MySubcommand mySubcommand;
/// ```
///
/// The code generator only reads the **type** of the field.
/// So here, it would read `MySubcommand`.<br>
/// Therefore, there's no point in instantiating the command object.
class Subcommand extends Parameter {
  /// Defines a subcommand.
  ///
  /// When defining a field for this one, all you need is:
  ///
  /// ```dart
  /// @Subcommand("mysubcommand") // Rest of annotation
  /// late MySubcommand mySubcommand;
  /// ```
  ///
  /// The code generator only reads the **type** of the field.
  /// So here, it would read `MySubcommand`.<br>
  /// Therefore, there's no point in instantiating the command object.
  const Subcommand(super.name, {super.help});
}

/// Annotation for defining a main command.
///
/// Each command gets a `MyCommandData.runFromList` static method
/// (replacing `MyCommand` with your command class name).
///
/// However, putting `@MainCommand()` over your class generates an extra
/// `processCommands` function, that simply points to that command's `runFromList` method.
class MainCommand {
  /// Annotation for defining a main command.
  ///
  /// Each command gets a `MyCommandData.runFromList` static method
  /// (replacing `MyCommand` with your command class name).
  ///
  /// However, putting `@MainCommand()` over your class generates an extra
  /// `processCommands` function, that simply points to that command's `runFromList` method.
  const MainCommand();
}