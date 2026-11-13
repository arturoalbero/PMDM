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

            //labelPadding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
            //padding: EdgeInsets.all(8),
            //backgroundColor: Colors.green,
            padding: EdgeInsets.zero,
            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
            shape: const StadiumBorder(),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,

            //shape: RoundedRectangleBorder(
            // borderRadius: BorderRadius.circular(24.0),

            //),
          ),
        );
      }).toList(),
    );
  }
}
