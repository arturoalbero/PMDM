import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthys_app/domain/entities/carret.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/domain/usecases/carret/afig_producte_usecase.dart';
import 'package:healthys_app/domain/usecases/carret/buida_carret_usecase.dart';
import 'package:healthys_app/domain/usecases/carret/elimina_producte_usecase.dart';

/// View model del carret.
///
/// La interfície ja està connectada a aquest notifier. En completar els
/// casos d'ús, totes les vistes reaccionaran al nou estat automàticament.
class CarretNotifier extends Notifier<Carret> {
  final _afigProducte = AfigProducteUseCase();
  final _eliminaProducte = EliminaProducteUseCase();
  final _buidaCarret = BuidaCarretUseCase();

  @override
  Carret build() => const Carret();

  void afig(Producte producte, int quantitat) {
    state = _afigProducte.execute(state, producte, quantitat);
  }

  void elimina(Producte producte, int quantitat) {
    state = _eliminaProducte.execute(state, producte, quantitat);
  }

  void buida() {
    state = _buidaCarret.execute();
  }
}

final carretProvider = NotifierProvider<CarretNotifier, Carret>(
  CarretNotifier.new,
);
