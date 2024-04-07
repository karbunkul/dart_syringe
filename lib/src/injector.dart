import 'package:meta/meta.dart';
import 'package:syringe/src/inject_context.dart';
import 'package:syringe/src/module_resolver.dart';
import 'package:syringe/src/types.dart';
import 'package:syringe/syringe.dart';

/// Immutable class representing the Injector.
@immutable
class Injector<T> {
  /// List of modules to be injected.
  final List<Module> modules;

  /// Callback for progress update during injection process.
  final ProgressCallback? onProgress;

  /// Callback for actual injection process.
  final InjectCallback onInject;

  /// Constructor for Injector.
  const Injector({
    required this.onInject,
    required this.modules,
    this.onProgress,
  });

  /// Method to perform dependency injection.
  Future<T> inject() async {
    // Check and order modules.
    final newModules = ModuleResolver(modules).resolve();

    // Initialize dependencies map.
    final Deps deps = {};
    int current = 0;
    final total = modules.length;

    // Iterate through modules.
    for (final module in newModules) {
      try {
        final moduleId = module.typeOf();
        // Create progress info.
        final progress = ProgressInfo(
          total: total,
          current: current,
          type: moduleId,
          phase: ProgressPhase.init,
          export: module.export,
        );

        // Create inject context.
        final context = InjectContext(
          deps: deps,
          mode: InjectMode.module,
          dependencies: module.deps,
        );
        // Call progress callback.
        onProgress?.call(progress);
        // Resolve factory and put into dependencies map.
        final factory = await module.factory(context.deps);
        deps.putIfAbsent(moduleId, () => factory);
        current++;
        // Update progress to 'done'.
        onProgress?.call(progress.copyWith(
          current: current,
          phase: ProgressPhase.done,
        ));
      } on SyringeMissingDependencyError catch (err, stackTrace) {
        // Throw error if dependency is missing.
        throw Error.throwWithStackTrace(
          SyringeMissingDependencyError(
            dependency: err.dependency,
            module: module.runtimeType,
          ),
          stackTrace,
        );
      }
    }

    // Create inject context for actual injection.
    final ctx = InjectContext(
      deps: deps,
      mode: InjectMode.inject,
      dependencies: exportModules(),
    );

    try {
      // Perform injection.
      return await onInject(ctx.deps);
    } on SyringeDependencyExportError catch (err, stackTrace) {
      // Throw error if dependency export fails.
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

  /// Method to export modules.
  List<Type> exportModules() {
    return modules.where((e) => e.export).map((e) => e.typeOf()).toList();
  }
}
