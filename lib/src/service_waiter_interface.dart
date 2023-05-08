// Represents a service waiter that manages dependencies
abstract interface class ServiceWaiterInterface {
  // Updates the factory with a new dependency getter
  void update<T extends Object>(T Function(ServiceWaiterInterface waiter) getter);

  // Retrieves a dependency of the given type, either from the cache or the factory
  T dependency<T>({bool existingInstance = true});

  // Removes a cached singleton instance of the given type
  void clearSingleton<T>();

  // Clears all cached instances and factory definitions
  void clear();
}

// Custom exception for dependency not found errors
class DependencyNotFoundException<T> implements Exception {
  @override
  String toString() => 'Dependency not found: $T undeclared';
}
