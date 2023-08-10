import 'package:syringe/src/inject_context.dart';
import 'package:syringe/src/module.dart';
import 'package:syringe/src/module_resolver.dart';
import 'package:syringe/src/types.dart';

final class Injector<T> {
  final List<Module> modules;
  final InjectCallback onInject;

  const Injector({
    required this.onInject,
    required this.modules,
  });

  Future<T> inject() async {
    // check and order modules
    final newModules = ModuleResolver(modules).resolve();

    final Deps deps = {};

    for (final module in newModules) {
      final context = _injectContext(module: module, deps: deps);
      final factory = await module.factory(context.deps);
      deps.putIfAbsent(module.typeOf(), () => factory);
    }

    final ctx = InjectContext(deps: deps);

    return onInject(ctx.deps);
  }

  InjectContext _injectContext({required Module module, required Deps deps}) {
    final Deps newDeps = module.deps().fold({}, (acc, cur) {
      acc.putIfAbsent(cur, () => deps[cur]);

      return acc;
    });

    return InjectContext(deps: newDeps);
  }
}
