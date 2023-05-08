import 'package:service_waiter/src/service_waiter_interface.dart';

// Represents a service waiter that manages dependencies
final class ServiceWaiter implements ServiceWaiterInterface {
  // Cache for storing instantiated dependencies
  final _cache = <Type, Object>{};

  // Factory for creating dependencies
  final _factory = <Type, Object Function()>{};

  // Updates the factory with a new dependency getter
  @override
  void update<T extends Object>(T Function(ServiceWaiter waiter) getter) {
    _factory[T] = () => getter(this);
  }

  // Retrieves a dependency of the given type, either from the cache or the factory
  @override
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

  // Removes a cached singleton instance of the given type
  @override
  void clearSingleton<T>() => _cache.remove(T);

  // Clears all cached instances and factory definitions
  @override
  void clear() {
    _cache.clear();
    _factory.clear();
  }
}
