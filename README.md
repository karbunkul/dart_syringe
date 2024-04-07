# Syringe

Syringe is a dependency injection (DI) library for Dart applications.

## Features

- **Dependency Injection**: Easily manage dependencies in your Dart applications using a flexible and intuitive API.
- **Service Locator**: Utilize a service locator pattern for creating and resolving objects with dependencies.
- **Module Visibility**: Organize your dependencies into modules with customizable visibility settings.
- **Cyclic Dependency Detection**: Detect and prevent cyclic dependencies to ensure the stability of your application.
- **Testable Code**: Improve the testability of your codebase by decoupling components and mocking dependencies.

## Installation

To use Syringe in your Dart project, add it to your `pubspec.yaml`:

```yaml
dependencies:
  syringe: ^0.9.7-pre
```

Then, run dart pub get to install the package.

## Usage

```dart
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
}

/// Class representing a dependency.
class Dependency {
  final Foo foo;

  /// Factory method to create Dependency instances.
  static Dependency onInject(DepsCallback deps) {
    return Dependency(foo: deps<Foo>());
  }

  const Dependency({required this.foo});
}

/// Class representing a Bar instance.
class Bar {
  final String title;

  Bar({required this.title});
}

/// Class representing a Foo instance.
class Foo {
  final Bar bar;

  const Foo({required this.bar});
}

/// Module for creating Bar instances.
final class BarModule extends Module<Bar> {
  const BarModule();

  @override
  FutureOr<Bar> factory(deps) async {
    // Simulate delay before creating Bar instance.
    await Future.delayed(Duration(seconds: 1));
    return Bar(title: 'Hello World');
  }

  @override
  bool get export => false;
}
```

## Contributing

We welcome contributions to the project! If you have any suggestions for improvements or if you find any bugs, please contribute.

## License

This project is licensed under the terms of the MIT License.