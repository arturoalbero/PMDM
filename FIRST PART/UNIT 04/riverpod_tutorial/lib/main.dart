import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_tutorial/user_name_notifier.dart';

void main() {
  runApp(ProviderScope(child: const MainApp()));
}

//creamos un PROVIDER con una referencia para identificarlo. Devuelve un string.
final appNameProvider = Provider<String>((ref) {
  return 'Counter';
});

//Creamos un Consumer
class AppTitle extends ConsumerWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //Con el método watch, teniendo en cuenta la referencia ref, el widget escucha al Provider
    final appName = ref.watch(appNameProvider);

    return Text(appName);
  }
}

//Creamos un Notifier
class CounterNotifier extends Notifier<int> {
  //Valor inicial del estado
  @override
  int build() {
    return 0;
  }

  //Modificadores del estado
  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

//Creamos un provider con el tipo de Notifier y el dato del estado.
//Los notifier tienen una propiedad new que devuelve un objeto nuevo
//Es equivalente a () => CounterNotifier()
final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);

//Creamos el consumer
class CounterText extends ConsumerWidget {
  const CounterText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //COUNT vigila los cambios en el provider
    final count = ref.watch(counterProvider);
    final name = ref.watch(userNameProvider);

    //ASYNC PROVIDER => provider asíncrono
    final userAsyncState = ref.watch(userProviderAsync);

    return Column(
      children: [
        Text('Counter: $count con nombre ${(name!="")?name:"desconocido"}'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              //read nos permite leer el notifier de counterProvider y usar sus métodos
              onPressed: () => ref.read(counterProvider.notifier).increment(),
              child: Text("+"),
            ),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).decrement(),
              child: Text("-"),
            ),
            
          ],
        ),
        NameForm(),
        Divider(),
        //ASYNC PROVIDER => colocamos la variable con el método when en lugar de un widget normal
        userAsyncState.when(
          //EL DATO QUE RECIBIMOS FINALMENTE
          data: (asyncDataReceived)=> Text(asyncDataReceived),
          //LO QUE SE VISUALIZA EN CASO DE ERROR 
          error: (error, stackTrace) => Text("Error: $error - $stackTrace"),
          //LO QUE SE VISUALIZA MIENTRAS NO TENEMOS EL DATO
          loading: ()=> Text("En espera")
          )
      ],
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        //Añadimos el CONSUMER a nuestra app
        body: Center(child: Column(children: [AppTitle(), CounterText()])),
      ),
    );
  }
}
