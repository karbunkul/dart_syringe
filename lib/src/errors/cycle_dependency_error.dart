part of 'errors.dart';

class SyringeCycleDependencyError extends SyringeError {
  final Type module;

  SyringeCycleDependencyError({required this.module});

  @override
  String toString() {
    return 'Module $module have cycle dependency';
  }
}
