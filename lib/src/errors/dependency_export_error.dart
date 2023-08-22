part of 'errors.dart';

class SyringeDependencyExportError extends SyringeError {
  final Type dependency;
  final Type? module;

  SyringeDependencyExportError({required this.dependency, this.module});

  @override
  String toString() {
    final moduleStr = module != null ? ' ($module)' : '';
    return 'Dependency $dependency don`t available for export$moduleStr';
  }
}
