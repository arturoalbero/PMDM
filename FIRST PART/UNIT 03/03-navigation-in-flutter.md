# 5.1. Navigation

Applications, whether mobile, web, or desktop, generally use multiple screens or views that users can navigate between and share information across.

In Flutter, the component responsible for facilitating this navigation is the `Navigator` widget. It sits near the top of the widget hierarchy and maintains a stack-based history of the screens that have been visited. These screens are child widgets of the `Navigator`.

As the user navigates through the application's screens, they are stacked on top of one another. The most recently visited screen is at the top of the stack, with older screens underneath. When the user wants to return to the previous screen, we remove the top element from the stack, making the previous screen visible. If the user wants to return to another screen in the history, the navigation history can be rearranged so that the desired screen is brought to the top.

## Routes and Named Routes

In Flutter, the different pages or screens that make up an application and allow navigation between them are known as **routes**.

To navigate between routes, we can use the `Navigator` object and its `push` and `pop` methods to push and remove routes from the stack, or we can use named routes.

### Working with Routes

To push a route onto the stack managed by `Navigator`, thereby opening a new screen, we use the `Navigator.push` method:

```dart
Navigator.push<void>(
  context,
  MaterialPageRoute<void>(
    builder: (BuildContext context) => const PaginaNova(),
  ),
);
```

The first argument is the `context`, which tells Flutter where to place the route. The second argument is an instance of the `MaterialPageRoute` class.

`MaterialPageRoute` defines a navigation route and provides a platform-specific animation for the transition between screens. Its `builder` argument receives a function that builds the widget representing the new route.

Once on the new screen, we can navigate to other routes by pushing them onto the stack, or return to the previous route by removing the current one using the `pop` method:

```dart
Navigator.pop(context);
```

If the route stack contains only one route, calling `Navigator.pop()` removes that route, leaving the application with no view to display. To avoid this, the `Navigator` provides the `canPop()` method, which indicates whether there are additional routes that can safely be removed.

To remove a route safely, we can therefore write:

```dart
if (Navigator.canPop(context)) Navigator.pop(context);
```

A shorter equivalent is `maybePop`, which attempts to remove the current route only when navigation can safely return to a previous one:

```dart
Navigator.maybePop(context);
```

Let's look at an example in which we navigate between three screens using several buttons, following this navigation diagram.

**Navigation diagram for the example**

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // The initial page of MaterialApp
      // is the Pantalla1 widget.
      debugShowCheckedModeBanner: false,
      home: Pantalla1(),
    );
  }
}

// Screen 1: Contains a button to navigate
// to the second screen

