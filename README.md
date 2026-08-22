# Hey there!

Glad you stumbled upon my package!
This package is a type-safe way to make command-line apps with advanced arguments while eliminating most of the boilerplate.

# How to make it work

For a detailed walkthrough, see the [example](example/lib/example.dart).
This will walk you through the API like a small guide.

However, for a few extra things, I've provided some extra documentation.

## Converters

Converters are little things that take in a string, and try to convert it to an output type.
They extend the abstract [`Converter`](lib/src/classes.dart) class.

Let's look at a basic `double` converter.

```dart
class DoubleConverter extends Converter<double> {
  @override
  double? convert(String input) {
    return double.tryParse(input);
  }
}
```

This is a very basic converter. It handles the type `double`, as you can see from the `extends Converter<double>` line.

When this converter is used, it simply tries to parse the string to a `double`.
If it succeeds, it returns that double; otherwise, it returns `null`.

If `null` is returned, then a message will be shown to the user.

---

Now, let's look at a slightly more advanced converter.

```dart
class BoolConverter extends Converter<bool> {
  @override
  bool? convert(String input) {
    final value = input.trim().toLowerCase();
    final number = num.tryParse(value);

    if (number != null) return number > 0;
    if (value == "y" || value == "yes" || value == "true") return true;
    if (value == "n" || value == "no" || value == "false") return false;
    return null;
  }

  @override
  String? help() {
    return "Supported values: 0/1, y/n, yes/no, true/false";
  }
}
```

As you can see, it's a bit more complicated.

In the `convert` function, we, well, check if the input string can be applied to a boolean.
I won't bore you with the details; you can read it yourself :)

There's also this `help` method. This returns a helpful tip that will be shown to the user if `convert` returns null.

---

You should make your converters stateless, as they may be reused.

For more examples, see [converters/core.dart](lib/src/converters/core.dart).

# Notes to remember

- Inheritance is how you define global arguments; if a command defines a different command as a subcommand, then the subcommand won't automatically inherit the parent command's arguments.
- Converters are required for everything but flags, and if not provided, will error at runtime. (Every time a command is run, the parser checks that each type has a converter.)