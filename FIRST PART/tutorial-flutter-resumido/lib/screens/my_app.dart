import 'package:flutter/material.dart';
import 'package:tutorial/screens/counter.dart';
import 'package:tutorial/screens/pantalla_3.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? cabecera;

  Future<void> _irPantalla3(BuildContext context) async {
    final String? respuesta = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Pantalla3()),
    );
    setState(() => cabecera = respuesta);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Material',
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('App Bar'),

              backgroundColor: Colors.amber,
              leading: Text(cabecera ?? 'it is the leading part'),
            ),
            body: Column(
              children: [
                ElevatedButton(
                  onPressed: () => _irPantalla3(context),
                  child: const Text("introduce texto de cabecera"),
                ),
                Center(child: Counter()),
              ],
            ),
          );
        },
      ),
    );
  }
}
