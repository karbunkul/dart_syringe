import 'dart:async';

import 'package:syringe/syringe.dart';

Future<void> main() async {
  final modules = <Module>[
    ExportModule<Foo>(
      onInject: (deps) => Foo(bar: deps<Bar>()),
      dependencies: [Bar],
    ),
    BarModule(),
  ];

  final injector = Injector<Dependency>(
    modules: modules,
    onProgress: (info) {
      if (info.phase == ProgressPhase.done) {
        final ProgressInfo(:total, :type, :current, :percent) = info;
        final percentStr = percent.toString().padLeft(3);
        final internalStr = info.export ? 'export' : '';

        print('[$percentStr %] $current of $total ($type) $internalStr');
      }
    },
    onInject: (deps) {
      return Dependency(foo: deps<Foo>());
    },
  );

  final dependency = await injector.inject();

  print(dependency.foo.bar.title);
}

class Dependency {
  final Foo foo;

  const Dependency({required this.foo});
}

class Bar {
  final String title;

  Bar({required this.title});
}

class Foo {
  final Bar bar;

  const Foo({required this.bar});
}

final class BarModule extends Module<Bar> {
  const BarModule();

  @override
  FutureOr<Bar> factory(deps) async {
    await Future.delayed(Duration(seconds: 1));
    return Bar(title: 'Hello World');
  }

  @override
  bool get export => false;
}
