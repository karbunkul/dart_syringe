import 'dart:async';

import 'package:syringe/syringe.dart';

Future<void> main() async {
  final modules = const <Module>[
    BarModule(),
    FooModule(),
  ];

  final injector = Injector<Dependency>(
    modules: modules,
    onInject: (deps) => Dependency(foo: deps<Foo>()),
  );

  final dependency = await injector.inject();

  print(dependency.foo);
}

class Dependency {
  final Foo foo;

  Dependency({required this.foo});
}

class Foo {}

class Bar {
  final Foo foo;

  const Bar({required this.foo});
}

final class FooModule extends Module<Foo> {
  const FooModule();

  @override
  FutureOr<Foo> factory(_) => Foo();
}

final class BarModule extends Module<Bar> {
  const BarModule();

  @override
  FutureOr<Bar> factory(deps) => Bar(foo: deps<Foo>());

  @override
  List<Type> deps() => [Foo];
}
