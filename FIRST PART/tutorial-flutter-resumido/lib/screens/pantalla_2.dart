import 'package:flutter/material.dart';
import 'package:tutorial/screens/utils/my_widget_async.dart';

class Pantalla2 extends StatelessWidget {
  final int? counterValue;
  const Pantalla2({this.counterValue, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: [
          Text("El valor del contador es $counterValue"),
          MyWidgetAsync(),
          ElevatedButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            child: const Text("volver"),
          ),
        ],
      ),
    );
  }
}