import 'package:flutter/material.dart';
import 'package:tutorial/screens/pantalla_2.dart';
import 'package:tutorial/screens/utils/my_widget_async.dart';


class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Contador = $counter"),
        ElevatedButton(
          onPressed: () => setState(() {
            counter += 1;
          }),
          child: Icon(Icons.add),
        ),
        MyWidgetAsync(),
        ElevatedButton(
          child: const Text('ir a otra pantalla'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Pantalla2(counterValue: counter,)),
            );
          },
        ),
      ],
    );
  }
}
