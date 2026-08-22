import 'package:commanded/src/classes.dart';

/// Data for positional argument definitions.
typedef ArgumentData = ({String name, String? help, bool required});

/// Data for flag definitions.
typedef FlagData = ({String name, String? help, String? abbr, bool negatable});

/// Data for option definitions.
typedef OptionData = ({String name, String? help, String? abbr, String type, bool required});

/// Data for multi-option definitions.
typedef MultiOptionData = ({String name, String? help, String? abbr, String type, int? min});

/// Data for subcommand definitions.
typedef SubcommandData = ({String name, String? help});

/// Data for defining positional arguments in generated files.
typedef PositionalArgumentData<T extends Command> = ({String name, Type type, void Function(T object, dynamic value) set, bool required});
