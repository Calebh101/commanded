// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:source_gen/source_gen.dart';
import 'package:source_gen/src/output_helpers.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';

/// Just [GeneratorForAnnotation], but looking at `extends <Class>`.<br>
/// E.G. If `T` is `MyClass`, then the following will happen:
///
/// ```dart
/// class MyOtherClass extends MyClass {
///   // generateForClass is called.
/// }
///
/// abstract class MyBigClass extends MyClass {
///   // generateForClass is called.
/// }
///
/// class AnotherClass extends MyBigClass {
///   // generateForClass is called, because MyBigClass extends MyClass.
/// }
///
/// class NormalClass {
///   // generateForClass is not called.
/// }
///
/// class NormalClass extends ASuperClass {
///   // generateForClass is not called.
/// }
/// ```
abstract class GeneratorForSuperclass<T> extends Generator {
  final bool throwOnUnresolved;
  final String? inPackage;
  final bool? inSdk;

  const GeneratorForSuperclass({
    this.throwOnUnresolved = true,
    this.inPackage,
    this.inSdk,
  });

  TypeChecker get typeChecker =>
      TypeChecker.typeNamed(T, inPackage: inPackage, inSdk: inSdk);

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final values = <String>{};

    for (final element in library.classes) {
      final supertype = element.supertype;

      if (supertype == null) {
        continue;
      }

      final superElement = supertype.element;

      if (superElement is ClassElement && superElement.name == 'Object') {
        continue;
      }

      if (!typeChecker.isExactlyType(supertype) && !typeChecker.isSuperTypeOf(supertype)) {
        continue;
      }

      final generatedValue = generateForClass(
        element,
        buildStep,
      );

      await for (final value in normalizeGeneratorOutput(generatedValue)) {
        assert(value.length == value.trim().length);
        values.add(value);
      }
    }

    return values.join('\n\n');
  }

  dynamic generateForClass(
    ClassElement element,
    BuildStep buildStep,
  ) {}
}
