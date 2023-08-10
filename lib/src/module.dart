import 'dart:async';

import 'types.dart';

abstract base class Module<T> {
  const Module();

  FutureOr<T> factory(DepsCallback deps);

  List<Type> deps() => [];

  Type typeOf() => T;

  bool get hasDependencies => deps().isNotEmpty;
}
