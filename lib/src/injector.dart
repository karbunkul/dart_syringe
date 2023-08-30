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
          export: module.export,
        );

        final context = InjectContext(
          deps: deps,
          mode: InjectMode.module,
          dependencies: module.deps,
        );
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

    final ctx = InjectContext(
      deps: deps,
      mode: InjectMode.inject,
      dependencies: exportModules(),
    );

    try {
      return onInject(ctx.deps);
    } on SyringeDependencyExportError catch (err, stackTrace) {
      final module = modules.firstWhere((element) {
        return element.typeOf() == err.dependency;
      });

      throw Error.throwWithStackTrace(
        SyringeDependencyExportError(
          dependency: err.dependency,
          module: module.runtimeType,
        ),
        stackTrace,
      );
    }
  }

  List<Type> exportModules() {
    return modules.where((e) => e.export).map((e) => e.typeOf()).toList();
  }
}
