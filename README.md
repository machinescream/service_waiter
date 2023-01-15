Dependencies container written on pure dart

Documentation: in progress...

```dart
void main() {
  final container = DependenciesContainer(
      dependencies: {
        int: () => 5,
        String: () => '5',
      },
      lazySingletons: {String}
  );
  final str = container.dependency<String>(); // once created and returned
  final str2 = container.dependency<String>(); // already created and returned from cache
  // str and str2 are same instances
  container.clearSingleton<String>(); // removing from cache, next time call will return new one
  // not declared in singleton scope will return new one instance every time
  final integer = container.dependency<int>(); // once created
  final integer2 = container.dependency<int>(); // once created
  //integer and integer2 are different instances
}

```