class Pantalla1 extends StatelessWidget {
  const Pantalla1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primera Pantalla'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Anar a pantalla 2'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Pantalla2(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Screen 2: Contains a button to return to
// the first screen and another to navigate to the third

class Pantalla2 extends StatelessWidget {
  const Pantalla2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: const Text("Segona Pantalla"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Tornar a Pantalla 1'),
              onPressed: () {
                // Use canPop to avoid leaving the
                // application without a visible screen.
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            ),
            const Divider(height: 100),
            ElevatedButton(
              child: const Text('Anar a Pantalla 3'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Pantalla3(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class Pantalla3 extends StatelessWidget {
  const Pantalla3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text("Pantalla 3"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Tornar a Pantalla 1'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Pantalla1(),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

You can see it in action in the following Gist:

https://dartpad.dev/?id=f0b67cb8fe0faab9943ffd9f843e1bac

### Exploring Navigation

Try the example and observe the appearance of the application bar on the initial screen. Then navigate to the third screen and click the button to return to the first screen.

Look at the application bar again. Do you notice any difference? What do you think might explain it?

## Passing Arguments Between Screens

When navigating from one route to another using `MaterialPageRoute`, we provide a `builder` function that invokes the constructor of the widget representing the new route. This constructor can accept arguments, providing a straightforward way to share information between widgets.

For example, we could define a widget as follows:

```dart
class Pantalla2 extends StatelessWidget {
  final String? nom;

  const Pantalla2({this.nom, super.key});

  ...
}
```

As we can see, we have defined a new property called `nom`, which is initialized through the constructor. The property is declared `final`, allowing us to declare the constructor as `const`.

We can now pass information to this widget from another widget containing a text field. In the following code, we define a stateful widget containing a `TextField` managed by a controller and a button. When pressed, the button sends the text field's value to the second screen.

## Forms and TextFields

As we saw in the previous unit, form widgets allow us to collect user input through text fields, buttons, and selection controls.

The `TextField` widget is the simplest way to enter text. To access or modify its contents from code, we use a `TextEditingController`, which acts as a link between the text field and the widget's code.

This allows us to read or update the field's value when necessary, for example, to send it to another screen or validate it before storing it. As we saw previously, when dealing with multiple fields and validations, it is common to group them inside a `Form`. In this example, however, we will work only with a `TextField` and its controller.

For more information about forms, see the official documentation.

```dart
class Pantalla1 extends StatefulWidget {
  const Pantalla1({super.key});

  @override
  State<Pantalla1> createState() => _Pantalla1State();
}

class _Pantalla1State extends State<Pantalla1> {
  // Define a private controller for the TextField
  final TextEditingController _controlador = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ..
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Com et diuen ?"),
            TextField(
              // Assign the controller to the
              // TextField's controller property
              controller: _controlador,
              ...
            ),
            ElevatedButton(
              child: const Text('Enviar a pantalla 2'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Pantalla2(nom: _controlador.text),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

You can see the complete working example in this Gist:

https://dartpad.dev/?id=b35ef3163b9ffe1de89f8604c2d6d524

## Working with Return Values

Sometimes, in addition to sending data to a widget, we also need to receive a response from it.

To do this, we pass the return value together with the context when removing the route from the stack using `pop`:

```dart
Navigator.pop(context, ValorDeRetorn);
```

This also changes how we receive the information on the screen that becomes the top of the stack. The response is obtained asynchronously, so we call `Navigator.push` using the following pattern:

```dart
String resposta = await Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => Pantalla2(...)),
);
```

The `await` keyword makes us wait for the response. If we want to modify a widget's properties based on that response, we need to use a stateful widget and call `setState()` once the response is available.

Let's look at the following example, which extends the previous one. This time, the first screen will both send data and receive a response.

### Changes to the First Screen

First, we define `Pantalla1` as before, using a stateful widget. Its state contains the text controller and a property for storing the return value (`String _valorDeRetorn`):

```dart
class Pantalla1 extends StatefulWidget {
  const Pantalla1({super.key});

  @override
  State<Pantalla1> createState() => _Pantalla1State();
}

class _Pantalla1State extends State<Pantalla1> {
  // Define a controller for the TextField
  final TextEditingController _controlador = TextEditingController();

  String _valorDeRetorn = "";

  // ...
}
```

We also define the following method inside the screen's state class. It is responsible for navigating to `Pantalla2`:

```dart
_invocarPantalla2(BuildContext context) async {
  String resposta = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => Pantalla2(nom: _controlador.text),
    ),
  );
  setState(() {
    _valorDeRetorn = resposta;
  });
}
```

As we can see, we use the `async` keyword to define the method and `await` to wait for the return value from `Navigator.push()`. Once the response is received, we update the state's `_valorDeRetorn` property using `setState()`.

Finally, to display the return value, we add a text widget that is rendered only if `_valorDeRetorn` contains text other than the empty string:

```dart
Column(
  ...
  children: [
    // We can use declarative conditional rendering
    if (_valorDeRetorn != "") Text("Hola $_valorDeRetorn"),
  ],
),
```

## Flutter's Declarative Model

Flutter allows us to write expressions such as:

```dart
if (_valorDeRetorn != "") Text("Hola $_valorDeRetorn")
```

inside a `children` list thanks to Flutter's **declarative model**. With this model, we do not tell the framework how to modify the interface step by step, as we would with an imperative model. Instead, we describe what we want to display based on the current state.

In this example, when `_valorDeRetorn` changes, Flutter rebuilds the widget and reevaluates what the screen should look like. If the condition is no longer true, the `Text` widget is simply omitted from the declaration and is therefore not rendered.

### Changes to the Second Screen

The second screen will contain a `TextField` for entering the return value. We therefore need a controller, which means converting the widget into a stateful widget.

Remember that the code actions include a **Convert to Stateful** option, which converts a stateless widget into a stateful one. The code from our previous example can therefore serve as a starting point.

The class and its state would look like this:

```dart
class Pantalla2 extends StatefulWidget {
  // Data received from screen 1
  final String? nom;

  // Constructor
  const Pantalla2({this.nom, super.key});

  @override // Create the state
  State<Pantalla2> createState() => _Pantalla2State();
}

// State of screen 2, where we define the controller
class _Pantalla2State extends State<Pantalla2> {
  final TextEditingController _controlador = TextEditingController();

  ...
}
```

Inside the state's `build` method, we include the following code. It defines the button's `onPressed` handler, which calls `pop` and passes the contents of the `TextField` through its controller:

```dart
Column(
  ...
  children: [
    Text("Hola·${widget.nom}, introdueix ara un text de retorn"),
    TextField(
      controller: _controlador,
      ...
    ),
    ElevatedButton(
      child: const Text('Retorna dades'),
      onPressed: () {
        Navigator.pop(context, _controlador.text);
      },
    ),
  ],
)
...
```

### Important: Accessing the Widget from Its State

As you can see, the name received from the first screen is stored in the `nom` property of the `Pantalla2` widget. However, we need to access it from the state's `build` method.

To access a widget's property from its state, we use the state's `widget` property, which references the widget associated with that state. Therefore, to create a `Text` widget whose content includes the `nom` property, we write:

```dart
Text("Hola·${widget.nom}, introdueix ara un text de retorn")
```

In this case, to interpolate the variable, we need curly braces around the full variable expression: `${widget.nom}`.

You can see the complete example in this Gist:

https://dartpad.dev/?id=e00d0a209437630e98997fb52271dff4

## Named Routes

> **Warning**
>
> As stated in the Flutter documentation, the use of named routes is currently discouraged for most applications.

The recommendations are:

- For small and medium-sized applications, use `Navigator` and `MaterialPageRoute`, as we have seen so far.
- For more complex applications, or for web applications, use the Router API (Navigator 2.0) or dedicated routing libraries such as `go_router`.

You can skip this section if you wish and go directly to the next section, which discusses these alternative mechanisms.

For this course, however, we will continue using the `Navigator` API as the basic mechanism for navigating between screens.

Another way to use `Navigator` is through **named routes**, which allow us to reference routes from different parts of the application. When using named routes, we call `pushNamed` instead of `push` to add a new route to the stack.

So far, in our `MaterialApp` applications, we have defined the `title` property and the `home` property, which specifies the widget used as the application's home page.

To define named routes, we add a new property called `routes` to `MaterialApp` and replace `home` with `initialRoute`, which specifies the initial route. The `routes` property is a map associating each route name with an anonymous function that builds its content.

Let's adapt the previous example with three screens to use three named routes:

```dart
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutes',
      initialRoute: '/',
      routes: {
        '/': (context) => const Pantalla1(),
        '/pantalla2': (context) => const Pantalla2(),
        '/pantalla3': (context) => const Pantalla3(),
      },
    );
  }
}
```

As we can see, the `routes` property defines the following routes:

- `/` maps to `Pantalla1` and, as specified by `initialRoute`, is the initial route.
- `/pantalla2` maps to `Pantalla2`.
- `/pantalla3` maps to `Pantalla3`.

To navigate between screens using these names, we use `Navigator.pushNamed` as follows:

```dart
Navigator.pushNamed(context, '/nom_de_la_ruta');
```

Here is the complete example with the three routes and the buttons used to navigate between them:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rutes',
      // Instead of home, define the initial route
      // and the list of named routes.
      initialRoute: '/',
      routes: {
        '/': (context) => const Pantalla1(),
        '/pantalla2': (context) => const Pantalla2(),
        '/pantalla3': (context) => const Pantalla3(),
      },
    );
  }
}

// Screen 1: Contains a button to navigate
// to the second screen

class Pantalla1 extends StatelessWidget {
  const Pantalla1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primera Pantalla'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Anar a pantalla 2'),
              onPressed: () {
                Navigator.pushNamed(context, '/pantalla2');
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Screen 2: Contains a button to return to the first
// screen and another to navigate to the third screen

class Pantalla2 extends StatelessWidget {
  const Pantalla2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: const Text("Segona Pantalla"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Tornar a Pantalla 1'),
              onPressed: () {
                // Use canPop to avoid leaving the
                // application without a visible screen.
                if (Navigator.canPop(context)) Navigator.pop(context);
              },
            ),
            const Divider(height: 100),
            ElevatedButton(
              child: const Text('Anar a Pantalla 3'),
              onPressed: () {
                Navigator.pushNamed(context, '/pantalla3');
              },
            )
          ],
        ),
      ),
    );
  }
}

class Pantalla3 extends StatelessWidget {
  const Pantalla3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        title: const Text("Pantalla 3"),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Tornar a Pantalla 1'),
          onPressed: () {
            Navigator.pushNamed(context, '/');
            // Navigator.pushReplacementNamed(context, '/');
          },
        ),
      ),
    );
  }
}
```

You can see it working here:

https://dartpad.dev/?id=0b1d1ba80eff53981607438c79098a68

### Some Observations

When there is more than one screen on the route stack, and therefore `pop` is possible, an arrow icon appears on the left side of the application bar to navigate backwards.

Some platforms also provide navigation controls integrated into the user interface, such as Android's back button.

In this example, `maybePop` is used instead of combining `canPop` and `pop`.

To remove screens from the stack until we return to the main screen, we use `popUntil` as follows:

```dart
Navigator.popUntil(context, ModalRoute.withName('/'));
```

## Passing Parameters Between Named Routes

When using named routes, we can send information to the destination screen through the `arguments` property of `Navigator.pushNamed()`. To retrieve this information, the destination route can access `ModalRoute.of(context)!.settings.arguments`.

For example:

```dart
// Navigate with parameters
Navigator.pushNamed(
  context,
  '/pantalla2',
  arguments: 'Missatge enviat des de Pantalla1',
);
```

On the second screen, we can retrieve the value as follows:

```dart
class Pantalla2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String missatge =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Pantalla 2')),
      body: Center(child: Text(missatge)),
    );
  }
}
```

For this to work, the application's routes must be defined using the `onGenerateRoute` property, which allows us to receive and handle the arguments:

```dart
MaterialApp(
  initialRoute: '/',
  onGenerateRoute: (settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Pantalla1());
      case '/detall':
        return MaterialPageRoute(
          builder: (_) => const PantallaDetall(),
          settings: settings,
        );
    }
    return null;
  },
);
```

### What Is RouteSettings and What Is It Used For?

`RouteSettings` is a small information container associated with each route we navigate to in Flutter. It contains two main fields:

- `name`: The route's name, such as `/` or `/detall`.
- `arguments`: The data sent to the destination route. This can be any object.

When we navigate using named routes, Flutter internally creates a `RouteSettings` object and passes it to `MaterialApp` through the `onGenerateRoute` parameter. If we create a `MaterialPageRoute` inside that callback, it is good practice to pass along `settings` so that the information reaches the destination screen and can be retrieved using `ModalRoute.of(context)!.settings`.

The typical flow is as follows.

**1. Send data using `pushNamed`.** The data is stored in `RouteSettings.arguments`:

```dart
Navigator.pushNamed(context, '/detall', arguments: 'Hola');
```

**2. Our `onGenerateRoute` receives the settings**, including the route name and arguments:

```dart
onGenerateRoute: (settings) {
  switch (settings.name) {
    case '/detall':
      return MaterialPageRoute(
        builder: (_) => const PantallaDetall(),
        settings: settings, // Pass along the settings
      );
  }
  return null;
}
```

**3. Retrieve the arguments on the destination screen** through `ModalRoute`:

```dart
final String missatge =
    ModalRoute.of(context)!.settings.arguments as String;
```

With this mechanism, we can pass objects, strings, or form data between screens. Combined with `Navigator.pop(context, resultat)`, we can also return information.

The same principle is demonstrated in the following example, where one screen sends the text entered by the user to another screen and receives a response when navigating back:

https://dartpad.dev/?id=44d327f2f4672bd40fd32b706b5132b5

## Router API (Navigator 2.0) and go_router

The classic `Navigator` approach we have seen is ideal for small and medium-sized mobile and desktop applications. As an application grows, especially if it also targets the web, we need greater control over URLs, deep links, navigation history, redirects, and route protection.

This is where the **Router API**, also known as Navigator 2.0, and the `go_router` package come in.

The main characteristic of the Router API is its declarative approach: we describe the list of pages based on the application's state. As mentioned, this mechanism is particularly powerful for web routing, but configuring it manually involves more code.

`go_router`, on the other hand, is an official plugin that simplifies the Router API by providing a more concise way to define routes, deep links, and integrated route guards, along with mechanisms that work with layouts. It is recommended when we want a declarative model without having to use the raw Router API directly, especially in web or hybrid applications.

### Documentation

- The **Navigation and routing** article in the official Flutter documentation.
- The navigation cookbook, also in the Flutter documentation.
- The `go_router` package and its documentation.