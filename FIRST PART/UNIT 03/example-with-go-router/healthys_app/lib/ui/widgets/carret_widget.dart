import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthys_app/ui/providers/carret_provider.dart';

/// Icona compartida que mostra el nombre total d'unitats del carret.
class CarretWidget extends ConsumerWidget {
  const CarretWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carret = ref.watch(carretProvider);

    return Badge(
      label: Text('${carret.quantitatTotal}'),
      isLabelVisible: !carret.esBuit,
      child: IconButton(
        tooltip: 'Carret',
        icon: const Icon(Icons.shopping_cart_outlined),
        onPressed: () => context.push('/carret'),
      ),
    );
  }
}
