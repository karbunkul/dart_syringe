import 'package:syringe/src/types.dart';

import 'errors/errors.dart';

final class InjectContext {
  final Deps _deps;
  final List<Type> internal;
  final List<Type> dependencies;

  const InjectContext({
    required Deps deps,
    this.internal = const [],
    this.dependencies = const [],
  }) : _deps = deps;

  T deps<T>() {
    if (!_deps.containsKey(T)) {
      throw SyringeMissingDependencyError(dependency: T);
    }

    if (internal.isNotEmpty && internal.contains(T)) {
      throw SyringeDependencyExportError(dependency: T);
    }

    if (dependencies.isNotEmpty && !dependencies.contains(T)) {
      throw SyringeMissingDependencyError(dependency: T);
    }

    return _deps[T];
  }
}
