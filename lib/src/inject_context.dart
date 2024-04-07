import 'package:meta/meta.dart';
import 'package:syringe/src/errors/errors.dart';
import 'package:syringe/src/types.dart';

/// Enum representing the mode of injection.
@internal
enum InjectMode {
  /// Module injection mode.
  module,

  /// Regular injection mode.
  inject
}

/// Class representing the context for dependency injection.
@internal
class InjectContext {
  /// Map containing dependencies.
  final Deps _deps;

  /// Mode of injection.
  final InjectMode mode;

  /// List of dependencies.
  final List<Type> dependencies;

  /// Constructor for InjectContext.
  const InjectContext({
    required Deps deps,
    required this.mode,
    this.dependencies = const [],
  }) : _deps = deps;

  /// Method to retrieve dependencies.
  T deps<T>() {
    // Throws error if dependency is not registered.
    if (!_deps.containsKey(T)) {
      throw SyringeMissingDependencyError(dependency: T);
    }

    // Checks for module injection mode.
    if (mode == InjectMode.module) {
      if (dependencies.isEmpty || !dependencies.contains(T)) {
        throw SyringeMissingDependencyError(dependency: T);
      }
    }

    // Checks for regular injection mode.
    if (mode == InjectMode.inject) {
      if (!dependencies.contains(T)) {
        throw throw SyringeDependencyExportError(dependency: T);
      }
    }

    // Returns the dependency.
    return _deps[T];
  }
}
