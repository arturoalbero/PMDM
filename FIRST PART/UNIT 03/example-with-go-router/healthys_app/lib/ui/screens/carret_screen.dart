import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthys_app/ui/providers/carret_provider.dart';

/// Vista del carret ja preparada per consumir l'estat de Riverpod.
///
/// En completar els TO-DOs de les entitats i casos d'ús, aquesta pantalla
/// començarà a mostrar i modificar els productes afegits.
class CarretScreen extends ConsumerWidget {
  const CarretScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carret = ref.watch(carretProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Carret')),
      body: carret.esBuit
          ? const Center(child: Text('El carret està buit'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: carret.items.length,
                    itemBuilder: (context, index) {
                      final item = carret.items[index];

                      return ListTile(
                        title: Text(item.producte.name),
                        subtitle: Text('${item.quantitat} unitats'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: 'Lleva una unitat',
                              onPressed: () {
                                ref
                                    .read(carretProvider.notifier)
                                    .elimina(item.producte, 1);
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${item.preuTotal.toStringAsFixed(2)} EUR'),
                            IconButton(
                              tooltip: 'Afig una unitat',
                              onPressed: () {
                                ref
                                    .read(carretProvider.notifier)
                                    .afig(item.producte, 1);
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total: ${carret.preuTotal.toStringAsFixed(2)} EUR',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () {
                          ref.read(carretProvider.notifier).buida();
                        },
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Buida'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
