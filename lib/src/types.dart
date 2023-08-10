typedef Deps = Map<Type, dynamic>;
typedef DepsCallback = T Function<T>();

typedef InjectCallback<T> = T Function(DepsCallback deps);
