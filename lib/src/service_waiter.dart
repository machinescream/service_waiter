class ServiceWaiter {
  final _cache = <Type, Object>{};
  final _factory = <Type, Object Function()>{};

  void update<T extends Object>(T Function(ServiceWaiter waiter) getter) {
    _factory[T] = () => getter(this);
  }

  T dependency<T>({bool existingInstance = true}) {
    try {
      if (existingInstance) {
        return (_cache[T] ?? (_cache[T] = _factory[T]!())) as T;
      } else {
        return _factory[T]!() as T;
      }
    } catch (e) {
      throw DependencyNotFoundException<T>();
    }
  }

  void clearSingleton<T>() => _cache.remove(T);

  void clear() {
    _cache.clear();
    _factory.clear();
  }
}

class DependencyNotFoundException<T> implements Exception {
  @override
  String toString() => 'dependency not found:$T undeclared';
}
