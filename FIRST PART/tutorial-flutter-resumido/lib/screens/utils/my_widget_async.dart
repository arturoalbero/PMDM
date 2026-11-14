import 'package:flutter/material.dart';

Future<String> asyncFunction() {
  return Future.delayed(const Duration(seconds: 5), () {
    return 'valor de retorno';
  });
}

class MyWidgetAsync extends StatelessWidget {
  const MyWidgetAsync({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: asyncFunction(),
      initialData: "EN ESPERA",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String text = "";
        if (snapshot.hasData) text = snapshot.data.toString();
        return Text(text);
      },
    );
  }
}