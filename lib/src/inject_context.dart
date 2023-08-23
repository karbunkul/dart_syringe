import 'package:syringe/src/types.dart';

import 'errors/errors.dart';

enum InjectMode { module, inject }

final class InjectContext {
  final Deps _deps;
  final InjectMode mode;
  final List<Type> dependencies;

  const InjectContext({
    required Deps deps,
    required this.mode,
    this.dependencies = const [],
  }) : _deps = deps;

  T deps<T>() {
    // Not registered module
    if (!_deps.containsKey(T)) {
      throw SyringeMissingDependencyError(dependency: T);
    }

    if (mode == InjectMode.module) {
      if (dependencies.isEmpty || !dependencies.contains(T)) {
        throw SyringeMissingDependencyError(dependency: T);
      }
    } else {
      if (dependencies.isNotEmpty && !dependencies.contains(T)) {
        throw throw SyringeDependencyExportError(dependency: T);
      }
    }

    // if (dependencies.isNotEmpty && !dependencies.contains(T)) {
    //   if (mode == InjectMode.inject) {
    //     throw throw SyringeDependencyExportError(dependency: T);
    //   } else {
    //
    //   }
    // }

    return _deps[T];
  }
}
