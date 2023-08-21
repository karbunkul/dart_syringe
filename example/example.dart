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
      final messages = <Type, String>{
        Foo: 'Module foo, no dependencies',
        Bar: 'Module bar, have one dependency',
      };

      final phaseStr = info.phase.toString().split('.').last;
      final ProgressInfo(:total, :type, :current, :percent) = info;
      final percentStr = percent.toString().padLeft(3);
      final message = messages[type] ?? '';
      print('[$percentStr %] $current of $total ($type: $phaseStr) $message');
    },
    onInject: (deps) {
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
}
