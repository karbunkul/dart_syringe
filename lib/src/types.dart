import 'progress_info.dart';

typedef Deps = Map<Type, dynamic>;
typedef DepsCallback = T Function<T>();

typedef InjectCallback<T> = T Function(DepsCallback deps);
typedef ProgressCallback = void Function(ProgressInfo info);
