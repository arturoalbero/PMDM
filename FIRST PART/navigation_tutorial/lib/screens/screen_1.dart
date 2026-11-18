import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  const Screen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Screen 1"),
        ElevatedButton(
          onPressed: (){
            showDialog(
              context: context, 
              builder: (context){
                return AlertDialog(
                  title: const Text("Mi alerta"),
                  content: const Text("Contenido"),
                  actions: [
                    TextButton(onPressed: ()=>Navigator.pop(context), 
                    child: const Text("Cancel")
                    )
                  ]
                );
              }
            );
          }, 
          child: const Text("Lancemos una alerta")),
      ],
    );
  }
}
