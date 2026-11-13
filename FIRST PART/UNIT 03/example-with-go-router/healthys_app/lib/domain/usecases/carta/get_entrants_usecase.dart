import 'package:healthys_app/data/repositories/carta_repository.dart';
import 'package:healthys_app/domain/entities/producte.dart';

/// Acció del domini per obtindre els entrants de la carta.
class GetEntrantsUseCase {
  const GetEntrantsUseCase(this._repository);

  final CartaRepository _repository;

  Future<List<Producte>> execute() {
    return _repository.getEntrants();
  }
}
