import 'package:syringe/src/inject_context.dart';
import 'package:syringe/src/module_resolver.dart';
import 'package:syringe/src/types.dart';
import 'package:syringe/syringe.dart';

final class Injector<T> {
  final List<Module> modules;
  final ProgressCallback? onProgress;
  final InjectCallback onInject;

  const Injector({
    required this.onInject,
    required this.modules,
    this.onProgress,
  });

  Future<T> inject() async {
    // check and order modules
    final newModules = ModuleResolver(modules).resolve();

    final Deps deps = {};
    int current = 0;
    final total = modules.length;
    for (final module in newModules) {
      try {
        final moduleId = module.typeOf();
        final progress = ProgressInfo(
          total: total,
          current: current,
          type: moduleId,
          phase: ProgressPhase.init,
        );

        final context = _injectContext(module: module, deps: deps);
        onProgress?.call(progress);
        final factory = await module.factory(context.deps);
        deps.putIfAbsent(moduleId, () => factory);
        current++;
        onProgress?.call(progress.copyWith(
          current: current,
          phase: ProgressPhase.done,
        ));
      } on SyringeMissingDependencyError catch (err, stackTrace) {
        throw Error.throwWithStackTrace(
          SyringeMissingDependencyError(
            dependency: err.dependency,
            module: module.runtimeType,
          ),
          stackTrace,
        );
      }
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
