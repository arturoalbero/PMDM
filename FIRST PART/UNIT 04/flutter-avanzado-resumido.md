# Manejo de estados

## 1. Mecanismos para el cambio de estado en Flutter

En Flutter hay varias formas de cambiar el estado de una aplicación. Hasta ahora hemos usado `setState` y `StateFulWidget` para conseguirlo, pero tenemos las siguientes:

- `setState`, para estados locales que permanecen en el widget
- `ValueNotifier` y `ChangeNotifier`, para encapsular cambios simples y notificar a la interfaz.
- `Provider`, que permite compartir información y notificadores a través del árbol de widgets.
- `BLoC` o `Cubit`, que comparten el estado usando eventos y streams.
- `Riverpod`, que evita por completo BuildContext.

## 2. ValueNotifier

ValueNotifier nos permite fácilmente compartir un valor entre varios widgets, sin necesidad de transferirlos. Funciona como una especie de variable global que notifica a todo aquel que lo escuche. Necesitamos por un lado una variable `ValueNotifier`, donde se almacena el valor que queremos compartir, y por otro lado un widget `ValueListenableBuilder`, que nos permite escuchar a un `Notifier` y reaccionar cuando su valor cambie. En ambos casos, se trata de elementos genéricos, por lo que hay que indicar entre `<>` el tipo de dato al que hacen referencia.

```dart
//Primero creamos el notifier. Puede ser una variable o incluso una clase que encapsule varios métodos. Esta es la forma más sencilla
final contador = ValueNotifier<int>(0);

class ContadorScreen extends StatelessWidget {
  const ContadorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Este Widget es el que escuchará al Notifier.
        ValueListenableBuilder<int>(
            //indicamos el Notifier al que escucha
          valueListenable: contador,
          //Construimos el widget que queremos que reaccione al cambio de forma normal
          builder: (context, value, child) {
            return Text("Contador: $value");
          },
        ),
        //Los widgets que efectúan el cambio, pero no reaccionan a él, no necesitan estar en el Listenable.
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => contador.value++,
              child: Icon(Icons.add),
            ),
            ElevatedButton(
              onPressed: ()=> contador.value--, 
              child: Icon(Icons.remove)
              )
          ],
        ),
      ],
    );
  }
}
```

`ValueNotifier` es simple, pero efectivo. Sin embargo, tiene muchas limitaciones que lo hacen menos conveniente cuando la complejidad del estado a manejar crece. Para ello, existen otras herramientas como Riverpod.

> **ACTIVIDAD:** Crea una aplicación con 2 pantallas. En todas ellas se ve un nombre, pero el nombre solo se edita en la segunda pantalla, con un TextField. Usa ValueNotifier.

## 3. Riverpod

Riverpod es una librería de manejo de estados, en la cual usamos providers para exponer datos, servicios o lógica, y los consumimos de forma reactiva desde la interfaz de usuario.

Para instalar Riverpod necesitamos añadirlo al proyecto:
```shell
flutter pub add fluter_riverpod
```

Además, si queremos trabajar con anotaciones tenemos que añadir las siguientes librerías:

```shell
flutter pub add riverpod_annotation
flutter pub add --dev riverpod_generator build_runner
```

### 3.1 Trabajar con Providers, Notifiers y Consumers

> **ACTIVIDAD:**

### 3.2 Providers y datos asíncronos

> **ACTIVIDAD:**

## 4. Persistencia

### 4.1 Uso de shared_preferences

### 4.2 Uso de flutter_secure_storage

## 5. Bases de datos locales con Drift

## 6. Drift, repositorios y Riverpod

## 7. Bases de datos en la nube con Supabase