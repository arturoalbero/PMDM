import 'package:flutter/material.dart';
import 'package:healthys_app/domain/entities/producte.dart';

class ListItem extends StatelessWidget {
  const ListItem({super.key, required this.producte});

  final Producte producte;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(producte.name),
      isThreeLine: false,
      subtitle: Text(producte.description),
      // Exemple d'interfície declarativa. Segons existisca o no imatge
      // es dibuida una o altra cosa.
      leading: producte.img != null
          ? Image.network(producte.img ?? "")
          : Image.asset("assets/img/not_found.png"),
      visualDensity: VisualDensity.standard,
    );
  }
}
