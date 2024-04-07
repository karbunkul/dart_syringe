import 'dart:async';

import 'package:meta/meta.dart';
import 'package:syringe/src/types.dart';

/// Base class representing a module for dependency injection.
@immutable
abstract class Module<T> {
  /// Constructor for Module.
  const Module();

  /// Factory method to create instances of type [T].
  FutureOr<T> factory(DepsCallback deps);

  /// List of dependencies required by the module.
  List<Type> get deps => [];

  /// Indicates whether the module should be exported.
  bool get export => false;

  /// Returns the type of the module.
  Type typeOf() => T;

  /// Indicates whether the module has dependencies.
  bool get hasDependencies => deps.isNotEmpty;

  @override
  bool operator ==(Object other) {
    return other is Module<T> &&
        export == other.export &&
        deps.toString() == other.deps.toString();
  }

  @override
  int get hashCode {
    final exportWeight = export ? 1000 : 100;
    return T.toString().length + exportWeight + deps.toString().length;
  }
}

/// Class representing an export module for dependency injection.
@immutable
class ExportModule<T> extends Module<T> {
  /// Callback function to create instances of type [T].
  final InjectCallback<T> onInject;

  /// List of dependencies required by the module.
  final List<Type>? dependencies;

  /// Constructor for ExportModule.
  const ExportModule({required this.onInject, this.dependencies});

  @override
  FutureOr<T> factory(DepsCallback deps) => onInject(deps);

  @override
  List<Type> get deps => dependencies ?? [];

  @override
  bool get export => true;
}

/// Class representing a proxy module for dependency injection.
@immutable
class ProxyModule<T> extends Module<T> {
  /// Callback function to create instances of type [T].
  final InjectCallback<T> onInject;

  /// List of dependencies required by the module.
  final List<Type>? dependencies;

  /// Constructor for ProxyModule.
  const ProxyModule({required this.onInject, this.dependencies});

  @override
  FutureOr<T> factory(DepsCallback deps) => onInject(deps);

  @override
  List<Type> get deps => dependencies ?? [];

  @override
  bool get export => false;
}
