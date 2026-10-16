# 2. Asynchronous Operations with FutureBuilder

Nowadays, applications—whether desktop applications, but especially mobile applications—are heavily integrated with the cloud and use multiple Internet services for various purposes, such as retrieving information or managing persistence. Working with the cloud means that applications must be prepared to operate in asynchronous environments, where a response to a request is not immediate.

Modern applications are expected to behave smoothly, without giving users the impression that they are frozen, and to allow interaction while waiting for a response.

This is where widgets that make it possible to handle asynchronous operations come into play. In this section, we will look at one of the most important widgets for creating interfaces that depend on asynchronous data: `FutureBuilder`.

## Asynchronous Operations in Dart: Futures

In the Dart unit, we introduced the `Future` data type. This class represents the result of an asynchronous operation that may complete later, such as a network request or reading a file.

An example of an asynchronous function could be the following:

```dart
Future<String> funcioAsincrona(){
    return Future.delayed(Duration(seconds: 1), (){
        print("Estem en funcioAsincrona");
        return 'Valor de retorn';
    });
}
```

This function returns an object of type `Future` that completes with a `String` after one second. To achieve this, it uses the `Future.delayed` method, which performs certain actions after a pause of the specified duration.

It is important to note that the returned type is a `Future`, so it must be handled appropriately. We have two options:

**1. Set up a callback for when the Future completes**, using the `then` method of this class, as follows:

```dart
Future<String> resposta = funcioAsincrona();
resposta.then((valorResposta) => print("Resposta: $valorResposta"));
```

**2. Make the asynchronous function behave synchronously from the caller's perspective.**

For this, we use the `async`/`await` combination to wait for the asynchronous function to finish and access its result directly. In other words, we can write a function that waits for an asynchronous operation before continuing:

```dart
nomFuncio() async {
    String resposta = await funcioAsincrona();
    print("Resposta: $resposta");
}
```

## The FutureBuilder Widget

When working with asynchronous functions in Flutter, the user interface must respond appropriately to different events and results, ensuring the expected behavior and preventing the interface from becoming unresponsive.

The `FutureBuilder` widget allows us to build part of the interface asynchronously. It is a widget that can rebuild itself in response to an asynchronous event.

If we use the `futureBld` snippet, it generates the following code, in which we can see the widget's main properties:

```dart
FutureBuilder(
  future: Future,
  initialData: InitialData,
  builder: (BuildContext context, AsyncSnapshot snapshot) {
    return ;
  },
),
```

This widget's constructor accepts three named arguments:

- `future`: The `Future` resulting from an asynchronous operation.
- `initialData`: The initial value for the future until it completes.
- `builder`: This is the only required argument. It is an anonymous function that is called to build the widget. The function receives the context and an `AsyncSnapshot` object containing information about the state of the `Future` and its result, if it has completed.

  Among other things, this snapshot contains the `hasData` flag, which indicates whether data is available, and the `data` property, which contains the value returned by the completed future. If an error occurs, the `hasError` flag indicates this, and the `error` property contains the error details.

Let's see how to use this widget to build a user-interface widget based on the result of a previously defined asynchronous function:

```dart
class GinyAsincron extends StatelessWidget {
  const GinyAsincron({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: funcioAsincrona(),
      initialData: "Esperant resposta...",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String text = "";
        if (snapshot.hasData) text = snapshot.data.toString();
        return Text(text);
      },
    );
  }
}
```

As we can see, we have created the `GinyAsincron` class, which builds a `FutureBuilder`. This `FutureBuilder` depends on the previously defined asynchronous function, `funcioAsincrona`.

Until the function completes, the value contained in `snapshot` will be the value assigned to `initialData`. Initially, therefore, the builder creates the widget using that value. When the function's `Future` completes, the snapshot's value changes, updating the state of the `FutureBuilder` and forcing the widget to rebuild with the result.

In this way, the application displays the text **"Esperant resposta..."** and, after a short delay, changes it to **"Valor de retorn"**, which is the value returned by the function.

You can see the complete example in this Gist:

https://dartpad.dev/?id=c6595a08fe6bd74f99bef457173c898c

