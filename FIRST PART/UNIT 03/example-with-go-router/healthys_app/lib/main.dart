import 'package:flutter/material.dart';
// TO-DO 1: Importa flutter_riverpod quan emboliques l'aplicació
// amb ProviderScope.

// Llibreria del sistema per obtenir i forçar l'orientació
import 'package:flutter/services.dart';
import 'package:healthys_app/ui/routing/app_router.dart';
import 'package:healthys_app/ui/theme/app_theme.dart';

void main() async {
  // Incialitzem Flutter de forma manual, abans de llançar runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Forcem el mode horitzontal
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Normal Portrait
    DeviceOrientation.portraitDown, // Upside-Down Portrait
  ]);

  // TO-DO 1: Riverpod necessita que MyApp quede dins d'un ProviderScope.
  // Substitueix aquesta línia per:
  //
  // runApp(const ProviderScope(child: MyApp()));
  //
  // Recorda també descomentar l'import de flutter_riverpod.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Healthys',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}
