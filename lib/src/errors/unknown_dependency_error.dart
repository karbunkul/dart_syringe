part of 'errors.dart';

class SyringeUnknownDependencyError extends SyringeError {
  final Type dependency;
  final Type module;

  SyringeUnknownDependencyError({
    required this.dependency,
    required this.module,
  });

  @override
  String toString() {
    return 'Module $dependency not registered ($module)';
  }
}
