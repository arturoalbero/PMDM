import 'package:healthys_app/domain/entities/item_carret.dart';

/// Estat complet de la cistella de la compra.
class Carret {
  const Carret({this.items = const []});

  final List<ItemCarret> items;

  bool get esBuit => items.isEmpty;

  int get quantitatTotal {
    // TO-DO 9: Calcula el total d'unitats fent ús de fold.
    return 0;
  }

  double get preuTotal {
    // TO-DO 9: Calcula l'import acumulat de totes les línies.
    return 0;
  }

  int quantitatProducte(String producteId) {
    // TO-DO 9: Retorna la quantitat del producte o 0 si no està al carret.
    return 0;
  }
}
