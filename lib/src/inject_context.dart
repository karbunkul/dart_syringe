import 'package:syringe/src/types.dart';

import 'errors/errors.dart';

final class InjectContext {
  final Deps _deps;

  const InjectContext({required Deps deps}) : _deps = deps;

  T deps<T>() {
    if (!_deps.containsKey(T)) {
      throw SyringeMissingDependencyError(T);
    }

    return _deps[T];
  }
}
