import 'package:flutter/material.dart';
import 'package:healthys_app/domain/entities/beguda.dart';
import 'package:healthys_app/domain/entities/entrant.dart';
import 'package:healthys_app/domain/entities/principal.dart';
import 'package:healthys_app/domain/entities/producte.dart';
import 'package:healthys_app/ui/widgets/call_to_action_button.dart';
import 'package:healthys_app/ui/widgets/llista_alergens.dart';
import 'package:healthys_app/ui/widgets/llista_dietes.dart';

class ProducteScreen extends StatelessWidget {
  const ProducteScreen({super.key, required this.producte});

  final Producte producte;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(title: const Text('Healthys')),
          SliverToBoxAdapter(
            child: SizedBox(
              height: (MediaQuery.of(context).size.height).clamp(0, 600),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    producte.img != null
                        ? Image.network(
                            producte.img!,
                            fit: BoxFit.cover,
                            width: (MediaQuery.sizeOf(
                              context,
                            ).width).clamp(0, 600),

                            //height: MediaQuery.sizeOf(context).height,
                          )
                        : Image.asset(
                            "assets/img/not_found.png",
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                    Positioned(
                      left: 32,
                      top: 32,
                      right: 32,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                              producte.name,
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        blurRadius: 8.0,
                                      ),
                                    ],
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            "${producte.price}€",
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(
                                  color: Colors.amberAccent,
                                  fontWeight: FontWeight.w900,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black,
                                      blurRadius: 8.0,
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 32,
                      right: 32,
                      bottom: 32,
                      child: Text(
                        producte.additionalInfo ?? "",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(color: Colors.black, blurRadius: 8.0),
                          ],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                LiniaProducte(clau: "Ingredients", valor: producte.description),
                LlistaAlergens(alergens: producte.allergens),
                producte.getClass() == ProductsType.entrant
                    ? LlistaDietes(dietes: (producte as Entrant).dietType)
                    : producte.getClass() == ProductsType.principal
                    ? LlistaDietes(dietes: (producte as Principal).dietType)
                    : (producte as Beguda).isAlcoholic
                    ? const Text("Beguda amb alcohol")
                    : const Text("Beguda sense alcohol"),
                LiniaProducte(
                  clau: "Calories",
                  valor: "${producte.calories} cal",
                ),
                callToActionButton(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class LiniaProducte extends StatelessWidget {
  const LiniaProducte({super.key, required this.clau, required this.valor});

  final String clau;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          clau,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 0.0, 8.0),
          child: Text(valor, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
