part of 'errors.dart';

class SyringeUnknownDependencyError extends SyringeError {
  final Type module;

  SyringeUnknownDependencyError(this.module);

  @override
  String toString() {
    return 'Module $module not registered';
  }
}
