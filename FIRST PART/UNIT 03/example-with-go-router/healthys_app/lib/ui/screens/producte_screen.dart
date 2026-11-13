import 'package:flutter/material.dart';
import 'package:healthys_app/domain/entities/beguda.dart';
import 'package:healthys_app/domain/entities/entrant.dart';
import 'package:healthys_app/domain/entities/principal.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/ui/widgets/call_to_action_button.dart';
import 'package:healthys_app/ui/widgets/carret_widget.dart';
import 'package:healthys_app/ui/widgets/llista_alergens.dart';
import 'package:healthys_app/ui/widgets/llista_dietes.dart';

class ProducteScreen extends StatelessWidget {
  // Ara el producte se'ns passa com a argument.
  const ProducteScreen({super.key, required this.producte});

  final Producte producte;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Scaffold(
      // Amb CustomScrollView tota la pantalla forma part del mateix scroll.
      // Això evita el problema d'overflow que teníem amb Column quan la
      // pantalla era massa baixa o es redimensionava la finestra.
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: _headerHeight(context),
            backgroundColor: scheme.primary,
            foregroundColor: scheme.onPrimary,
            title: const Text('Healthys'),
            actions: const [CarretWidget()],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.fadeTitle,
              ],
              background: _ProductHeader(producte: producte),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              child: _ProductDetails(producte: producte),
            ),
          ),
        ],
      ),
    );
  }

  double _headerHeight(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    // L'altura de la capçalera es calcula amb proporcions i amb límits.
    // Així es manté expressiva en pantalles grans, però no devora tot l'espai
    // disponible en horitzontal o en finestres baixes.
    return (size.height * 0.42).clamp(220.0, 360.0);
  }
}

class _ProductHeader extends StatelessWidget {
  const _ProductHeader({required this.producte});

  final Producte producte;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Stack(
      fit: StackFit.expand,
      children: [
        _ProductImage(producte: producte),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withValues(alpha: 0.72),
                Colors.black.withValues(alpha: 0.18),
                Colors.black.withValues(alpha: 0.78),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          left: 24,
          right: 24,
          bottom: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      producte.name,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            shadows: const [
                              Shadow(color: Colors.black, blurRadius: 8),
                            ],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 16),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        "${producte.price.toStringAsFixed(2)} €",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if ((producte.additionalInfo ?? "").isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  producte.additionalInfo!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: const [Shadow(color: Colors.black, blurRadius: 8)],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.producte});

  final Producte producte;

  @override
  Widget build(BuildContext context) {
    if (producte.img != null) {
      return Image.network(
        producte.img!,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            "assets/img/not_found.png",
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      "assets/img/not_found.png",
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({required this.producte});

  final Producte producte;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LiniaProducte(
              clau: "Ingredients",
              valor: producte.description,
              icon: Icons.restaurant_menu,
            ),
            const SizedBox(height: 8),
            _InfoSection(
              title: "Al·lèrgens",
              icon: Icons.warning_amber,
              child: LlistaAlergens(alergens: producte.allergens),
            ),
            const SizedBox(height: 8),
            _InfoSection(
              title: _productTypeTitle(producte),
              icon: _productTypeIcon(producte),
              child: _ProductTypeInfo(producte: producte),
            ),
            const SizedBox(height: 8),
            LiniaProducte(
              clau: "Calories",
              valor: "${producte.calories} cal",
              icon: Icons.local_fire_department_outlined,
            ),
            const SizedBox(height: 20),
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CallToActionButton(producte: producte),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _productTypeTitle(Producte producte) {
    return switch (producte.getClass()) {
      ProductsType.entrant => "Dietes",
      ProductsType.principal => "Dietes",
      ProductsType.beguda => "Informació de la beguda",
    };
  }

  IconData _productTypeIcon(Producte producte) {
    return switch (producte.getClass()) {
      ProductsType.entrant => Icons.eco_outlined,
      ProductsType.principal => Icons.eco_outlined,
      ProductsType.beguda => Icons.local_bar_outlined,
    };
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: scheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _ProductTypeInfo extends StatelessWidget {
  const _ProductTypeInfo({required this.producte});

  final Producte producte;

  @override
  Widget build(BuildContext context) {
    if (producte.getClass() == ProductsType.entrant) {
      return LlistaDietes(dietes: (producte as Entrant).dietType);
    }

    if (producte.getClass() == ProductsType.principal) {
      return LlistaDietes(dietes: (producte as Principal).dietType);
    }

    final Beguda beguda = producte as Beguda;
    return Text(
      beguda.isAlcoholic ? "Beguda amb alcohol" : "Beguda sense alcohol",
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class LiniaProducte extends StatelessWidget {
  const LiniaProducte({
    super.key,
    required this.clau,
    required this.valor,
    required this.icon,
  });

  final String clau;
  final String valor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return _InfoSection(
      title: clau,
      icon: icon,
      child: Text(valor, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
