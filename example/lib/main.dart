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
    return FirstLevelShowcase().enviroment(
      (serviceWaiter) => serviceWaiter.register((waiter) => [1, 2, 3]),
    );
  }
}

class FirstLevelShowcase extends StatelessWidget {
  late final List<int> nums;
  FirstLevelShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    nums = context.dependency<List<int>>();
    return Column(
      children: [
        Text(nums.toString()),
        Expanded(
          child: ColoredBox(
            color: Colors.red,
            child: SecondLevelShowcase().enviroment(
              (serviceWaiter) {
                serviceWaiter.register((waiter) => nums.length);
              },
            ),
          ),
        )
      ],
    );
  }
}

// getting dependency from first level enviroment to pass string representation
// to third level
class SecondLevelShowcase extends StatelessWidget {
  late final int numsLength;
  SecondLevelShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    numsLength = context.dependency<int>();
    return Column(
      children: [
        Text("$numsLength"),
        Expanded(
          child: ColoredBox(
            color: Colors.blue,
            child: ThirdLevelShowcase().enviroment(
              (serviceWaiter) {
                serviceWaiter.register(
                  (waiter) => context.dependency<List<int>>().toString(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ThirdLevelShowcase extends StatelessWidget {
  late final String stringRepresentation;
  ThirdLevelShowcase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    stringRepresentation = context.dependency<String>();
    return Text(stringRepresentation);
  }
}
