part of 'errors.dart';

class SyringeMissingDependencyError extends SyringeError {
  final Type dependency;

  SyringeMissingDependencyError(this.dependency);

  @override
  String toString() {
    return 'Dependency $dependency is missing';
  }
}
