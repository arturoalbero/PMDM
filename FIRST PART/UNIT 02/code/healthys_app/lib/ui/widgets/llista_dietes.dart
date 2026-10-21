import 'package:flutter/material.dart';

class LlistaDietes extends StatelessWidget {
  final List<String>? dietes;

  const LlistaDietes({super.key, required this.dietes});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: dietes!.map((dieta) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 4.0, 0.0),
          child: Chip(
            labelStyle: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: Colors.white),
            label: Text(dieta),
            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,

            padding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: const StadiumBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,

            //),
          ),
        );
      }).toList(),
    );
  }
}
