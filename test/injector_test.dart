import 'package:syringe/syringe.dart';
import 'package:test/test.dart';

void main() {
  test('only export modules available for export', () async {
    final injector = Injector<String>(
      modules: [
        ExportModule<bool>(onInject: (deps) => true),
        ProxyModule<double>(onInject: (deps) => 1, dependencies: [bool]),
      ],
      onInject: (T Function<T>() deps) {
        deps<bool>();
        return 'test';
      },
    );

    expect(await injector.inject(), isA<String>());
  });

  test('proxy modules not available for export', () {
    final injector = Injector<String>(
      modules: [
        ExportModule<bool>(onInject: (deps) => true),
        ProxyModule<double>(onInject: (deps) => 1, dependencies: [bool]),
      ],
      onInject: (T Function<T>() deps) {
        deps<double>();
        return 'test';
      },
    );

    expect(
      () => injector.inject(),
      throwsA(TypeMatcher<SyringeDependencyExportError>()),
    );
  });
}
