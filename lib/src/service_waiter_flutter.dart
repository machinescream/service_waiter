import 'package:flutter/material.dart';
import 'package:service_waiter/service_waiter.dart';

class ServiceProvider extends StatelessWidget {
  final void Function(ServiceWaiterInterface serviceWaiter) factory;
  final Widget child;

  ServiceProvider({
    required this.factory,
    required this.child,
    super.key,
  });

  ServiceWaiterInterface serviceWaiter() => ServiceWaiter();

  @override
  Widget build(BuildContext context) {
    return _ServiceWaiterProvider(
      factory: factory,
      child: child,
      ownerContext: context,
      serviceWaiterGetter: serviceWaiter,
    );
  }
}

final class _ServiceWaiterProvider extends InheritedWidget {
  final BuildContext ownerContext;
  final void Function(ServiceWaiterInterface serviceWaiter) factory;
  final ServiceWaiterInterface Function() serviceWaiterGetter;

  _ServiceWaiterProvider({
    required this.factory,
    required super.child,
    required this.ownerContext,
    required this.serviceWaiterGetter,
  });

  @override
  InheritedElement createElement() {
    return _InheritedElementWithDependencies(
      this,
      serviceWaiterGetter(),
      factory,
    );
  }

  @override
  bool updateShouldNotify(_ServiceWaiterProvider oldWidget) {
    return false;
  }
}

final class _InheritedElementWithDependencies extends InheritedElement {
  final ServiceWaiterInterface serviceWaiter;
  final void Function(ServiceWaiterInterface serviceWaiter) factory;

  _InheritedElementWithDependencies(
    super.widget,
    this.serviceWaiter,
    this.factory,
  ) {
    factory(serviceWaiter);
  }

  @override
  bool get debugDoingBuild => true;

  @override
  void deactivate() {
    super.deactivate();
    serviceWaiter.clear();
  }
}

extension ContextDependency on BuildContext {
  T dependency<T>({bool existingInstance = true}) {
    return _searchForDependency<T>(this, existingInstance);
  }

  T _searchForDependency<T>(BuildContext? target, bool existingInstance) {
    final candidateWidget =
        target?.getInheritedWidgetOfExactType<_ServiceWaiterProvider>();
    final candidateElement = target
        ?.getElementForInheritedWidgetOfExactType<_ServiceWaiterProvider>();
    if (candidateElement == null)
      throw Exception("ServiceWaiterProvider not found");
    try {
      return (candidateElement as _InheritedElementWithDependencies)
          .serviceWaiter
          .dependency<T>(existingInstance: existingInstance);
    } on DependencyNotFoundException {
      return _searchForDependency(
          candidateWidget?.ownerContext, existingInstance);
    }
  }
}
