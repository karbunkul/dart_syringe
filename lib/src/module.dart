import 'dart:async';

import 'types.dart';

abstract base class Module<T> {
  const Module();

  FutureOr<T> factory(DepsCallback deps);

  List<Type> deps() => [];

  bool export() => false;

  Type typeOf() => T;

  bool get hasDependencies => deps().isNotEmpty;

  @override
  bool operator ==(Object other) {
    return other is Module<T> &&
        export() == other.export() &&
        deps().toString() == other.deps().toString();
  }

  @override
  int get hashCode {
    final exportWeight = export() ? 1000 : 100;
    return T.toString().length + exportWeight + deps().toString().length;
  }
}

final class ExportModule<T> extends Module<T> {
  final InjectCallback<T> onInject;
  final List<Type>? dependencies;

  const ExportModule({required this.onInject, this.dependencies});
  @override
  FutureOr<T> factory(DepsCallback deps) => onInject(deps);

  @override
  List<Type> deps() => dependencies ?? [];

  @override
  bool export() => true;
}

final class ProxyModule<T> extends Module<T> {
  final InjectCallback<T> onInject;
  final List<Type>? dependencies;

  const ProxyModule({required this.onInject, this.dependencies});
  @override
  FutureOr<T> factory(DepsCallback deps) => onInject(deps);

  @override
  List<Type> deps() => dependencies ?? [];

  @override
  bool export() => false;
}
