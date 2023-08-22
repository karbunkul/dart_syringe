import 'dart:async';

import 'package:syringe/syringe.dart';

Future<void> main() async {
  final modules = const <Module>[
    BarModule(),
    FooModule(),
  ];

  final injector = Injector<Dependency>(
    modules: modules,
    onProgress: (info) {
      if (info.phase == ProgressPhase.done) {
        final ProgressInfo(:total, :type, :current, :percent) = info;
        final percentStr = percent.toString().padLeft(3);
        final internalStr = info.internal ? 'internal' : '';

        print('[$percentStr %] $current of $total ($type) $internalStr');
      }
    },
    onInject: (deps) {
      deps<Bar>();
      return Dependency(foo: deps<Foo>());
    },
  );

  final dependency = await injector.inject();

  print(dependency.foo.title);
}

class Dependency {
  final Foo foo;

  const Dependency({required this.foo});
}

class Foo {
  final String title;

  Foo({required this.title});
}

class Bar {
  final Foo foo;

  const Bar({required this.foo});
}

final class FooModule extends Module<Foo> {
  const FooModule();

  @override
  FutureOr<Foo> factory(_) async {
    await Future.delayed(Duration(seconds: 1));
    return Foo(title: 'hello world');
  }

  @override
  List<Type> deps() => [];
}

final class BarModule extends Module<Bar> {
  const BarModule();

  @override
  FutureOr<Bar> factory(deps) async {
    await Future.delayed(Duration(seconds: 1));
    return Bar(foo: deps<Foo>());
  }

  @override
  List<Type> deps() => [Foo];

  @override
  bool internal() => true;
}
