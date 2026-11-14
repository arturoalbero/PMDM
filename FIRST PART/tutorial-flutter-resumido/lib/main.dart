import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Material',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Bar'),

          backgroundColor: Colors.amber,
          leading: const Text('Here it is the leading part'),
        ),
        body: Center(child: Counter()),
      ),
    );
  }
}

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
              MaterialPageRoute(builder: (context) => Pantalla2()),
            );
          },
        ),
      ],
    );
  }
}

class Pantalla2 extends StatelessWidget {
  const Pantalla2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Column(
        children: [
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

Future<String> asyncFunction() {
  return Future.delayed(const Duration(seconds: 5), () {
    return 'valor de retorno';
  });
}

class MyWidgetAsync extends StatelessWidget {
  const MyWidgetAsync({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asyncFunction(),
      initialData: "EN ESPERA",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String text = "";
        if (snapshot.hasData) text = snapshot.data.toString();
        return Text(text);
      },
    );
  }
}
