import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/ui/providers/carta_providers.dart';
import 'package:healthys_app/ui/widgets/grid_item.dart';

/// View reutilitzable que mostra una secció de la carta.
///
/// Ja no rep un Future des del router. Observa el provider corresponent a
/// la secció i representa els estats de càrrega, error o dades.
class ProductGridScreen extends ConsumerWidget {
  const ProductGridScreen({super.key, required this.seccio});

  final String seccio;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Producte>> productes = switch (seccio) {
      // TO-DO 5: La lògica de principals ja està preparada.
      // Substitueix entrantsProvider per principalsProvider.
      'principals' => ref.watch(entrantsProvider),

      // TO-DO 8: Després de completar les begudes, connecta ací
      // begudesProvider en lloc del provider d'exemple.
      'begudes' => ref.watch(entrantsProvider),

      // Cas guiat i complet: la vista d'entrants ja observa Riverpod.
      _ => ref.watch(entrantsProvider),
    };

    return Padding(
      padding: const EdgeInsets.all(8),
      child: productes.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text("No s'han pogut carregar els productes: $error"),
        ),
        data: (items) => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final producte = items[index];

            return InkWell(
              onTap: () {
                context.push('/producte/${producte.id}', extra: producte);
              },
              child: GridItem(producte: producte),
            );
          },
        ),
      ),
    );
  }
}
