// Com que la vista dependrà d'un Future (la llista de productes que obteniim de l'API)
// la implementarem com un widget amb estat

import 'package:flutter/material.dart';
import 'package:healthys_app/ui/screens/producte_screen.dart';

class callToActionButton extends StatefulWidget {
  const callToActionButton({super.key});

  @override
  State<callToActionButton> createState() => _callToActionButtonState();
}

class _callToActionButtonState extends State<callToActionButton> {
  late int quantitat;

  initState() {
    super.initState();
    quantitat = 0;
  }

  @override
  Widget build(BuildContext context) {
    if (quantitat == 0) {
      return InkWell(
        onTap: () {
          setState(() {
            quantitat = 1;
          });
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: Colors.amber,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Afig al carret",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: Colors.amber,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton.outlined(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white, width: 2),
              ),
              color: Colors.white,
              onPressed: () {
                setState(() {
                  quantitat--;
                });
              },
              icon: Icon(Icons.remove),
            ),
            Text(
              "$quantitat",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            IconButton.outlined(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white, width: 2),
              ),
              focusColor: Colors.red,
              color: Colors.white,

              onPressed: () {
                setState(() {
                  quantitat++;
                });
              },
              icon: Icon(Icons.add),
            ),
          ],
        ),
        //  ),
      );
    }
  }
}
