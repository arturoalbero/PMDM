import 'package:flutter/material.dart';

class Pantalla3 extends StatefulWidget{
  const Pantalla3({super.key});

  @override
  State<StatefulWidget> createState() => _Pantalla3State();

}
class _Pantalla3State extends State<Pantalla3>{
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return 
      Scaffold(
        body: Column(
          children: [
            Text("Introduce un texto"),
            TextField(controller: _controller,),
            ElevatedButton(onPressed: ()=>Navigator.pop(context, _controller.text), child: const Text("Volver"))

          ],
        ),
      );
  } 
}