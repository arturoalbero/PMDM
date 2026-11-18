import 'package:flutter/material.dart';
import 'package:go_router_tutorial/screens/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Tutorial",
      routerConfig: appRouter,
    );
  }
}
