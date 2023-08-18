part of 'errors.dart';

class SyringeMissingDependencyError extends SyringeError {
  final Type dependency;
  final Type? module;

  SyringeMissingDependencyError({required this.dependency, this.module});

  @override
  String toString() {
    final moduleStr = module != null ? ' ($module)' : '';
    return 'Dependency $dependency is missing$moduleStr';
  }
}
