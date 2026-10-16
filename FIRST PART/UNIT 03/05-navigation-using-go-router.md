## 3. Navigator 2

### Introduction to Navigator 2

With Navigator 2, Flutter introduces a more declarative way to describe navigation. Instead of manually pushing and popping, we can build a list of `Page` objects based on the app's current state.

The official documentation summarizes it like this: when an app has advanced navigation requirements, such as deep links, web URLs, or multiple Navigators, it is advisable to use the `Router` or a routing library built on top of this model. In Flutter's case, the practical recommendation is to use packages like `go_router` to manage this model more agilely: [Navigation and routing](https://docs.flutter.dev/ui/navigation).

### Paradigm Shift

In Navigator 1, we use an imperative paradigm with things like:

```dart
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => DetallScreen(id: id)),
);

```

With Navigator 2, we think more declaratively and do:

```dart
Navigator(
  pages: [
    const MaterialPage(child: LlistaScreen()),
    if (idSeleccionat != null)
      MaterialPage(child: DetallScreen(id: idSeleccionat!)),
  ],
  onDidRemovePage: (page) {
    idSeleccionat = null;
  },
);

```

With this example, the interface depends on the state: If `idSeleccionat` is null, only the `LlistaScreen()` screen is shown, but if it has a value, the stack will contain that `LlistaScreen` plus the detail screen (`DetallScreen`) corresponding to the selected ID.

### Recent API Change

