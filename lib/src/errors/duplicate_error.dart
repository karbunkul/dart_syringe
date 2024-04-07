part of 'errors.dart';

/// Error indicating a duplicate module during dependency injection.
class SyringeModuleDuplicateError extends SyringeError {
  /// The type of the duplicate module.
  final Type type;

  /// Constructor for SyringeModuleDuplicateError.
  SyringeModuleDuplicateError(this.type);

  @override
  String toString() => 'Module $type already registered';
}
