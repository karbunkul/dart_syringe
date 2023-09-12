import 'dart:async';

import 'progress_info.dart';

typedef Deps = Map<Type, dynamic>;
typedef DepsCallback = T Function<T>();

typedef InjectCallback<T> = FutureOr<T> Function(DepsCallback deps);
typedef ProgressCallback = void Function(ProgressInfo info);
