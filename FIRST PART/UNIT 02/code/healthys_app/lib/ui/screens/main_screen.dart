import 'package:flutter/material.dart';
import 'package:healthys_app/data/repositories/carta_repository.dart';
import 'package:healthys_app/domain/entities/beguda.dart';
import 'package:healthys_app/domain/entities/entrant.dart';
import 'package:healthys_app/domain/entities/principal.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/ui/screens/login_form.dart';
import 'package:healthys_app/ui/screens/product_grid_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Definim com a part de l'estat l'índex actual i el nom d'usuari
  int indexActual = 0;
  String? username;

  final CartaRepository _repository = CartaRepository(
    "https://healthys-express-backend-production.up.railway.app", // Definim la referència al repositori
  );

  // Definim  les diferents llistes de productes
  late Future<List<Entrant>> _entrants;
  late Future<List<Principal>> _principals;
  late Future<List<Beguda>> _begudes;

  @override
  initState() {
    super.initState();
    _entrants = _repository.getEntrants();
    _principals = _repository.getPrincipals();
    _begudes = _repository.getBegudes();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: [
          // Construim el títol amb run Row amb el text i el nom d'usuari
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Entrants'),
              Text(
                username ?? "Usuari no registrat",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Principals'),
              Text(
                username ?? "Usuari no registrat",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Begudes'),
              Text(
                username ?? "Usuari no registrat",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Compte'),
              Text(
                username ?? "Usuari no registrat",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ][indexActual],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            indexActual = index;
          });
        },
        selectedIndex: indexActual,
        destinations: const <Widget>[
          NavigationDestination(
            // Icones: https://fonts.google.com/icons?icon.query=meal&icon.set=Material+Icons
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
            selectedIcon: Icon(Icons.local_drink_outlined),
            label: 'Begudes',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle),
            label: 'Compte',
          ),
        ],
      ),
      body: <Widget>[
        /*
        // Com que són 3 instàncies del mateix widget, en la mateixa posició de
        // l'arbre de widgets, d'aquesta manera no funcionaria
        ProductGridScreen(productes: _entrants),
        ProductGridScreen(productes: _principals),
        ProductGridScreen(productes: _begudes),*/

        // Solució: Afegim un key diferent a cada pantalla
        ProductGridScreen(
          key: const ValueKey('entrants'),
          productes: _entrants,
        ),
        ProductGridScreen(
          key: const ValueKey('principals'),
          productes: _principals,
        ),
        ProductGridScreen(key: const ValueKey('begudes'), productes: _begudes),
        // Definim un callback per establir des del loginForm l'username
        LoginForm(
          username: username,
          size: size,
          callback: (String valor) {
            // Assignem el valor retornat al nom d'usuari, i assegurem
            // que es reflexa a la interfície.
            // Per fer ús del nom d'usuari en lloc del correu,
            // fem un split:
            setState(() {
              username = valor.split("@")[0];
            });
          },
        ),
      ][indexActual],
    );
  }
}
