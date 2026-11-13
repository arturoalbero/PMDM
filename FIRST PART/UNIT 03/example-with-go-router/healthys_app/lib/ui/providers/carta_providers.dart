import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthys_app/data/repositories/carta_repository.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/domain/usecases/carta/get_begudes_usecase.dart';
import 'package:healthys_app/domain/usecases/carta/get_entrants_usecase.dart';
import 'package:healthys_app/domain/usecases/carta/get_principals_usecase.dart';

const String _urlBase =
    'https://healthys-express-backend-production.up.railway.app';

// El repositori deixa d'estar construït al router. Riverpod el proporciona
// a tots els casos d'ús que el necessiten.
final cartaRepositoryProvider = Provider<CartaRepository>((ref) {
  return CartaRepository(_urlBase);
});

// ---------- Entrants: exemple complet ----------

final getEntrantsUseCaseProvider = Provider<GetEntrantsUseCase>((ref) {
  final repository = ref.watch(cartaRepositoryProvider);
  return GetEntrantsUseCase(repository);
});

class EntrantsNotifier extends AsyncNotifier<List<Producte>> {
  @override
  Future<List<Producte>> build() {
    final getEntrants = ref.watch(getEntrantsUseCaseProvider);
    return getEntrants.execute();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(getEntrantsUseCaseProvider).execute(),
    );
  }
}

final entrantsProvider =
    AsyncNotifierProvider<EntrantsNotifier, List<Producte>>(
      EntrantsNotifier.new,
    );

// ---------- Principals: lògica proporcionada; cal connectar la vista ----------

final getPrincipalsUseCaseProvider = Provider<GetPrincipalsUseCase>((ref) {
  final repository = ref.watch(cartaRepositoryProvider);
  return GetPrincipalsUseCase(repository);
});

class PrincipalsNotifier extends AsyncNotifier<List<Producte>> {
  @override
  Future<List<Producte>> build() {
    final getPrincipals = ref.watch(getPrincipalsUseCaseProvider);
    return getPrincipals.execute();
  }
}

final principalsProvider =
    AsyncNotifierProvider<PrincipalsNotifier, List<Producte>>(
      PrincipalsNotifier.new,
    );

// ---------- Begudes: completa aquest patró a partir dels exemples ----------

final getBegudesUseCaseProvider = Provider<GetBegudesUseCase>((ref) {
  final repository = ref.watch(cartaRepositoryProvider);
  return GetBegudesUseCase(repository);
});

class BegudesNotifier extends AsyncNotifier<List<Producte>> {
  @override
  Future<List<Producte>> build() {
    // TO-DO 7: Obté el cas d'ús amb ref.watch i executa'l.
    return Future.value(const <Producte>[]);
  }
}

final begudesProvider = AsyncNotifierProvider<BegudesNotifier, List<Producte>>(
  BegudesNotifier.new,
);
