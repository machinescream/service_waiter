// Represents a service waiter that manages dependencies
final class ServiceWaiter {
  // Cache for storing instantiated dependencies
  final _cache = <Type, Object>{};

  // Factory for creating dependencies
  final _factory = <Type, Object Function()>{};

  // Updates the factory with a new dependency getter
  void register<T extends Object>(T Function(ServiceWaiter waiter) getter) {
    _factory[T] = () => getter(this);
  }

  // Retrieves a dependency of the given type, either from the cache or the factory
  T get<T>({bool existingInstance = true}) {
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

  // Removes a cached singleton instance of the given type
  void clearSingleton<T>() => _cache.remove(T);

  // Clears all cached instances and factory definitions
  void clear() {
    _cache.clear();
    _factory.clear();
  }
}

// Custom exception for dependency not found errors
class DependencyNotFoundException<T> implements Exception {
  @override
  String toString() => 'Dependency not found: $T undeclared';
}