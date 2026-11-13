import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthys_app/domain/entities/user_session.dart';
import 'package:healthys_app/ui/notifiers/user_session_notifier.dart';
// TO-DO 4: Importa flutter_riverpod i user_session_provider.dart.
import 'package:healthys_app/ui/widgets/carret_widget.dart';

/// Pantalla contenidora de les quatre seccions principals.
///
/// Inicialment mostra el nom mitjançant ValueListenableBuilder.
/// TO-DO 4: Converteix MainScreen en ConsumerWidget i observa
/// userSessionProvider amb ref.watch.
class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  int get _indexActual {
    if (location.startsWith('/principals')) return 1;
    if (location.startsWith('/begudes')) return 2;
    if (location.startsWith('/compte')) return 3;
    return 0;
  }

  String get _titol {
    return switch (_indexActual) {
      1 => 'Principals',
      2 => 'Begudes',
      3 => 'Compte',
      _ => 'Entrants',
    };
  }

  void _goToSection(BuildContext context, int index) {
    final ruta = switch (index) {
      1 => '/principals',
      2 => '/begudes',
      3 => '/compte',
      _ => '/entrants',
    };

    context.go(ruta);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titol),
        actions: [
          // Aquest widget inicial escolta el ValueNotifier.
          // TO-DO 4: Substitueix-lo per un widget que mostre el nom
          // de la sessió obtinguda amb ref.watch(userSessionProvider).
          ValueListenableBuilder<UserSession?>(
            valueListenable: userSessionNotifier,
            builder: (context, session, child) {
              if (session == null) return const SizedBox.shrink();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Center(child: Text(session.name)),
              );
            },
          ),
          const CarretWidget(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (index) => _goToSection(context, index),
        selectedIndex: _indexActual,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.bento_outlined),
            selectedIcon: Icon(Icons.bento),
            label: 'Entrants',
          ),
          NavigationDestination(
            icon: Icon(Icons.rice_bowl_outlined),
            selectedIcon: Icon(Icons.rice_bowl),
            label: 'Principals',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_drink_outlined),
            selectedIcon: Icon(Icons.local_drink),
            label: 'Begudes',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Compte',
          ),
        ],
      ),
      body: child,
    );
  }
}
