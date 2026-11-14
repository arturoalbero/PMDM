import 'package:flutter/material.dart';
import 'package:tutorial/screens/counter.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
