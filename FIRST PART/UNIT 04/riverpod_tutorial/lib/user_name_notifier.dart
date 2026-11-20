import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Definimos un notificador de Strings
class UserNameNotifier extends Notifier<String> {
  @override
  String build() => '';

  void changeName(String name) {
    state = name;
  }
}

//Creamos su provider como antes
final userNameProvider = NotifierProvider<UserNameNotifier, String>(
  UserNameNotifier.new,
);

//Creamos el Consumer, pero esta vez como StatefulWidget

class NameForm extends ConsumerStatefulWidget {
  const NameForm({super.key});
  //En lugar de un State, va a tener un ConsumerState
  @override
  ConsumerState<NameForm> createState() => _NameFormState();
}

// CREAMOS LA CLASE DEL ESTADO
// Esta clase ya incorpora ref como propiedad heredada, así que no la necesitamos en el build.

class _NameFormState extends ConsumerState<NameForm> {
  final _nameController = TextEditingController();

  //dispose sirve para liberar recursos, se ejecuta cuando el widget se elimina
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(controller: _nameController,),
        FilledButton(
          onPressed: () {
            // Podemos usar la propiedad ref porque está heredada
            //En este caso, leemos el providery luego cambiamos el nombre
            ref
                .read(userNameProvider.notifier)
                .changeName(_nameController.text.trim());
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}