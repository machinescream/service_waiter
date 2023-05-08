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
    return ServiceProvider(
      factory: (sw) {
        sw.update<List>((waiter) => []);
      },
      child: ServiceProvider(
        factory: (sw) {
          sw.update((waiter) => "hello");
        },
        child: ServiceProvider(
          factory: (sw) {
            sw.update((waiter) => 1);
          },
          child: GestureDetector(
            onTap: (){
              setState(() {

              });
            },
            child: Builder(
              builder: (ctx) {
                return Center(
                  child: Text(
                    "${ctx.dependency<int>()} ${ctx.dependency<String>()} ${ctx.dependency<List>()}",
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
