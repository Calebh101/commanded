import 'package:commands/src/classes.dart';

typedef ArgumentData = ({String name, String? help, bool required});
typedef FlagData = ({String name, String? help, String? abbr, bool negatable});
typedef OptionData = ({String name, String? help, String type, bool required});
typedef MultiOptionData = ({String name, String? help, String type, int? min});
typedef SubcommandData = ({String name, String? help});
typedef PositionalArgumentData<T extends Command> = ({String name, Type type, void Function(T object, dynamic value) set, bool required});
