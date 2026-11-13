import 'package:healthys_app/data/repositories/carta_repository.dart';
import 'package:healthys_app/domain/entities/producte.dart';

/// Acció del domini per obtindre les begudes de la carta.
class GetBegudesUseCase {
  const GetBegudesUseCase(this._repository);

  // S'utilitzarà en completar el TO-DO 6.
  // ignore: unused_field
  final CartaRepository _repository;

  Future<List<Producte>> execute() {
    // TO-DO 6: Demana al repositori la llista de begudes.
    // Consulta els casos d'ús d'entrants i principals com a model.
    return Future.value(const <Producte>[]);
  }
}
