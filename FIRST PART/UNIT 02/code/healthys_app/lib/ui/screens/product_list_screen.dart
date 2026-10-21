import 'package:flutter/material.dart';
import 'package:healthys_app/data/repositories/carta_repository.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/ui/widgets/list_item.dart';

// Com que la vista dependrà d'un Future (la llista de productes que obteniim de l'API)
// la implementarem com un widget amb estat
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  // Definim la referència a l'estat
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

// Definim la classe estat (esta és la que fa implementa el build cada vegada
// que canvia l'estat)
class _ProductListScreenState extends State<ProductListScreen> {
  // Propietats de l'estat
  // La llista de productes vindrà en un Future. Com que li donarem valor en
  // la inicialització de l'estat (initState), l'hem de declarar com a "late"
  late Future<List<Producte>> _llistaProductes;
  // Referència al repositori, d'on obtindrem la llista de productes
  final CartaRepository _repository = CartaRepository(
    "https://healthys-express-backend-production.up.railway.app", // Definim la referència al repositori
  );

  @override
  void initState() {
    // Mètode per inicialitzar l'estat
    super.initState();
    // Inicialitzem la llista de productes, en aquest cas, agafem els entrants
    // Podeu provar també a fer ús de les begudes o els plats principals
    // (En una tasca posterior ja reutilitzarem estes vistes per mostrar els tres
    // tipus de productes)
    _llistaProductes = _repository.getEntrants();
  }

  @override
  Widget build(BuildContext context) {
    // Mètode per construir el widget. Retornem un Scaffold complet, amb
    // barra superior, i un Body.
    return Scaffold(
      appBar: AppBar(title: const Text('Healthys')),
      // El cos principal dependrà de la llista de productes, que és un
      // Future. Per tant fem ús del FutureBuilder:
      body: FutureBuilder(
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
          return ListView.builder(
            itemCount: productes.length,
            itemBuilder: (BuildContext context, int index) {
              return ListItem(producte: productes[index]);
            },
          );
        },
      ),
    );
  }
}
