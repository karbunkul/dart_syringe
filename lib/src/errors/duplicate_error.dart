part of 'errors.dart';

class SyringeModuleDuplicateError extends SyringeError {
  final Type type;

  SyringeModuleDuplicateError(this.type);

  @override
  String toString() {
    return 'Module $type already registered';
  }
}
