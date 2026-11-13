import 'package:healthys_app/domain/entities/producte.dart';

/// Una línia del carret: un producte i el nombre d'unitats triades.
class ItemCarret {
  const ItemCarret({required this.producte, required this.quantitat});

  final Producte producte;
  final int quantitat;

  double get preuTotal => producte.price * quantitat;

  ItemCarret copyWith({Producte? producte, int? quantitat}) {
    // TO-DO 9: Retorna una còpia immutable de l'item canviant només
    // els valors proporcionats. Consulta l'apartat 5 dels apunts.
    return ItemCarret(
      producte: producte ?? this.producte,
      quantitat: this.quantitat,
    );
  }
}
