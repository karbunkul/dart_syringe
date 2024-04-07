part of 'errors.dart';

/// Error indicating an unknown dependency during dependency injection.
class SyringeUnknownDependencyError extends SyringeError {
  /// The type of the unknown dependency.
  final Type dependency;

  /// The type of the module where the unknown dependency occurred.
  final Type module;

  /// Constructor for SyringeUnknownDependencyError.
  SyringeUnknownDependencyError({
    required this.dependency,
    required this.module,
  });

  @override
  String toString() => 'Module $dependency not registered ($module)';
}
