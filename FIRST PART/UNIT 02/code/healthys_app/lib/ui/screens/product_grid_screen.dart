import 'package:flutter/material.dart';
//import 'package:healthys_app/data/repositories/carta_repository.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/ui/screens/producte_screen.dart';
import 'package:healthys_app/ui/widgets/grid_item.dart';

// Com que la vista dependrà d'un Future (la llista de productes que obteniim de l'API)
// la implementarem com un widget amb estat
class ProductGridScreen extends StatefulWidget {
  const ProductGridScreen({super.key, required this.productes});

  // Ens passen de fora la llista de productes
  final Future<List<Producte>> productes;

  // Definim la referència a l'estat
  @override
  State<ProductGridScreen> createState() => _ProductGridScreenState();
}

// Definim la classe estat (esta és la que fa implementa el build cada vegada
// que canvia l'estat)
class _ProductGridScreenState extends State<ProductGridScreen> {
  // Propietats de l'estat
  // La llista de productes vindrà en un Future. Com que li donarem valor en
  // la inicialització de l'estat (initState), l'hem de declarar com a "late"
  late Future<List<Producte>> _llistaProductes;

  @override
  void initState() {
    // Mètode per inicialitzar l'estat
    super.initState();
    // Inicialitzem la llista de productes amb
    // els productes del widget
    _llistaProductes = widget.productes;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: _llistaProductes, // Dependrem del Future _llistaProductes
        builder: (context, asyncSnapshot) {
          // Quan el Future _llistaProductes estiga complet, s'invoca aquest builder
          // Mentre no es reben dades, mostrarem una barra de procrés circular
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (asyncSnapshot.hasError) {
            // Si hi ha algun error es mostra
            return Center(child: Text("Error: ${asyncSnapshot.error}"));
          }

          // Si tot va bé, en asyncSnapshot.data tindrem les dades (la llista de productes)
          List<Producte> productes = asyncSnapshot.data ?? [];
          // Fem ús de ListviewBuilder per construir la llista d'items
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columnes
              crossAxisSpacing: 8, // separació horitzontal
              mainAxisSpacing: 8,
            ), // separació vertical
            itemCount: productes.length,
            itemBuilder: (BuildContext context, int index) {
              // Detecció de gestos amb Inkwell.
              // Quan es faça clic en ell se'ns porta a la
              // pantalla de detall dels productes (ProducteScreen), passant-li
              // el producte que estem tractant (productes[index]) per mostrar

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          ProducteScreen(producte: productes[index]),
                    ),
                  );
                },
                child: GridItem(producte: productes[index]),
              );
            },
          );
        },
      ),
      //),
    );
  }
}
