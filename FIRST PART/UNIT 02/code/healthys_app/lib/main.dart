import 'package:flutter/material.dart';

// Llibreria del sistema per obtenir i forçar l'orientació
import 'package:flutter/services.dart';
import 'package:healthys_app/ui/screens/main_screen.dart';

void main() async {
  // Incialitzem Flutter de forma manual, abans de llançar runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Forcem el mode horitzontal
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Normal Portrait
    DeviceOrientation.portraitDown, // Upside-Down Portrait
  ]);

  // I ara llancem l'aplicació
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Healthys',
      home: MainScreen(),
    );
  }
}
