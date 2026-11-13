import 'package:healthys_app/domain/entities/carret.dart';
import 'package:healthys_app/domain/entities/producte.dart';

/// Lleva unitats d'un producte i retorna un nou estat del carret.
class EliminaProducteUseCase {
  Carret execute(Carret carret, Producte producte, int quantitat) {
    // TO-DO 11: Valida la quantitat i crea un nou Carret.
    // Si la nova quantitat és zero, elimina la línia completa.
    return carret;
  }
}
