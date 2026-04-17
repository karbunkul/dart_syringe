import 'package:test/test.dart';
import 'package:syringe/syringe.dart';
import 'package:syringe/src/syringe_api.dart';

class ServiceA {}

class ServiceB {
  final ServiceA a;
  ServiceB(this.a);
}

class ServiceC {}

class ModuleA extends Module<ServiceA> {
  @override
  bool get export => true;

  @override
  Future<ServiceA> factory(DepsCallback deps) async => ServiceA();
}

class ModuleB extends Module<ServiceB> {
  @override
  List<Type> get deps => [ServiceA];

  @override
  Future<ServiceB> factory(DepsCallback deps) async =>
      ServiceB(deps<ServiceA>());
}

class ModuleC extends Module<ServiceC> {
  @override
  bool get export => false;

  @override
  Future<ServiceC> factory(DepsCallback deps) async => ServiceC();
}

class BuggyModule extends Module<String> {
  @override
  Future<String> factory(DepsCallback deps) async {
    deps<SyringeApi>(); // Should throw
    return 'bug';
  }
}

void main() {
  group('SyringeApi Tests', () {
    test('SyringeApi should be available in onInject', () async {
      final injector = Injector<bool>(
        modules: [ModuleA()],
        onInject: (deps) {
          final api = deps<SyringeApi>();
          expect(api, isA<SyringeApi>());
          return true;
        },
      );

      final result = await injector.inject();
      expect(result, isTrue);
    });

    test(
      'SyringeApi.createFactory should resolve dependencies correctly',
      () async {
        final injector = Injector<ServiceB>(
          modules: [ModuleA()],
          onInject: (deps) {
            final api = deps<SyringeApi>();

            // Dynamically create ServiceB using SyringeApi
            return api.createFactory(
              deps: [ServiceA],
              onFactory: (factory) => ServiceB(factory<ServiceA>()),
            );
          },
        );

        final result = await injector.inject();
        expect(result, isA<ServiceB>());
        expect(result.a, isA<ServiceA>());
      },
    );

    test(
      'SyringeApi.createFactory should produce different instances when called multiple times',
      () async {
        final injector = Injector<void>(
          modules: [ModuleA()],
          onInject: (deps) {
            final api = deps<SyringeApi>();

            final instance1 = api.createFactory(
              deps: [ServiceA],
              onFactory: (factory) => ServiceB(factory<ServiceA>()),
            );

            final instance2 = api.createFactory(
              deps: [ServiceA],
              onFactory: (factory) => ServiceB(factory<ServiceA>()),
            );

            expect(instance1, isNot(same(instance2)));
            expect(
              instance1.a,
              same(instance2.a),
            ); // Shared dependency from graph
          },
        );

        await injector.inject();
      },
    );

    test(
      'SyringeApi should respect dependency privacy (export: false)',
      () async {
        final injector = Injector<void>(
          modules: [ModuleC()],
          onInject: (deps) {
            final api = deps<SyringeApi>();

            expect(
              () => api.createFactory(
                deps: [ServiceC],
                onFactory: (factory) => factory<ServiceC>(),
              ),
              throwsA(isA<SyringeMissingDependencyError>()),
            );
          },
        );

        await injector.inject();
      },
    );

    test(
      'SyringeApi should throw if required dependency is not declared in createFactory',
      () async {
        final injector = Injector<void>(
          modules: [ModuleA()],
          onInject: (deps) {
            final api = deps<SyringeApi>();

            expect(
              () => api.createFactory(
                deps: [], // Empty deps, but trying to get ServiceA
                onFactory: (factory) => factory<ServiceA>(),
              ),
              throwsA(isA<SyringeMissingDependencyError>()),
            );
          },
        );

        await injector.inject();
      },
    );

    test(
      'SyringeApi should not be available inside modules (InjectMode.module)',
      () async {
        final injector = Injector<String>(
          modules: [BuggyModule()],
          onInject: (deps) => 'ok',
        );

        expect(
          () => injector.inject(),
          throwsA(isA<SyringeMissingDependencyError>()),
        );
      },
    );
  });
}
