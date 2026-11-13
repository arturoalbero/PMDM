import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/ui/providers/carret_provider.dart';

/// Controls de la fitxa de producte connectats al carret global.
///
/// La UI es proporciona completa: els botons invoquen el notifier i la
/// quantitat observada canviarà quan es completen els casos d'ús.
class CallToActionButton extends ConsumerWidget {
  const CallToActionButton({super.key, required this.producte});

  final Producte producte;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carret = ref.watch(carretProvider);
    final quantitat = carret.quantitatProducte(producte.id);

    if (quantitat == 0) {
      return FilledButton.icon(
        onPressed: () {
          ref.read(carretProvider.notifier).afig(producte, 1);
        },
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Afig al carret'),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filledTonal(
          tooltip: 'Lleva una unitat',
          onPressed: () {
            ref.read(carretProvider.notifier).elimina(producte, 1);
          },
          icon: const Icon(Icons.remove),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            '$quantitat',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        IconButton.filled(
          tooltip: 'Afig una unitat',
          onPressed: () {
            ref.read(carretProvider.notifier).afig(producte, 1);
          },
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