## Best Practices for FutureBuilder

A widget's `build()` method can execute many times during the application's lifetime.

If we create the `Future` directly inside `build()`, the asynchronous operation may be repeated unintentionally—for example, when the theme changes, a parent widget rebuilds, or the screen rotates.

When the `Future` represents an expensive operation, such as an HTTP request, database access, or file reading, it is recommended to manage it with a `StatefulWidget` and initialize it in `initState()`. This ensures that the operation is executed only once and that the same `Future` is reused during subsequent rebuilds.

We will look at this situation again at the end of this section.

## Progress Indicators

If we do not want to display an initial value while waiting for a response, we can use progress indicators such as `CircularProgressIndicator` or `LinearProgressIndicator`. Let's look at some examples.

For example, a circular progress indicator:

```dart
return FutureBuilder(
  future: funcioAsincrona(),
  builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return Center(child: Text(snapshot.data.toString()));
    }
    return const CircularProgressIndicator();
  },
);
```

In this example, we do not use an initial value. Instead, while the snapshot does not contain data, we return the progress indicator.

This indicator is usually relatively small, so we can use a `SizedBox` widget to wrap it:

```dart
return FutureBuilder(
  future: funcioAsincrona(),
  builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return Center(child: Text(snapshot.data.toString()));
    }
    return const Center(
      child: SizedBox(
        height: 200,
        width: 200,
        child: CircularProgressIndicator(),
      ),
    );
  },
);
```

The `LinearProgressIndicator` widget displays a linear progress indicator instead of a circular one. It is usually placed at the top of the body rather than centered. We can implement it as follows:

```dart
return FutureBuilder(
  future: funcioAsincrona(),
  builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.hasData) {
      return Center(child: Text(snapshot.data.toString()));
    }
    // Linear progress indicator displayed
    // at the top of the body
    return const LinearProgressIndicator();
  },
);
```

You can see both examples in this Gist:

https://dartpad.dev/?id=94020e31698e730523da2ec9b236fb8a

## ConnectionState

The snapshot returned to us contains additional information about the response, such as its state. This state is represented by the `ConnectionState` enumeration, which can have the following values:

- `none`: Indicates that the connection has not started, so `initialData` is used.
- `waiting`: Indicates that the asynchronous operation has started. The snapshot's data may still be null.
- `active`: Indicates that the snapshot contains valid, non-null data that may change over time.
- `done`: Indicates that the snapshot contains data and the operation has completed.

Let's revisit the example, this time checking the state as well:

```dart
class GinyAsincron extends StatelessWidget {
  const GinyAsincron({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // future: null,
      future: funcioAsincrona(), // Comment out this line to test the one above
      initialData: "Valor inicial",
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        String text = "";
        if (snapshot.connectionState == ConnectionState.none) {
          text = "Estat ConnectionState.none.\nData=${snapshot.data.toString()}";
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          text = "Estat ConnectionState.Waiting.\nEsperant resposta...";
        } else if (snapshot.connectionState == ConnectionState.done) {
          text = "Estat ConnectionState.done.\nData=${snapshot.data.toString()}";
        }

        return Center(
          child: Text(text),
        );
      },
    );
  }
}
```

This code displays the `ConnectionState.waiting` state until the response is received. Once the response arrives, it displays the `done` state and the result.

If we replace the future assignment with `future: null`—by uncommenting that line and commenting out `future: funcioAsincrona()`—the displayed state will be `none`, because the connection is never started.

You can try it in the following Gist:

https://dartpad.dev/?id=01078c2d8163205d5195a54f625921a6

## Managing Futures with StatefulWidget

In the previous examples, we saw how to use `FutureBuilder` to build the user interface from the result of an asynchronous operation. However, there is an important detail to keep in mind: a widget's `build()` method can execute many times during the application's lifetime.

Each time `build()` is called, if we pass a direct call to an asynchronous function to the `future` property, a new `Future` is created. This can be problematic in real-world situations.

### When can this be a problem?

Some common situations that cause a widget to rebuild include:

