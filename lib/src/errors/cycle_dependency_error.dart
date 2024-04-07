part of 'errors.dart';

/// Error indicating a cyclic dependency during dependency injection.
class SyringeCycleDependencyError extends SyringeError {
  /// The type of the module where the cyclic dependency occurred.
  final Type module;

  /// Constructor for SyringeCycleDependencyError.
  SyringeCycleDependencyError({
    required this.module,
  });

  @override
  String toString() => 'Module $module has a cyclic dependency';
}
