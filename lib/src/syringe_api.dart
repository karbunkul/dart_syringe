import 'package:syringe/src/inject_context.dart';
import 'package:syringe/src/types.dart';

typedef OnFactoryCallback<T> = T Function(DepsCallback factory);

final class SyringeApi {
  final Deps _deps;

  SyringeApi({required Deps deps}) : _deps = deps;

  T createFactory<T>({
    required List<Type> deps,
    required OnFactoryCallback<T> onFactory,
  }) {
    final context = InjectContext(
      deps: _deps,
      mode: InjectMode.module,
      dependencies: deps,
    );

    return onFactory(context.deps);
  }
}
