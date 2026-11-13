import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/ui/providers/carta_providers.dart';
import 'package:healthys_app/ui/screens/carret_screen.dart';
import 'package:healthys_app/ui/screens/login_form.dart';
import 'package:healthys_app/ui/screens/main_screen.dart';
import 'package:healthys_app/ui/screens/product_grid_screen.dart';
import 'package:healthys_app/ui/screens/producte_screen.dart';

/// La navegació només decideix quina pantalla mostrar.
///
/// En la unitat anterior el router construïa el repositori i guardava els
/// Future de productes. Ara eixa responsabilitat passa als providers.
final GoRouter appRouter = GoRouter(
  initialLocation: '/entrants',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScreen(location: state.uri.path, child: child);
      },
      routes: [
        GoRoute(
          path: '/entrants',
          builder: (context, state) =>
              const ProductGridScreen(seccio: 'entrants'),
        ),
        GoRoute(
          path: '/principals',
          builder: (context, state) =>
              const ProductGridScreen(seccio: 'principals'),
        ),
        GoRoute(
          path: '/begudes',
          builder: (context, state) =>
              const ProductGridScreen(seccio: 'begudes'),
        ),
        GoRoute(
          path: '/compte',
          builder: (context, state) => const LoginForm(),
        ),
      ],
    ),
    GoRoute(path: '/carret', builder: (context, state) => const CarretScreen()),
    GoRoute(
      path: '/producte/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final extra = state.extra;

        // En navegar des de la graella ja tenim el producte disponible.
        if (extra is Producte) {
          return ProducteScreen(producte: extra);
        }

        // Si obrim directament una URL, el busquem en els providers.
        return ProducteByIdScreen(id: id);
      },
    ),
  ],
);

class ProducteByIdScreen extends ConsumerWidget {
  const ProducteByIdScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entrants = ref.watch(entrantsProvider);
    final principals = ref.watch(principalsProvider);
    final begudes = ref.watch(begudesProvider);

    if (entrants.isLoading || principals.isLoading || begudes.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (entrants.hasError || principals.hasError || begudes.hasError) {
      return const _ProducteNotFound();
    }

    final productes = <Producte>[
      ...entrants.value ?? [],
      ...principals.value ?? [],
      ...begudes.value ?? [],
    ];

    for (final producte in productes) {
      if (producte.id == id) return ProducteScreen(producte: producte);
    }

    return const _ProducteNotFound();
  }
}

class _ProducteNotFound extends StatelessWidget {
  const _ProducteNotFound();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Producte no trobat')),
      body: const Center(child: Text("No s'ha pogut trobar aquest producte.")),
    );
  }
}
