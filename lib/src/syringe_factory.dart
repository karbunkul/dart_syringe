import 'package:syringe/src/inject_context.dart';
import 'package:syringe/src/types.dart';

typedef OnFactoryCallback<T> = T Function(DepsCallback factory);

/// Class for dynamic dependency creation.
final class SyringeFactory {
  final Deps _deps;

  /// Constructor for SyringeFactory.
  SyringeFactory({required Deps deps}) : _deps = deps;

  /// Creates a new instance of type [T] dynamically.
  T create<T>({
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
