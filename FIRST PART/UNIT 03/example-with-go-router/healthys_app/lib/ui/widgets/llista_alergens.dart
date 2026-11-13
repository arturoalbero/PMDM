import 'package:flutter/material.dart';

class LlistaAlergens extends StatelessWidget {
  final List<String>? alergens;

  static final Map<String, String> mapaAllergens = {
    "Llet": "assets/img/lactosa.png",
    "Peix": "assets/img/peix.png",
    "Sèsam": "assets/img/sesam.png",
    "Gluten": "assets/img/gluten.png",
    "Ous": "assets/img/ous.png",
    "Cervesa": "assets/img/sulfits.png",
  };

  const LlistaAlergens({super.key, required this.alergens});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: alergens!.map((alergen) {
        return SizedBox(
          width: 32,
          height: 32,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: mapaAllergens[alergen] != null
                ? Image.asset(mapaAllergens[alergen] ?? "")
                : Text("?"),
          ),
        );
      }).toList(),
    );
  }
}
