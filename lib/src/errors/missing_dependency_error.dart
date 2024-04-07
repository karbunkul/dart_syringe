part of 'errors.dart';

/// Error indicating a missing dependency during dependency injection.
class SyringeMissingDependencyError extends SyringeError {
  /// The type of the missing dependency.
  final Type dependency;

  /// The type of the module where the missing dependency occurred, if available.
  final Type? module;

  /// Constructor for SyringeMissingDependencyError.
  SyringeMissingDependencyError({
    required this.dependency,
    this.module,
  });

  @override
  String toString() {
    // Constructs the error message with the dependency and module information.
    final moduleStr = module != null ? ' ($module)' : '';
    return 'Dependency $dependency is missing$moduleStr';
  }
}
