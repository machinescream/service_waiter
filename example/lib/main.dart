import 'package:flutter/material.dart';
import 'package:service_waiter/service_waiter.dart';

void main() {
  runApp(MaterialApp(
    home: Container(
      color: Colors.white,
      child: const ServiceWaiterExample(),
    ),
  ));
}

class ServiceWaiterExample extends StatefulWidget {
  const ServiceWaiterExample({Key? key}) : super(key: key);

  @override
  State<ServiceWaiterExample> createState() => _ServiceWaiterExampleState();
}

class _ServiceWaiterExampleState extends State<ServiceWaiterExample> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      margin: const EdgeInsets.all(20),
      child: Builder(
        builder: (ctx) {
          return Container(
            color: Colors.blue,
            margin: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text("${ctx.dependency<List<int>>()}"),
                Builder(builder: (ctx) {
                  return Container(
                    color: Colors.green,
                    margin: const EdgeInsets.all(20),
                    child: Text(
                      "${ctx.dependency<int>()} and ${ctx.dependency<List<int>>().length}",
                    ),
                  );
                })
              ],
            ),
          );
        },
      ).enviroment(
        (serviceWaiter) {
          serviceWaiter.register((waiter) => 5);
        },
        ValueKey("second"),
      ),
    ).enviroment(
      (serviceWaiter) {
        serviceWaiter.register((waiter) => [1, 2, 3]);
      },
      ValueKey("first"),
    );
  }
}