- Theme changes, such as switching between light and dark mode or changing Material 3 settings.
- Calls to `setState()` in a parent widget.
- Changes to `MediaQuery`, such as screen rotation or resizing.
- Rebuilds triggered by animations or other reactive widgets.

If the `Future` represents an expensive operation—an HTTP request, database access, file reading, and so on—this can lead to:

- Unnecessary repeated calls to the same operation.
- Duplicate side effects, such as logs, writes, or requests.
- An inconsistent user experience, such as returning to the loading state.

### Recommended approach

The recommended practice is to create the `Future` only once and reuse it during subsequent rebuilds. To do this, we use a `StatefulWidget` and initialize the `Future` in the `initState()` method.

This way, the `FutureBuilder` always works with the same `Future`, even if the widget rebuilds.

### Example: FutureBuilder with StatefulWidget

```dart
class GinyAsincron extends StatefulWidget {
  const GinyAsincron({super.key});

  @override
  State<GinyAsincron> createState() => _GinyAsincronState();
}

class _GinyAsincronState extends State<GinyAsincron> {
  late final Future<String> _future;

  @override
  void initState() {
    super.initState();
    _future = funcioAsincrona(); // Created only once
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Esperant resposta...");
        }
        if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        }
        return Text(snapshot.data ?? "");
      },
    );
  }
}
```

In this example:

- The `Future` is created in `initState()`, which executes only once for the state object.
- Rebuilding the widget does not trigger the asynchronous operation again.
- The code is more efficient and predictable.

You can view the example in this Gist:

https://dartpad.dev/?id=9c7c099f1a87b5216783777390d69ccf

## Reloading a Future in a Controlled Way

In some cases—for example, when using a refresh button, retrying an operation, or pulling down to refresh—we do want to execute the asynchronous operation again. In that case, we can assign a new `Future` inside `setState()`:

```dart
void _reload() {
  setState(() {
    _future = funcioAsincrona();
  });
}
```

This way, the `FutureBuilder` receives a new `Future` and updates the interface only when we explicitly decide to reload it.

Let's look at an example using the `RefreshIndicator` widget.

## Pull to Refresh with RefreshIndicator

We are going to update the `Future` using the **Pull to Refresh** interaction pattern, which consists of dragging the screen content downward from the top.

As we saw earlier, the `GestureDetector` widget detects low-level gestures. However, implementing this gesture with `GestureDetector` would require us to calculate several parameters manually, such as the direction and distance, and account for specific thresholds. It also has no built-in visual feedback and does not automatically provide behavior consistent with the platform's native conventions.

For this purpose, Flutter provides the `RefreshIndicator` widget, which handles the vertical drag gesture, thresholds, and visual feedback internally.

### Important

The following code does not work on the web with DartPad or locally in Chrome, because the browser's mouse generates scroll events rather than touch gestures.

To try the code, you can use an Android project and perform the system's natural touch gestures, or run it as a desktop application. In the latter case, to refresh, you will need to perform a two-finger swipe gesture on the touchpad.

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

// Define the funcioAsincrona function, which returns
// a Future that resolves to a String after 3 seconds.

Future<String> funcioAsincrona() {
  return Future.delayed(const Duration(seconds: 3), () {
    debugPrint("Estem en funcioAsincrona");
    return 'Valor de retorn';
  });
}

// Main widget
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemple amb FutureBuilder',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Exemple amb FutureBuilder'),
        ),
        body: Center(
          // Since GinyAsincron is now stateful,
          // it can no longer be const.
          child: GinyAsincron(),
        ),
      ),
    );
  }
}

class GinyAsincron extends StatefulWidget {
  const GinyAsincron({super.key});

  @override
  State<GinyAsincron> createState() => _GinyAsincronState();
}

class _GinyAsincronState extends State<GinyAsincron> {
  late Future<String> _future;

  @override
  void initState() {
    super.initState();
    _future = funcioAsincrona();
  }

  Future<void> _reload() async {
    setState(() {
      _future = funcioAsincrona();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 80),
          Center(
            child: FutureBuilder<String>(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }
                return Text(
                  snapshot.data ?? "",
                  style: Theme.of(context).textTheme.headlineSmall,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```
