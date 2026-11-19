import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router_tutorial/screens/screen_1.dart';
import 'package:go_router_tutorial/screens/screen_2.dart';
import 'package:go_router_tutorial/screens/screen_3.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  //DEFINIMOS LA RUTA INICIAL
  initialLocation: "/s1",
  navigatorKey: navigatorKey,
  routes: [
    //DEFINIMOS LAS RUTAS
    ShellRoute(
      routes: [
        GoRoute(path: "/s1", builder: (context, state) => const Screen1()),
        GoRoute(path: "/s2", builder: (context, state) => const Screen2()),
        GoRoute(path: "/s3", builder: (context, state) => const Screen3()),
      ],
      builder: (context, state, child) {
        return Scaffold(body: child);
      },
    ),
    //AHORA RUTAS CON PARÁMETROS
    GoRoute(
      path: "/screen/:number",
      builder: (context, state) {
        final String? number = state.pathParameters['number'];
        switch (number) {
          case '1':
            return Screen1();
          case '2':
            return Screen2();
          case '3':
            return Screen3();
          default:
            return Text("Pantalla no encontrada");
        }
      },
    ),
  ],
);
