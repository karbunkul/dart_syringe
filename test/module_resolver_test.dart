import 'dart:async';

import 'package:syringe/src/inject_context.dart';
import 'package:syringe/src/module_resolver.dart';
import 'package:syringe/syringe.dart';
import 'package:test/test.dart';

typedef FactoryHandler<T> = T Function(InjectContext context);

class A {}

class B {}

class C {}

class D {}

class E {}

class F {}

final class TestModule<T> extends Module<T> {
  final List<Type> _deps;

  const TestModule({List<Type>? deps}) : _deps = deps ?? const [];

  @override
  List<Type> deps() => _deps;

  @override
  FutureOr<T> factory(_) {
    throw UnimplementedError();
  }
}

void main() {
  group('Resolve', () {
    resolveTest(
      [
        TestModule<A>(deps: [C]),
        TestModule<B>(deps: [A]),
        TestModule<C>(deps: [D]),
        TestModule<D>(),
        TestModule<E>(deps: [D]),
      ],
      [D, C, A, B, E],
    );

    resolveTest(
      [
        TestModule<A>(deps: [B]),
        TestModule<B>(deps: [C]),
        TestModule<C>(deps: [D]),
        TestModule<D>(),
        TestModule<E>(deps: [D]),
      ],
      [D, C, B, A, E],
    );

    resolveTest(
      [
        TestModule<A>(deps: [B, C]),
        TestModule<B>(deps: [D]),
        TestModule<C>(),
        TestModule<D>(),
      ],
      [D, C, B, A],
    );

    resolveTest(
      [
        TestModule<A>(),
        TestModule<B>(),
        TestModule<C>(),
      ],
      [A, B, C],
    );

    resolveTest(
      [
        TestModule<C>(deps: [A]),
        TestModule<A>(),
        TestModule<B>(deps: [A]),
      ],
      [A, B, C],
    );
  });

  test('Check duplicates', () {
    final resolver = ModuleResolver([
      TestModule<A>(),
      TestModule<B>(),
      TestModule<C>(),
      TestModule<A>(),
    ]);

    expect(
      resolver.resolve,
      throwsA(TypeMatcher<SyringeModuleDuplicateError>()),
    );
  });

  test('Check dependencies unresolved', () {
    final resolver = ModuleResolver([
      TestModule<A>(deps: [B, C]),
      TestModule<D>(deps: [F]),
    ]);

    expect(
      resolver.resolve,
      throwsA(TypeMatcher<SyringeUnknownDependencyError>()),
    );
  });

  test('Check cycle dependencies', () {
    final resolver = ModuleResolver([
      TestModule<A>(deps: [B]),
      TestModule<B>(deps: [C, D]),
      TestModule<C>(deps: [D]),
      TestModule<D>(deps: [A]),
    ]);

    expect(
      resolver.resolve,
      throwsA(TypeMatcher<SyringeCycleDependencyError>()),
    );
  });
}

void resolveTest(List<Module> modules, List<Type> expected) {
  test('Expected $expected', () {
    final resolver = ModuleResolver(modules);

    final resolved = resolver.resolve().map((e) => e.typeOf());
    expect(resolved, equals(expected));
  });
}
