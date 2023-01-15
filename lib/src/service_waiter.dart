class DependenciesContainer {
  final _cache = <Type, Object>{};
  final _factory = <Type, Object Function()>{};

  void update<T extends Object>(T Function(DependenciesContainer container) getter) {
    _factory[T] = () => getter(this);
  }

  T dependency<T>({bool existingInstance = true}) {
    if (existingInstance) {
      return (_cache[T] ?? (_cache[T] = _factory[T]!())) as T;
    } else {
      return _factory[T]!() as T;
    }
  }

  void clearSingleton<T>() => _cache.remove(T);

  void clear() {
    _cache.clear();
    _factory.clear();
  }
}

class DependencyNotFoundException implements Exception {
  final Type dependencyType;

  DependencyNotFoundException(this.dependencyType);

  @override
  String toString() => 'DependencyNotFoundException: undeclared is $dependencyType';
}
