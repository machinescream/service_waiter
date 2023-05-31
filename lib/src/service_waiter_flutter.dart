import 'package:flutter/material.dart';
import 'package:service_waiter/service_waiter.dart';

typedef Updater = void Function(ServiceWaiter serviceWaiter);

extension Environment on Widget {
  ServiceWaiterProvider enviroment(Updater updater, [Key? key]) {
    return ServiceWaiterProvider(
      key: key,
      child: this,
      updater: updater,
    );
  }
}

final class ServiceWaiterProvider extends StatelessWidget {
  final Updater updater;
  final Widget child;

  const ServiceWaiterProvider({
    super.key,
    required this.updater,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ServiceWaiterInherited(
      updater: updater,
      child: child,
      ownerElement: context,
    );
  }
}

final class ServiceWaiterInherited extends InheritedWidget {
  final Updater updater;
  final BuildContext ownerElement;

  ServiceWaiterInherited({
    required this.updater,
    required super.child,
    required this.ownerElement,
    super.key,
  });

  @override
  InheritedElement createElement() {
    return _InheritedElementWithDependencies(this, updater);
  }

  @override
  bool updateShouldNotify(ServiceWaiterInherited oldWidget) {
    return false;
  }
}

final class _InheritedElementWithDependencies extends InheritedElement {
  final Updater updater;
  ServiceWaiter? serviceWaiter = ServiceWaiter();

  _InheritedElementWithDependencies(super.widget, this.updater) {
    updater(serviceWaiter!);
  }

  @override
  bool get debugDoingBuild => true;

  @override
  void deactivate() {
    serviceWaiter!.clear();
    serviceWaiter = null;
    super.deactivate();
  }
}

extension ContextDependency on BuildContext {
  T dependency<T>({bool existingInstance = true}) {
    final candidateWidget =
        this.getInheritedWidgetOfExactType<ServiceWaiterInherited>();
    final candidateElement =
        this.getElementForInheritedWidgetOfExactType<ServiceWaiterInherited>();
    if (candidateElement == null || candidateWidget == null)
      throw Exception("ServiceWaiterProvider not found");
    try {
      return (candidateElement as _InheritedElementWithDependencies)
          .serviceWaiter!
          .get<T>(existingInstance: existingInstance);
    } on DependencyNotFoundException {
      return candidateWidget.ownerElement
          .dependency(existingInstance: existingInstance);
    }
  }
}
