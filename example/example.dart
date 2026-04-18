import 'dart:async';

import 'package:syringe/syringe.dart';

Future<void> main() async {
  // Define modules for dependency injection.
  final modules = <Module>[
    ExportModule<Foo>(
      // Define factory method for Foo using ExportModule.
      onInject: (deps) => Foo(bar: deps<Bar>()),
      dependencies: [Bar], // Dependencies required by Foo.
    ),
    BarModule(), // Module for creating Bar instances.
  ];

  // Create an injector instance.
  final injector = Injector<Dependency>(
    modules: modules, // List of modules to inject.
    onProgress: (info) {
      // Callback to track injection progress.
      if (info.phase == ProgressPhase.done) {
        final total = info.total;
        final type = info.type;
        final current = info.current;
        final percent = info.percent;
        final percentStr = percent.toString().padLeft(3);
        final internalStr = info.export ? 'export' : '';

        // Print progress information.
        print('[$percentStr %] $current of $total ($type) $internalStr');
      }
    },
    onInject: Dependency.onInject, // Callback to create Dependency instances.
  );

  // Perform dependency injection and await the result.
  final dependency = await injector.inject();

  // Print title of the Bar instance associated with Foo.
  print(dependency.foo.bar.title);

  print(dependency.blocs.foo().time);
  print(dependency.blocs.foo().time);
}

/// Class representing a dependency.
class Dependency {
  final Foo foo;
  final Blocs blocs;

  /// Factory method to create Dependency instances.
  static Dependency onInject(DepsCallback deps) {
    final factory = deps<SyringeFactory>();

    return Dependency(foo: deps<Foo>(), blocs: Blocs(factory: factory));
  }

  const Dependency({required this.foo, required this.blocs});
}

final class Blocs {
  final SyringeFactory _factory;

  Foo foo() {
    return _factory.create<Foo>(
        deps: [Bar],
        onFactory: (factory) {
          return Foo(bar: factory<Bar>());
        });
  }

  Blocs({required SyringeFactory factory}) : _factory = factory;
}

/// Class representing a Bar instance.
class Bar {
  final String title;

  Bar({required this.title});
}

/// Class representing a Foo instance.
class Foo {
  final Bar bar;
  final DateTime time;

  Foo({
    required this.bar,
  }) : time = DateTime.now();
}

/// Module for creating Bar instance.
final class BarModule extends Module<Bar> {
  const BarModule();

  @override
  FutureOr<Bar> factory(deps) async {
    // Simulate delay before creating Bar instance.
    await Future.delayed(Duration(seconds: 1));
    return Bar(title: 'Hello World');
  }

  @override
  bool get export => true;
}
