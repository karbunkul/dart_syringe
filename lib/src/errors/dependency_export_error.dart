part of 'errors.dart';

/// Error indicating a dependency is not available for export during dependency injection.
class SyringeDependencyExportError extends SyringeError {
  /// The type of the dependency that is not available for export.
  final Type dependency;

  /// The type of the module where the export error occurred, if available.
  final Type? module;

  /// Constructor for SyringeDependencyExportError.
  SyringeDependencyExportError({
    required this.dependency,
    this.module,
  });

  @override
  String toString() {
    // Constructs the error message with the dependency and module information.
    final moduleStr = module != null ? ' ($module)' : '';
    return 'Dependency $dependency is not available for export$moduleStr';
  }
}
