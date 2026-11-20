import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: ContadorScreen())),
    );
  }
}

final contador = ValueNotifier<int>(0);

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: contador,
          builder: (context, value, child) {
            return Text("Contador: $value");
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => contador.value++,
              child: Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: ()=> contador.value--, 
              child: Icon(Icons.remove)
              )
          ],
        ),
      ],
    );
  }
}
