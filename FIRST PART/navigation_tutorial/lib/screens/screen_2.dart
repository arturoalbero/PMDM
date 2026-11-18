import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  String? valor;
  
  @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        const Text("2"),
        Text("El valor es ${valor ?? 'desconocido'}"),
        ElevatedButton(
          onPressed: () {
            Future<String?> response = showDialog<String?>(
              context: context,
              builder: (context) {
                TextEditingController controller = TextEditingController();
                return AlertDialog(
                  title: const Text("Introduce tu nombre"),
                  content: TextField(controller: controller),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, controller.text),
                      child: const Text("Salir"),
                    ),
                  ],
                );
              },
            );
            response.then(
              (v) => setState(() {
                valor = v;
              }),
            );
          },
          child: const Text("Introducción de valores"),
        ),
      ],
    );
  }
}
