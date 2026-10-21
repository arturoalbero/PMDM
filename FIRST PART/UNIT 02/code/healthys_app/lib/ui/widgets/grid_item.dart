import 'package:flutter/material.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/ui/screens/producte_screen.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key, required this.producte});

  final Producte producte;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      // Amb això retallem la imatge amb les vores arrodonides
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // Estirar contingut

        children: [
          Flexible(
            flex: 8, // Ocupa 2 unitats d'espai
            child: producte.img != null
                ? Image.network(producte.img ?? "", fit: BoxFit.cover)
                : Image.asset("assets/img/not_found.png", fit: BoxFit.cover),
          ),
          Flexible(
            flex: 3,
            child: Text(
              producte.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //maxLines: 2, // ← Màxim 2 línies
              //overflow: TextOverflow.fade, // ← Efecte esvaït
            ),
          ),
        ],
      ),
    );
  }
}
