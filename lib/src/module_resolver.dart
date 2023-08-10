import 'package:syringe/src/module.dart';

import 'errors/errors.dart';

final class ModuleResolver {
  final List<Module> modules;

  const ModuleResolver(this.modules);

  List<Module> resolve() {
    final weights = _weights();

    // sorted all modules by weight
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

  Map<Type, int> _weights() {
    final result = <Type, int>{};
    for (final module in modules) {
      final id = module.typeOf();
      if (result.containsKey(id)) {
        throw SyringeModuleDuplicateError(id);
      }

      result.putIfAbsent(
        module.typeOf(),
        () => module.hasDependencies ? 5 : 1000,
      );
    }

    return modules.fold(result, (acc, cur) {
      for (final dep in _walk(module: cur)) {
        acc[dep] = acc[dep]! + 100;
      }

      return acc;
    });
  }

  List<Type> _walk({
    required Module module,
    List<Type>? results,
    Module? source,
  }) {
    List<Type> dependencies = results ?? [];
    source ??= module;
    final sourceId = source.typeOf();

    for (final dep in module.deps()) {
      if (dependencies.contains(sourceId)) {
        throw SyringeCycleDependencyError(module: sourceId);
      }
      dependencies.add(dep);

      final depModule = modules.firstWhere((element) {
        return element.typeOf() == dep;
      }, orElse: () {
        throw SyringeUnknownDependencyError(dep);
      });

      if (depModule.hasDependencies) {
        _walk(module: depModule, results: dependencies, source: source);
      }
    }

    return dependencies;
  }
}
