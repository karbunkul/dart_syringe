import 'package:meta/meta.dart';
import 'package:syringe/src/errors/errors.dart';
import 'package:syringe/src/module.dart';

/// Class responsible for resolving module dependencies.
@immutable
@internal
class ModuleResolver {
  /// List of modules to be resolved.
  final List<Module> modules;

  /// Constructor for ModuleResolver.
  const ModuleResolver(this.modules);

  /// Resolves module dependencies and returns a sorted list.
  List<Module> resolve() {
    final weights = _weights();

    // Sorts all modules by weight.
    final sortedDeps = List<Module>.from(modules);
    sortedDeps.sort((a, b) {
      final aWeight = weights[a.typeOf()]!;
      final bWeight = weights[b.typeOf()]!;

      if (aWeight == bWeight) {
        final aType = a.typeOf().toString();
        final bType = b.typeOf().toString();

        return aType.compareTo(bType);
      }

      return bWeight.compareTo(aWeight);
    });

    return sortedDeps;
  }

  /// Calculates weights for modules based on their dependencies.
  Map<Type, int> _weights() {
    final result = <Type, int>{};
    for (final module in modules) {
      final id = module.typeOf();
      if (result.containsKey(id)) {
        throw SyringeModuleDuplicateError(id);
      }

      result.putIfAbsent(
        module.typeOf(),
        () => module.hasDependencies ? 5 : 10000,
      );
    }

    return modules.fold(result, (acc, cur) {
      for (final dep in _walk(module: cur)) {
        acc[dep] = acc[dep]! + 100;
      }

      return acc;
    });
  }

  /// Recursively walks through module dependencies.
  List<Type> _walk({
    required Module module,
    List<Type>? results,
    Module? source,
  }) {
    List<Type> dependencies = results ?? [];
    source ??= module;
    final sourceId = source.typeOf();

    for (final dep in module.deps) {
      if (dependencies.contains(sourceId)) {
        throw SyringeCycleDependencyError(module: sourceId);
      }
      dependencies.add(dep);

      final depModule = modules.firstWhere((element) {
        return element.typeOf() == dep;
      }, orElse: () {
        throw SyringeUnknownDependencyError(
          dependency: dep,
          module: module.runtimeType,
        );
      });

      if (depModule.hasDependencies) {
        _walk(module: depModule, results: dependencies, source: source);
      }
    }

    return dependencies;
  }
}
