import 'package:syringe/syringe.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('identical', () {
    final module1 = ExportModule<String>(
      onInject: (T Function<T>() deps) => '',
    );

    final module2 = ExportModule<String>(
      onInject: (T Function<T>() deps) => '',
    );

    expect(identical(module1, module2), equals(false));
    expect(identical(module2, module2), equals(true));
  });

  test('hashCode', () {
    final module1 = ExportModule<String>(
      onInject: (T Function<T>() deps) => '',
    );

    final module2 = ExportModule<String>(
      onInject: (T Function<T>() deps) => '',
    );

    final module3 = ProxyModule<String>(
        onInject: (T Function<T>() deps) => '', dependencies: [bool, double]);

    final module4 = ProxyModule<String>(
        onInject: (T Function<T>() deps) => '', dependencies: [double, bool]);

    expect(module1.hashCode, equals(module2.hashCode));
    expect(module1 == module2, equals(true));
    expect(module3 != module4, equals(true));
    expect(module1.export, equals(true));
    expect(module3.export, equals(false));
  });
}
