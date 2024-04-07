import 'dart:async';

import 'package:syringe/src/progress_info.dart';

/// Type definition for a map of dependencies.
typedef Deps = Map<Type, dynamic>;

/// Type definition for a callback function that retrieves dependencies.
typedef DepsCallback = T Function<T>();

/// Type definition for a callback function that performs dependency injection.
typedef InjectCallback<T> = FutureOr<T> Function(DepsCallback deps);

/// Type definition for a callback function that reports progress during injection.
typedef ProgressCallback = void Function(ProgressInfo info);