In recent versions of Flutter, `Navigator.onPopPage` has been replaced by `onDidRemovePage` in Page-based APIs. You can see this in the official migration guide: [Navigator's page APIs breaking change](https://www.google.com/search?q=https://docs.flutter.dev/release/breaking-changes/pages-api).

### Complete Example

Let's look at a minimal example of declarative navigation with `Navigator.pages`, which will help us understand the concepts before stepping up to libraries like GoRouter.

### Using External Libraries

With Navigator 2, we make navigation declarative, depending on the general state to display one screen or another.

However, in more complex real-world apps, we often need to:

* Convert URLs into navigation state,
* Synchronize the address bar on the web,
* Manage routes with parameters,
* Perform redirects,
* Maintain a common structure with `AppBar`, `NavigationBar`, or side menus,
* Control error screens when a route does not exist.

All of this can be done manually, but it is quite a lot of work. That is why external libraries like GoRouter are frequently used, providing a high-level API on top of Navigator 2.

---

## 4. Navigation with GoRouter

### Go Router

The `go_router` package is maintained by Flutter's own developers (`flutter.dev`), although it is provided as an external library separate from the core framework.

Go Router builds a declarative routing API on top of Flutter's `Router`. According to its documentation, it allows you to define URL patterns, navigate using URLs, handle deep links, parameters, redirects, and multi-Navigator structures. The version currently published on pub.dev is the 17.x series: [go_router on pub.dev](https://pub.dev/packages/go_router).

### But what is the Flutter Router?

The Router is the piece of the framework that allows navigation to be managed declaratively and synchronized with a location or route.

With Navigator 1, we typically navigate imperatively using `push` and `pop`. With the Router-based model, on the other hand, the app describes what navigation state it should have based on a route, a URL, or internal state.

This model is especially useful for the web, deep links, routes with parameters, and more complex navigation structures. The problem is that using Flutter's Router directly can be quite verbose. That is why we use `go_router`, which gives us a simpler API over this same system.

The approach with Go Router is that we stop configuring `home` and start configuring `routerConfig`. That is, instead of initializing the app with:

```dart
MaterialApp(
  home: Navigator(...)
)

```

We move to doing:

```dart
MaterialApp.router(
  routerConfig: appRouter,
);

```

### Package Installation

To install `go_router`, we simply run the command:

```bash
flutter pub add go_router

```

This will add the following dependency (or similar, depending on the current version) to your `pubspec.yaml`:

```yaml
dependencies:
  ...
  go_router: ^17.2.3

```

And it will install the package.

### Basic Configuration

A minimal configuration with Go Router looks like this:

```dart
// Declare the router
final GoRouter router = GoRouter(
  // Define the initial route
  initialLocation: '/',
  // Define the list of routes
  routes: [
    GoRoute(
      // Path
      path: '/',
      // Screen
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/detall/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetallScreen(id: id);
      },
    ),
  ],
);

```

With this scheme, navigation is performed like this:

```dart
context.go('/detall/ENT01');

```

or alternatively:

```dart
context.push('/detall/ENT01');

```

### "go or push?"

As we can see, we can use both `go` and `push`. There are important nuances between these two navigation methods:

* With `context.go('/route')`, we change the current location. This is the most appropriate mechanism for main tabs, app sections, or routes representing a complete state.
* With `context.push('/route')`, we add a new screen on top of the current one. This mechanism is more appropriate for details, auxiliary forms, or flows that we want to be able to close by navigating backward.

### Complete Example

Let's look at a more complete example with two screens, similar to what we have in the Healthy's app:

As we can see, this is a simple navigation with two main sections (Starters and Mains) and a product detail screen. Let's look at the most important details.

* **Centralized route definition:** Navigation is no longer scattered across the entire app with different calls to `Navigator.push`; instead, we define the routes in a single place:

```dart
final GoRouter router = GoRouter(
  initialLocation: '/entrants',
  routes: [
    // Route declarations for:
    //   - /entrants
    //   - /principals
    //   - /producte/:id
  ],
);

```

* We define the different routes using `GoRoute`, associating a path with the screen to be built:

```dart
GoRoute(
  path: '/entrants',
  builder: (context, state) => const ProductesScreen(seccio: 'Entrants'),
)

```

This makes navigation more declarative: we describe what routes exist and which widget corresponds to each.

* **`MaterialApp.router`:** Now, instead of starting the app with `home`, we do it with `MaterialApp.router`:

```dart
MaterialApp.router(
  routerConfig: router,
);

```

Indicating that the app's navigation will no longer depend on a fixed initial screen, but rather on the router configuration.

* **Navigation state and stateless widgets:**
An important change compared to Navigator 1 is that part of the state we previously managed manually is now represented by the current route.

In an implementation with Navigator and a `NavigationBar`, it was common to have a `StatefulWidget` with a variable like:

```dart
int indexActual = 0;

```

And then decide what content to display based on that index. For example, if `indexActual` was 0, we showed starters; if it was 1, we showed mains.

In contrast, in this example, `ProductesScreen` is a `StatelessWidget`:

```dart
class ProductesScreen extends StatelessWidget {
  const ProductesScreen({super.key, required this.seccio});
  final String seccio;
  ...
}

```

We don't need to store internally which tab is selected because this information is already determined by the route:

* `/entrants` shows the starters section
* `/principals` shows the mains section

Therefore, we can calculate the selected index of the `NavigationBar` from the current section:

```dart
selectedIndex: seccio == 'Entrants' ? 0 : 1,

```

Thus, the navigation state ceases to be duplicated in a local variable and becomes represented by the router.

* **The route as state:**
With `go_router`, the current route is part of the app's state. If we are at `/entrants`, the app knows it must display the starters screen. If we are at `/principals`, it will display the mains screen.

This is especially useful on the web because the URL can directly represent where we are in the application.

* **Routes with parameters:**
The detail route is defined with a parameter:

```dart
path: '/producte/:id',

```

The colon indicates that `id` is a variable part of the path. For example, these two URLs match the same route:

* `/producte/ENT01`
* `/producte/PRI02`

Inside the builder, we can retrieve this value using `state.pathParameters`:

```dart
final id = state.pathParameters['id']!;

```

This allows us to build a different detail screen depending on the selected product.

* **`go`, `push`, and `pop`:**
In the navigation bar, we use `context.go`:

```dart
context.go('/entrants');
context.go('/principals');

```

This changes the app's current location. It is suitable for main sections because we do not want to stack one tab on top of another.

On the other hand, when we open a product detail, we use `context.push`:

```dart
context.push('/producte/$id');

```

This adds a new route on top of the current one, much like `Navigator.push`. This is why we can later return using:

```dart
context.pop();

```

### ShellRoute

When we have multiple routes that share a structure—such as an `AppBar` and a `NavigationBar`—`go_router` allows us to extract this structure and specify it directly in the Router by using `ShellRoute` routes.

Thus, instead of defining:

```dart
final GoRouter router = GoRouter(
  initialLocation: '/ruta1',
  routes: [
    // Route 1, to a view with Scaffold containing AppBar and NavigationBar
    GoRoute(
      path: '/ruta1',
      builder: (context, state) => const Pantalla1(),
    ),
    // Route /ruta2, to another view with the same Scaffold with AppBar and NavigationBar
    // Route /ruta3, to another view with the same Scaffold with AppBar and NavigationBar
    // Route /ruta4, to a view with a different structure
  ],
);

```

Where we have `/ruta1`, `/ruta2`, and `/ruta3` with the same structure, and `/ruta4` with a different structure, what we do is define:

```dart
final GoRouter router = GoRouter(
  initialLocation: '/ruta1',
  routes: [
    // We define a ShellRoute, which groups several views with a common structure
    ShellRoute(
      // The builder receives as 'child' the widget built by the child route
      builder: (context, state, child) {
        final indexActual = switch (state.uri.path) {
          '/ruta2' => 1,
          '/ruta3' => 2,
          _ => 0,
        };
        // Define the common structure for all routes
        return Scaffold(
          appBar: AppBar(title: const Text('App')),
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: indexActual,
            onDestinationSelected: (index) {
              switch (index) {
                case 1:
                  context.go('/ruta2');
                  break;
                case 2:
                  context.go('/ruta3');
                  break;
                default:
                  context.go('/ruta1');
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                label: 'Route 1',
              ),
              NavigationDestination(
                icon: Icon(Icons.list_outlined),
                label: 'Route 2',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                label: 'Route 3',
              ),
            ],
          ),
        );
      },
      // Define the different routes inside the Shell
      routes: [
        GoRoute(
          path: '/ruta1',
          builder: (context, state) => const Pantalla1(),
        ),
        GoRoute(
          path: '/ruta2',
          builder: (context, state) => const Pantalla2(),
        ),
        GoRoute(
          path: '/ruta3',
          builder: (context, state) => const Pantalla3(),
        ),
      ],
    ),
    // This route stays outside the ShellRoute because it has a different structure.
    GoRoute(
      path: '/ruta4',
      builder: (context, state) => const Pantalla4(),
    ),
  ],
);

```

In this way, the common structure that existed in `Pantalla1`, `Pantalla2`, and `Pantalla3` is defined directly within the `ShellRoute`.

### The `child` Parameter

Notice that the `ShellRoute` builder receives a `child` argument, which is the widget built by the child route, and which we will generally use as the `body` of the `Scaffold`.

```dart
ShellRoute(
  builder: (context, state, child) {
    return Scaffold(
      appBar: AppBar(title: const Text('App')),
      body: child,
      bottomNavigationBar: const NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Route 1',
          ),
        ],
      ),
    );
  },
  routes: [
    // Child routes
  ],
);

```

Let's look at the example from the previous section with two screens and the detail view via `ShellRoute`:

---

## 5. Hero Animations

### What are Hero Animations?

A Hero animation allows a widget to appear to fly from one screen to another during navigation. It is very common in list-and-detail screens: we see an image on a card, tap it, and that same image grows to occupy the header of the detail screen.

The official documentation explains that Hero implements a shared element transition: we define a Hero in the source route and another in the destination route, both with the same tag, and Flutter animates the position and size change during the route transition. You can check the details at [Hero animations](https://docs.flutter.dev/ui/animations/hero-animations).

### Basic Structure

As mentioned, this type of animation requires a Hero on the source route and another on the destination route.

On the source screen, we define:

```dart
Hero(
  // Define the tag
  tag: 'producte-ENT01',
  // Define the image to display
  child: Image.network(url),
)

```

And on the destination screen:

```dart
// This is not an error, it is exact same!!!
Hero(
  tag: 'producte-ENT01',
  child: Image.network(url),
)

```

This tag must be unique within the same route. If a list of items, for example, contains several products, we could build the tag using the product identifier:

```dart
tag: 'producte-${producte.id}'

```

Let's look at a complete example with Hero animations between cards and their detail screen:

### Things to Keep in Mind

Some details we should keep in mind with Hero animations are:

* The tag must be stable and unique.
* The source and destination widgets should have a compatible visual structure (image with image, container with container...).
* Hero works both when a route transition is managed by the Navigator and when it is managed by `go_router`.
* If the content comes from a list of items containing identifiers, the best option is usually to generate the tag from that identifier.