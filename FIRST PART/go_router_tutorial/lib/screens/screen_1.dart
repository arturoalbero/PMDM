import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Screen 1"),
          //AÑADIMOS BOTONES PARA VIAJAR A LAS DIFERENTES PANTALLAS
          TextButton(
            onPressed: () => {context.push("/s2")},
            child: Text("To Screen 2"),
          ),
          TextButton(
            onPressed: () => {context.push("/s3")},
            child: Text("To Screen 3"),
          ),
        ],
      ),
    );
  }
}
