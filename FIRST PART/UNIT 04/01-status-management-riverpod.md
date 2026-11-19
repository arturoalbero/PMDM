# 2. Local State and Notifiers

## The Problem of Shared State

In Flutter, we have already worked with local state using `StatefulWidget` and `setState`. This mechanism is still very useful when the state clearly belongs to a specific widget: a form field, an animation, a selected tab, or a temporary value.

The problem arises when data needs to be read or modified from different screens.

For example, we can think of the name of the authenticated user in an application. The login screen may collect this name, but the data may also be needed in other parts of the application, such as the `AppBar`, a profile screen, an activity summary, the shopping cart, or, in general, any component that needs to personalize the user experience.

If we store this name in the local state of `LoginForm`, the rest of the application cannot access it. If we move it up to `MainScreen`, we start passing callbacks and parameters to widgets that perhaps should not need to know anything about the login process.

**Lifting State Up**

When two widgets need to share data, a common initial solution is to lift the state up to their closest common parent.

This technique works well in small widget trees. However, if the state needs to pass through many layers or be consumed by independent screens, the code becomes more rigid and harder to maintain.

## Different Ways of Managing State

Flutter does not impose a single way of managing state. In fact, an important part of learning Flutter is knowing how to choose a tool that is *proportional* to the problem.

Some common options are:

- [`setState`](https://api.flutter.dev/flutter/widgets/State/setState.html), for local state that is very close to the widget.
- [`ValueNotifier`](https://api.flutter.dev/flutter/foundation/ValueNotifier-class.html) and [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html), for encapsulating simple changes and notifying the interface.
- [`Provider`](https://pub.dev/packages/provider), which makes it easier to share objects and notifiers throughout the widget tree.
- [`BLoC`](https://pub.dev/packages/bloc) or [`Cubit`](https://pub.dev/packages/cubit), which model state using events and streams. They are particularly useful in large applications or those with complex business rules.
- [`Riverpod`](https://pub.dev/packages/riverpod), which is based on the concept of providers but avoids directly depending on `BuildContext` and offers more composable, testable, and clear management of synchronous and asynchronous states.

**There Is No Single Correct Answer**

We are not going to claim that Riverpod is the only correct option. Different state management solutions coexist in Flutter, and all of them can be appropriate depending on the context.

In this unit, we will use **Riverpod** because it allows us to work clearly with shared state, dependencies, asynchronous data, and states that need to be visible from multiple screens.

## A First Approach: ValueNotifier

Before moving directly to *Riverpod*, let's see how to solve the user name example using a simple notifier.

**ValueNotifier**

The `ValueNotifier<T>` class is part of Flutter and **allows us to store a value that *notifies* the widgets listening to it whenever it changes**. The `<T>` represents the type of value we store.

Notifiers will therefore be responsible for maintaining the interface state and notifying the views when changes occur. Consequently, **they belong to the presentation layer**.

We will therefore create the file `lib/presentation/notifiers/user_notifier.dart`, containing the *ValueNotifier* that stores the user's name. Its contents will be as follows:

```dart
import 'package:flutter/foundation.dart';

// The UserSession class is responsible for storing the state
// and is initialized with its text value.
class UserSession {
  const UserSession({required this.name});

  final String name; // State => user's name
}

// IMPORTANT! Define the notifier for this class.
final userSessionNotifier = ValueNotifier<UserSession?>(null);
```

The initial value of this *notifier* is `null`, since the user has not logged in yet.

When the login form is validated, we can update the notifier with:

```dart
void submit() {
  // Validate the form.
  if (!_formKey.currentState!.validate()) return;

  // Access the value of the notifier.
  userSessionNotifier.value = UserSession(
    name: _nameController.text.trim(),
  );
}
```

**Let's Think About This for a Moment... Why Don't We Use a Global Class to Store All the Shared Values in the Application?**

If we use a standard global class (for example, with static variables or a classic *Singleton*), we can store and modify data from anywhere, but the user interface (UI) **will not be notified of these changes**.

A regular variable does not have the ability to notify anyone when its contents change. As a result, the screen would remain *frozen* with the old data until a manual rebuild was triggered.

By contrast, when we use a **Notifier** (such as `ValueNotifier` or `StateNotifier`), we make this data **reactive**. The *Notifier* does not simply store the value; it acts like a loudspeaker: every time we modify its `.value` property, it automatically sends a notification to all the widgets listening to it so that they can immediately rebuild using the updated information.

This behavior corresponds to the **Observer** pattern, which you can explore in more detail [on the Refactoring Guru website (highly recommended!)](https://refactoring.guru/es/design-patterns/observer).

**Accessing the Value**

To access the value stored by a **`Notifier`**, we must use its `value` property, which gives us access to the object it stores.

For example, to assign a specific username directly to the `UserSession` object:

```dart
userSessionNotifier.value = UserSession(name: 'New Name');
```

To clear the session and leave the username empty, we simply set it back to `null`:

```dart
userSessionNotifier.value = null;
```

And to access the current value when needed, we would write:

```dart
String? currentName = userSessionNotifier.value?.name;
```

But how would we listen for changes inside a widget? We need the [`ValueListenableBuilder`](https://api.flutter.dev/flutter/widgets/ValueListenableBuilder-class.html) widget, which keeps itself synchronized with a specific *Notifier*. Let's see how to use it:

```dart
// Define the widget.
ValueListenableBuilder<UserSession?>(
  // Specify the object to observe.
  valueListenable: userSessionNotifier,

  // Define the method used to build the widget.
  // The second parameter (session) is a reference to the observed object.
  builder: (context, session, child) {
    if (session == null) {
      return const Text('Account');
    }

    return Text('Hello, ${session.name}');
  },
)
```

As we can see, with this mechanism the interface does not constantly check whether something has changed. Instead, **it subscribes to changes**, and Flutter rebuilds the corresponding part of the interface whenever the value changes.

You can see [a complete example at the following link, using GoRouter to manage the routes](https://dartpad.dev/?id=314caf7f96c50c36cdbc1e330c6a0db2).

[iframe](https://dartpad.dev/embed-dart.html?id=314caf7f96c50c36cdbc1e330c6a0db2)

## Limitations of This Approach

`ValueNotifier` is simple and effective, but as the application grows, certain limitations become apparent. For example, it does not provide a clear structure for combining states, it does not offer particularly good integration with asynchronous states, and the initialization and lifecycle of notifiers remain our responsibility, among other things.

The username is a small example. Other shared states may involve more complex logic, such as an item selection, a list of favorites, a long form, or a shopping cart. These may involve operations such as adding and removing items, performing calculations, or updating widgets across different screens.

This is precisely why more comprehensive state management solutions, such as *Riverpod*, exist.

## From Simple Notifiers to Riverpod

Riverpod retains the same basic idea: we have an object that *exposes* a state, and widgets that observe it.

The difference is that Riverpod provides an organized layer of **providers**, which are responsible for creating, exposing, listening to, and disposing of state or dependencies in a controlled way.

When working with Riverpod, we will follow the same procedure as with the previous notifier:

1. Define the state we want to share.
2. Create a notifier that modifies it.
3. Expose this notifier through a provider.
4. Consume the provider from the interface.

The difference is that Riverpod now gives us the tools to do this in a scalable way.

# 3. Riverpod

## What is Riverpod?

Riverpod is a state management library for Dart and Flutter created by Remi Rousselet (Dash Overflow), the same author of Provider, another state management library. In fact, Riverpod is an anagram of Provider and represents an evolution of it.

The central idea remains the same: we define classes (providers) that expose data, services, or logic, and consume them reactively from the user interface.

Riverpod avoids some of the limitations of native widgets such as InheritedWidget and libraries such as Provider. It offers the following advantages over them:

- Providers do not depend directly on the build context (BuildContext), which makes the library independent of Flutter and allows it to be used in pure Dart applications.
- Different providers can be combined easily.
- They can be tested without having to build the entire user interface.
- Common errors are detected earlier and with more useful information.
- It provides abstractions that improve the management of states that depend on asynchronous information.

Although Riverpod includes different types of providers, its official documentation recommends NotifierProvider and AsyncNotifierProvider for managing modifiable and asynchronous states, respectively. As of May 2026, the flutter_riverpod library is in the 3.x series.

## Riverpod packages

In our case, we will work with the flutter_riverpod library, which integrates Riverpod with Flutter widgets.

There are also riverpod, for pure Dart applications, and hooks_riverpod, which combines Riverpod with flutter_hooks, a StatefulWidget alternative based on hooks and inspired by React.

## Installation

To add Riverpod to the project:

```bash
flutter pub add flutter_riverpod
```

Riverpod also provides an annotation-based syntax (@riverpod) and code generation with build_runner.

To work with annotations, we would need to add the following libraries:

```bash
flutter pub add riverpod_annotation
flutter pub add --dev riverpod_generator build_runner
```

riverpod_annotation contains the annotations for Riverpod, which simplify lengthy syntax by replacing it with shorter annotations.

build_runner is the code generation engine, a command-line tool that allows us to generate code during development from annotations. When we run the build_runner command, the different annotations are read and auxiliary files (with the .g.dart extension) containing the generated code are created.

However, in this unit we will mainly work without annotations and manually define providers using Provider, NotifierProvider, and AsyncNotifierProvider, so that we can better understand how state management works.

## ProviderScope

Let's now look at how to use the library. To use Riverpod in a Flutter application, we need to wrap the application with the ProviderScope class.

Previously, our application might have looked like this:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}
```

Now we wrap the application with ProviderScope as follows:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

ProviderScope creates a container where Riverpod stores the different provider states. This is why it must be placed at the root of the application.

## ProviderScope and ProviderContainer

The relationship between runApp, ProviderScope, the widget tree, and the internal container can also be seen in the following diagram:

*ProviderScope diagram*

## A read-only provider

Let's start with the simplest type of provider: one that exposes a value that does not change.

```dart
// We define a Provider that stores a String.
// Notice that the Provider constructor receives a
// function as an argument. This function has a ref
// parameter and simply returns the text `Counter`.
final appNameProvider = Provider<String>((ref) {
  return 'Counter';
});
```

By convention, provider names end with the Provider suffix.

To read provider values from a widget, we need to use ConsumerWidget.

## ConsumerWidget

A ConsumerWidget is a special type of Riverpod widget that replaces traditional StatelessWidget widgets and is specifically designed to read providers and react to their changes.

Let's see how to use it:

```dart
class AppTitle extends ConsumerWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appName = ref.watch(appNameProvider);

    return Text(appName);
  }
}
```

The main difference compared with a StatelessWidget is that the build method also receives a WidgetRef ref parameter. This reference allows us to access providers.

Notice that we access the appNameProvider Provider through this reference and the watch method, which reads the value of the specified provider and subscribes to its changes.

## NotifierProvider

As we have seen, the Provider class stores a read-only value. However, when the state can change, we will use a Notifier.

## Notifier

A Notifier class (introduced in Riverpod 2.0) is a state manager responsible for storing application data and encapsulating all the logic required to modify it.

As an example, let's see how we could implement a counter using this mechanism:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We define the CounterNotifier class, which will be
// a Notifier that stores an integer.
class CounterNotifier extends Notifier<int> {

  // Initial state
  @override
  int build() {
    return 0;
  }

  // Increment, decrement, and reset methods
  void increment() {
    state++;
  }

  void decrement() {
    state--;
  }

  void reset() {
    state = 0;
  }
}

// We define the Provider for this Notifier.
final counterProvider = NotifierProvider<CounterNotifier, int>(
  CounterNotifier.new,
);
```

Let's look at some details:

Notice that we have not defined a counter variable as such. Instead, we define CounterNotifier as a Notifier that stores an integer value.

The build() method defines the initial state. In this case, the counter starts at 0.

We have the increment(), decrement(), and reset() methods, which operate on the internal state variable that represents this integer value.

Finally, we define counterProvider, a global variable that we will use on screens to access this state manager. It is defined as a NotifierProvider.

This NotifierProvider is parameterized with the type of Notifier (CounterNotifier) and the type of data it stores (int).

In addition, the NotifierProvider constructor receives the CounterNotifier.new constructor as an argument, so that the class can be instantiated automatically when the UI needs it.

## CounterNotifier.new

The CounterNotifier.new syntax is a modern and simplified way in Dart to refer to a class constructor. It is equivalent to:

```dart
() => CounterNotifier()
```

## Displaying the Notifier value

To display the value of this Notifier in the user interface, we would write:

```dart
// We create the ConsumerWidget:
class CounterText extends ConsumerWidget {
  const CounterText({super.key});

  // The build method receives the ref parameter to access providers.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We observe the counter value.
    final count = ref.watch(counterProvider);

    // We return the text containing the counter.
    return Text('Counter: $count');
  }
}
```

If we want to modify the state from a button or a form, we will use the read method of the ref reference to access the internal Notifier directly and use its methods.

```dart
ref.read(counterProvider.notifier).increment();
```

We can see the complete Riverpod counter in the following code.

## Consumer

In the previous examples, we used ConsumerWidget to access the state of providers.

However, we will not always need to convert an entire widget into a ConsumerWidget. If only a small part of the user interface needs to observe a provider, we can use the Consumer widget. Let's see how to do this in an AppBar:

```dart
AppBar(
  title: Consumer(
    builder: (context, ref, child) {
      final count = ref.watch(counterProvider);
      return Text('Counter: $count');
    },
  ),
)
```

This allows us to restrict the widgets that will be rebuilt when the provider changes.

## ConsumerStatefulWidget

On the other hand, when we need local widget state and, at the same time, access to Riverpod, we can use ConsumerStatefulWidget.

For example, we might have a form with a local TextEditingController and store the validated value in a provider:

```dart
// We define the Notifier that stores a String.

class UserNameNotifier extends Notifier<String> {
  @override
  String build() => '';

  void changeName(String name) {
    state = name;
  }
}

final userNameProvider = NotifierProvider<UserNameNotifier, String>(
  UserNameNotifier.new,
);

// We define the widget that consumes it.

class NameForm extends ConsumerStatefulWidget {
  const NameForm({super.key});

  // Just as StatefulWidget has a State, 
  // ConsumerStatefulWidget has a ConsumerState:
  @override
  ConsumerState<NameForm> createState() => _NameFormState();
}

// State class that depends on a Consumer.

// Important: This ConsumerState class already includes
// the ref reference as a property, so we do not need
// to provide it in the build method.
// Our state class therefore inherits this ref reference
// directly from ConsumerState.

class _NameFormState extends ConsumerState<NameForm> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        // We use the ref property directly,
        // inherited from ConsumerState.
        ref
            .read(userNameProvider.notifier)
            .changeName(_nameController.text.trim());
      },
      child: const Text('Save'),
    );
  }
}
```

This form therefore continues to have local state for its controllers, but the value that matters to the rest of the application is stored in a provider.

# 4. Providers and Asynchronous Data

## Riverpod within the application architecture

Riverpod is not only used to store the state of a screen or an application. It can also provide the objects we need to retrieve data, such as repositories, services, or use cases.

In previous units, we have worked with an approach to the architecture recommended by Flutter, organized into three layers:

- The **UI layer**, which displays data and receives user actions.
- The **Data layer**, which retrieves and transforms data through repositories and services.
- The **Domain layer**, which contains the concepts specific to the problem the application solves, such as the Product, Starter, Main Course, or Drink entities.

The Flutter guide suggests that, when an application includes logic that would be too complex for the UI layer, this logic can be separated into use cases. In our project, we already use the domain layer to locate the application's entities. From now on, we can extend this layer with use cases whenever a feature requires them.

In our project, we can represent this organization as follows:

```text
lib/
  data/
    repositories/
    services/
  domain/
    entities/
    usecases/        # When use cases are needed
  ui/
    providers/
    screens/
    widgets/
```

## Other naming conventions

In other architectural approaches, such as CLEAN Architecture, we may find different names for layers with similar responsibilities:

- The ui layer is also commonly called presentation.
- The data layer may also be referred to as infrastructure.

In this unit, we will keep the names ui and data, which are the ones we have already used in the course application.

The user interface should not need to know how an HTTP request is made or how JSON is converted into a Dart object. A screen should request the data it needs, while repositories, services, and, when necessary, use cases are responsible for retrieving and preparing that data.

## Views and view models

Until now, we have used screens that, in addition to displaying widgets, could also retrieve data and manage part of their state. As an application grows, it becomes useful to separate these responsibilities.

In the architecture recommended by Flutter, we distinguish two types of components within the UI layer:

- **Views** are the widgets that draw the user interface and collect user actions.
- **View models** maintain the state required by the view and execute the actions associated with it.

## What is a view model?

A view model is an architectural concept: it represents the component that prepares and manages the information required by a view, independently of the library used to implement it.

For example, a screen displaying a list of products needs to know whether the list is being loaded, whether an error has occurred, or which products have been retrieved. The view is responsible for displaying each situation, while the view model maintains this state and initiates the loading or reloading of the data.

In this way, the screen does not need to know the details of the repository or API access.

Riverpod does not define the concept of a view model, but it provides classes that are suitable for implementing one. A Notifier or an AsyncNotifier can fulfil this role: it maintains a state and provides methods that allow the view to interact with it. For example, a CatalogItemsNotifier can load the items in a product catalogue and provide a reload() method to load them again.

However, not all providers are view models. A provider can also simply supply a dependency, such as a repository or a service, without representing the state of a specific view.

The general flow we will use is:

**Simple query**

View  
ConsumerWidget

View model  
AsyncNotifier

Use case  
(optional)

Repository

Service

API

## Providers for dependencies

A dependency is an object that another class needs in order to work. For example, a repository may need a remote service, and a use case may need a repository.

With Riverpod, we can create these objects using providers. This means they are defined in a single place, and other providers can access them through ref.

Let's imagine a generic application that displays the available items in a catalogue. Its data layer has a remote service and a repository:

```dart
// Provider to create the service that accesses a
// remote data source.
final catalogRemoteServiceProvider = Provider<CatalogRemoteService>((ref) {
  return CatalogRemoteService();
});

// Provider to create the repository and provide it with
// the service it needs.
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  // watch retrieves the service defined in the previous provider.
  final remoteService = ref.watch(catalogRemoteServiceProvider);

  return CatalogRepository(remoteService);
});
```

Let's examine this example carefully.

- CatalogRemoteService is a service responsible for communicating with an API.
- CatalogRepository is the repository that requests data from the service and transforms it into application objects, such as CatalogItem.
- catalogRepositoryProvider can construct the repository so that the rest of the application does not have to create it manually.

This mechanism is known as **dependency injection**: a class receives the dependencies (objects) it needs from the outside, rather than creating them internally.

## Providers for use cases

A use case represents an action that the application can perform, such as retrieving the available items, authenticating a user, or calculating an order summary.

Adding use cases is optional because, when operations are simple, a view model can access the repository that provides the data directly. Use cases are especially useful when an action contains business logic, combines several repositories, or needs to be reused in different parts of the application.

We can define a simple use case to retrieve the catalogue as follows:

```dart
class GetAvailableItemsUseCase {
  // The use case receives the repository
  // from which it will retrieve the data.
  const GetAvailableItemsUseCase(this._repository);

  final CatalogRepository _repository;

  // execute represents the action that the UI layer
  // can request (it "executes" the use case).
  Future<List<CatalogItem>> execute() {
    // getAvailableItems is a method of the repository
    // itself, which retrieves the available items.
    return _repository.getAvailableItems();
  }
}
```

And we can provide this use case with Riverpod:

```dart
final getAvailableItemsUseCaseProvider =
    Provider<GetAvailableItemsUseCase>((ref) {
  // Retrieve the repository required by the use case.
  final repository = ref.watch(catalogRepositoryProvider);

  // Build the use case by injecting the repository.
  return GetAvailableItemsUseCase(repository);
});
```

This provider does not download any data yet. It simply constructs the use case and provides it with the repository it needs.

The relationship between the objects we have provided with Riverpod can be represented as follows:

```text
CatalogRemoteService
+getAvailableItems()

        used by

CatalogRepository
-CatalogRemoteService remoteService
+getAvailableItems()

        used by

GetAvailableItemsUseCase
-CatalogRepository repository
+execute()
```

This diagram shows which dependencies each class needs. Later, using a sequence diagram, we will see how these classes interact when the user interface actually initiates the query.

## Why show such a simple use case?

In this example, the use case simply delegates the query to the repository. We include it to understand where this responsibility would be placed as the feature grows.

In features with their own rules, such as a shopping cart, this separation becomes more evident: we may need to add products, modify quantities, remove items, or calculate totals.

## AsyncNotifierProvider for asynchronous data

A query to an API does not return data immediately. While we wait for the result, the user interface must be able to represent three situations: loading, data available, or error (if we remember, these are the possible states of an AsyncSnapshot when a Future is completed).

To manage a state that loads asynchronously, we will use AsyncNotifierProvider. This provider exposes an AsyncValue<T>, which represents precisely these three possible states:

```dart
// We define an asynchronous Notifier that will contain
// a list of catalogue items.
class CatalogItemsNotifier extends AsyncNotifier<List<CatalogItem>> {
  // Remember that the build() method defines the
  // initial state of the Notifier.
  @override
  Future<List<CatalogItem>> build() async {
    // Retrieve the use case that performs the query.
    // (ref is inherited directly from AsyncNotifier).
    final getAvailableItems = ref.watch(getAvailableItemsUseCaseProvider);

    // The initial state of the Provider will therefore
    // be the result of the query.
    return getAvailableItems.execute();
  }

  Future<void> reload() async {
    // Immediately indicate to the view that
    // a new loading operation is starting.
    state = const AsyncLoading();

    // The guard method converts the result
    // into AsyncData and errors into AsyncError.
    state = await AsyncValue.guard(() async {
      // With read, we can use the dependency
      // without subscribing to its changes.
      final getAvailableItems = ref.read(getAvailableItemsUseCaseProvider);
      return getAvailableItems.execute();
    });
  }
}

// This provider exposes the asynchronous state
// and the Notifier's methods.
final catalogItemsProvider =
    AsyncNotifierProvider<CatalogItemsNotifier, List<CatalogItem>>(
  CatalogItemsNotifier.new,
);
```

In this case:

- CatalogItemsNotifier acts as the list's view model.
- The build() method retrieves the initial data when the provider is queried for the first time.
- The state property contains the current asynchronous state.
- The reload() method allows the data to be loaded again.
- AsyncValue.guard() executes the operation and automatically transforms its result into AsyncData or an error into AsyncError.

The internal flow is represented in the following diagram:

```text
View
  |
  | ref.watch(catalogItemsProvider)
  v
CatalogItemsNotifier
  |
  | execute()
  v
GetAvailableItemsUseCase
  |
  | getAvailableItems()
  v
CatalogRepository
  |
  v
CatalogRemoteService
  |
  | Retrieves remote data
  v
API

Response: List<CatalogItem>

The Notifier exposes:
AsyncData(List<CatalogItem>)
```

## Consuming AsyncValue from the view

To connect the view with the data, it observes the provider and decides what to display in each situation.

```dart
class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The view observes its view model's asynchronous state.
    final items = ref.watch(catalogItemsProvider);

    // Display a different widget depending on the
    // current state of the query.
    // For this, we use the when method.
    return items.when(
      data: (items) => CatalogList(items: items),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => const Center(
        child: Text("The data could not be loaded"),
      ),
    );
  }
}
```

This when() method requires us to explicitly handle the three possible states of the query:

- **data**, when the data is available.
- **loading**, while the data is being loaded.
- **error**, when the data could not be retrieved.

If the view includes an action to reload the data, it can invoke the Notifier's method:

```dart
IconButton(
  onPressed: () {
    // Access the Notifier to execute the reload action.
    ref.read(catalogItemsProvider.notifier).reload();
  },
  icon: const Icon(Icons.refresh),
)
```

## Multiple data lists

When an application displays several lists, we can create a provider for each one. This approach is clearer when each list corresponds to a different action or different data.

For example, imagine that we have a catalogue with three lists: new arrivals, favourite items, and archived items. We will assume that we have already created three use cases and their providers, getNewsUseCaseProvider, getFavoritesUseCaseProvider, and getArchivedUseCaseProvider, following the pattern of getAvailableItemsUseCaseProvider that we saw earlier.

We can create an asynchronous view model for each list:

```dart
// This Notifier manages the state of the new arrivals list.
class NewsNotifier extends AsyncNotifier<List<Item>> {
  @override
  Future<List<Item>> build() {
    // The specific use case determines which list is queried.
    final getNews = ref.watch(getNewsUseCaseProvider);
    return getNews.execute();
  }
}

// This provider exposes the new arrivals list to the views.
final newsProvider = AsyncNotifierProvider<NewsNotifier, List<Item>>(
  NewsNotifier.new,
);

// Favourites have their own state and their own use case.
class FavoritesNotifier extends AsyncNotifier<List<Item>> {
  @override
  Future<List<Item>> build() {
    final getFavorites = ref.watch(getFavoritesUseCaseProvider);
    return getFavorites.execute();
  }
}

// Provider to expose the favourites list.
final favoritesProvider =
    AsyncNotifierProvider<FavoritesNotifier, List<Item>>(
  FavoritesNotifier.new,
);

// Archived items form a third independent query.
class ArchivedNotifier extends AsyncNotifier<List<Item>> {
  @override
  Future<List<Item>> build() {
    final getArchived = ref.watch(getArchivedUseCaseProvider);
    return getArchived.execute();
  }
}

// Its corresponding Provider.
final archivedProvider = AsyncNotifierProvider<ArchivedNotifier, List<Item>>(
  ArchivedNotifier.new,
);
```

In this example, Item represents the entity (product type) displayed in the catalogue. Each provider exposes an AsyncValue<List<Item>>, but each Notifier initiates a different query:

- newsProvider executes the use case that retrieves new arrivals.
- favoritesProvider executes the use case that retrieves favourite items.
- archivedProvider executes the use case that retrieves archived items.

The AsyncNotifierProvider<NewsNotifier, List<Item>> definition specifies, on the one hand, the class that manages the state (NewsNotifier) and, on the other, the type of data that the view will receive (List<Item>).

Although the three classes are similar, keeping them separate makes sense if they later provide different actions. For example, favourites might allow an item to be removed from the selection, while archived items might allow it to be restored.

Riverpod also provides family providers, which allow us to obtain variations of the same provider based on a parameter. For example, we could request a list by specifying the corresponding section. This solution can reduce repetition, but we will only use it when the lists genuinely share the same behaviour.

## Applying this to the project

In the course application, we already have a service and a repository for retrieving the products in the menu. In the assignment, we will apply this pattern to one of the product lists, and the remaining lists will be left as an exercise.

With this extension, we will add use cases to the domain layer, which until now contained the application's entities. We will therefore follow Flutter's recommendation to introduce them when they help us separate logic from view models.

## Provider or FutureBuilder?

In previous units, we used FutureBuilder to display asynchronous data. This widget is still valid when data belongs exclusively to one screen and does not need to be shared, updated from other places, or maintained as reusable query state.

With Riverpod, data loading takes place outside the view. The view observes the state provided by its view model, which can reuse repositories, use cases, or other providers.

The difference can be summarized in the following diagram:

**With FutureBuilder:**

```text
View
  |
Future
  |
Data
```

**With Riverpod:**

```text
View
  |
AsyncNotifier
  |
Use case / Repository
  |
Service
  |
Data
```

This separation makes it easier for several screens to share data, for a query to be reloaded, and for the logic associated with the user interface to be tested without depending directly on widgets.

# 5. Complex State Example: Shopping Cart

## The Shopping Cart as Global State

A shopping cart, commonly found in many online stores or home delivery applications such as Healthy's, is a good example of shared state:

- The product detail screen can add or remove products.
- The shopping cart icon must display the total quantity.
- The shopping cart screen must display the order lines.
- The total must be recalculated every time a quantity changes.

If each widget maintained its own local state, the application would no longer be consistent. For this reason, the shopping cart must live in a global provider.

Let's see how we would implement this shopping cart in our application.

## Code Organization

To implement the shopping cart, we will add the new classes to their corresponding layers. The final structure will look like this:

```text
lib/
  domain/
    entities/
      item_carret.dart
      carret.dart
    usecases/
      carret/
        afig_producte_usecase.dart
        elimina_producte_usecase.dart
        buida_carret_usecase.dart
  ui/
    providers/
      carret_provider.dart
```

The entities represent the shopping cart data, the use cases encapsulate the operations we can perform, and the provider maintains the state that the views will observe.

## Domain Entities

The first step is to model the domain layer. A shopping cart line can be represented by the following `ItemCarret` class:

```dart
import 'producte.dart';

class ItemCarret {
  const ItemCarret({
    required this.producte,
    required this.quantitat,
  });

  final Producte producte;
  final int quantitat;

  double get preuTotal => producte.price * quantitat;

  // Creates a new ItemCarret preserving the current values,
  // except for those provided as parameters.
  ItemCarret copyWith({
    Producte? producte,
    int? quantitat,
  }) {
    return ItemCarret(
      producte: producte ?? this.producte,
      quantitat: quantitat ?? this.quantitat,
    );
  }
}
```

Notice that both `producte` and `quantitat` are `final` attributes. Therefore, once an `ItemCarret` has been created, we cannot directly change its quantity. Whenever we need to update a line, we will create a new object.

The `copyWith()` method makes this operation easier: it returns a copy of the current item and replaces only the values we specify. For example:

```dart
final updatedItem = currentItem.copyWith(
  quantitat: currentItem.quantitat + 1,
);
```

In this case, the same product is preserved, but a new line is created with one additional unit. This pattern allows us to work with immutable state, as we will see when managing the complete shopping cart.

The complete shopping cart can be implemented as a list of items with derived information:

```dart
class Carret {
  const Carret({
    this.items = const [],
  });

  final List<ItemCarret> items;

  bool get esBuit => items.isEmpty;

  int get quantitatTotal {
    // The fold method iterates over a list of items and
    // accumulates a result.
    return items.fold(0, (total, item) => total + item.quantitat);
  }

  double get preuTotal {
    return items.fold(0, (total, item) => total + item.preuTotal);
  }

  int quantitatProducte(String producteId) {
    for (final item in items) {
      if (item.producte.id == producteId) {
        return item.quantitat;
      }
    }

    return 0;
  }
}
```

In this code, we encounter a new Dart collection method: `fold`, which iterates over a collection and accumulates a result.

The following fragment:

```dart
int get quantitatTotal {
  return items.fold(0, (total, item) => total + item.quantitat);
}
```

Would be equivalent to the following:

- Start with `total = 0`.
- For each item in the shopping cart:
  - Add `item.quantitat` to `total`.
- Return the final total.

## Immutable State

When modifying the shopping cart, we will not directly modify the existing list. Instead, we will create a new list and return a new `Carret`. This way, Riverpod detects that the state has changed and rebuilds the widgets observing it.

## Use Cases

The shopping cart logic will be encapsulated in use cases.

Let's look at the use case for adding a product:

```dart
class AfigProducteUseCase {
  // We receive references to the shopping cart, the product, and the quantity.
  Carret execute(Carret carret, Producte producte, int quantitat) {
    if (quantitat <= 0) {
      throw ArgumentError('Quantity must be greater than zero');
    }

    // Use the spread operator (...) to create a new list
    // that is a copy of the shopping cart's item list.
    final items = [...carret.items];

    // Find the position of the product.
    final index = items.indexWhere((item) => item.producte.id == producte.id);

    if (index == -1) {
      // If it is not found, add a new item.
      items.add(ItemCarret(producte: producte, quantitat: quantitat));
    } else {
      // If the product is already in the list, create a new
      // shopping cart item with the updated quantity.
      final itemActual = items[index];
      items[index] = itemActual.copyWith(
        quantitat: itemActual.quantitat + quantitat,
      );
    }

    // Return a new shopping cart containing the items.
    return Carret(items: items);
  }
}
```

And the use case for removing a product or reducing its quantity:

```dart
class EliminaProducteUseCase {
  Carret execute(Carret carret, Producte producte, int quantitat) {
    if (quantitat <= 0) {
      throw ArgumentError('Quantity must be greater than zero');
    }

    // Create a new list containing the same elements.
    final items = [...carret.items];

    // Find the element.
    final index = items.indexWhere((item) => item.producte.id == producte.id);

    // If the element is not found, return the same shopping cart.
    if (index == -1) {
      return carret;
    }

    // If the product is found, reduce its quantity.
    final itemActual = items[index];
    final novaQuantitat = itemActual.quantitat - quantitat;

    if (novaQuantitat <= 0) {
      // If the remaining quantity is zero or less,
      // remove the product from the list.
      items.removeAt(index);
    } else {
      // Otherwise, replace the element with
      // a copy containing the modified quantity.
      items[index] = itemActual.copyWith(quantitat: novaQuantitat);
    }

    // Return a new shopping cart with the modified elements.
    return Carret(items: items);
  }
}
```

And the use case for emptying the shopping cart looks like this:

```dart
class BuidaCarretUseCase {
  Carret execute() {
    // Return a new empty shopping cart.
    return const Carret();
  }
}
```

Notice that the use cases do not modify the shopping cart received as a parameter. Each operation returns a new `Carret` object containing the result of the action.

Therefore, when the Notifier assigns this new object to its state, Riverpod can notify the views observing it that a change has occurred.

## CarretNotifier

The notifier orchestrates the use cases and exposes the current shopping cart state:

```dart
class CarretNotifier extends Notifier<Carret> {
  // Private references to the use cases.
  final _afigProducte = AfigProducteUseCase();
  final _eliminaProducte = EliminaProducteUseCase();
  final _buidaCarret = BuidaCarretUseCase();

  // Initial value of the notifier (empty shopping cart).
  @override
  Carret build() {
    return const Carret();
  }

  // Method for adding a product: uses the corresponding use case.
  void afig(Producte producte, int quantitat) {
    state = _afigProducte.execute(state, producte, quantitat);
  }

  // Method for removing a product: uses the corresponding use case.
  void elimina(Producte producte, int quantitat) {
    state = _eliminaProducte.execute(state, producte, quantitat);
  }

  // Method for emptying the shopping cart.
  void buida() {
    state = _buidaCarret.execute();
  }
}

// Create the Notifier.
final carretProvider = NotifierProvider<CarretNotifier, Carret>(
  CarretNotifier.new,
);
```

In a more advanced implementation, the use cases could also be exposed through providers. For this example, instantiating them inside the notifier is sufficient, allowing us to focus on state management.

## Class Diagram

Let's look at a summary diagram showing the relationship between Riverpod, the notifier, the domain entities, and the widgets that consume the shopping cart:

- **ProviderScope**
  - Root widget.
  - `child: Widget`.
  - Contains the provider container.
- **CarretNotifier**
  - Notifier managing the shopping cart state.
  - `AfigProducteUseCase _afigProducte`.
  - `EliminaProducteUseCase _eliminaProducte`.
  - `BuidaCarretUseCase _buidaCarret`.
  - `Carret build()`.
  - `void afig(Producte, int)`.
  - `void elimina(Producte, int)`.
  - `void buida()`.
- **carretProvider**
  - NotifierProvider.
  - `CarretNotifier notifier`.
  - `Carret state`.
- **Carret**
  - Entity.
  - `List<ItemCarret> items`.
  - `int quantitatTotal`.
  - `double preuTotal`.
  - `bool esBuit`.
  - `int quantitatProducte(String)`.
- **ItemCarret**
  - Entity.
  - `Producte producte`.
  - `int quantitat`.
  - `double preuTotal`.
- **AfigProducteUseCase**
  - Use case.
  - `Carret execute(Carret, Producte, int)`.
- **EliminaProducteUseCase**
  - Use case.
  - `Carret execute(Carret, Producte, int)`.
- **BuidaCarretUseCase**
  - Use case.
  - `Carret execute()`.
- **CarretWidget**
  - ConsumerWidget.
  - `build(BuildContext, WidgetRef)`.
- **ProducteDetall**
  - ConsumerWidget.
  - `build(BuildContext, WidgetRef)`.
- **CarretScreen**
  - ConsumerWidget.
  - `build(BuildContext, WidgetRef)`.

The relationships between the components are as follows:

- `ProviderScope` contains the provider container.
- The provider creates an instance of the notifier.
- The notifier manages the state.
- The notifier uses the three use cases.
- The `Carret` entity contains a list of `ItemCarret` objects.
- Each use case returns a new `Carret`.
- The widgets observe the provider using `ref.watch()` and access its methods using `ref.read()`.

## Displaying the Quantity in the Shopping Cart Icon

To create a widget containing the shopping cart icon and displaying the number of products, it will observe the provider.

```dart
class CarretWidget extends ConsumerWidget {
  const CarretWidget({super.key});

  // The build method receives ref.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Observe the shopping cart provider.
    final carret = ref.watch(carretProvider);

    // Return a Badge widget,
    // which displays a label and a child widget,
    // in this case, an icon.
    return Badge(
      label: Text('${carret.quantitatTotal}'),
      isLabelVisible: !carret.esBuit,
      child: IconButton(
        icon: const Icon(Icons.shopping_cart_outlined),
        onPressed: () {
          context.push('/carret');
        },
      ),
    );
  }
}
```

Every time the shopping cart changes, this widget will rebuild and display the current quantity.

## Adding Products from the Product Detail Screen

On the product detail screen, we can retrieve the current quantity of a product using:

```dart
final carret = ref.watch(carretProvider);
final quantitatActual = carret.quantitatProducte(producte.id);
```

And modify it using the notifier:

```dart
ref.read(carretProvider.notifier).afig(producte, 1);
ref.read(carretProvider.notifier).elimina(producte, 1);
```

If the screen previously had local state for `_quantitat`, this state is no longer necessary, since the actual quantity is now stored in the shopping cart.

## Shopping Cart Screen

The shopping cart screen can also be a `ConsumerWidget`:

```dart
class CarretScreen extends ConsumerWidget {
  const CarretScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final carret = ref.watch(carretProvider);

    if (carret.esBuit) {
      return const Center(
        child: Text('The shopping cart is empty'),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: carret.items.length,
            itemBuilder: (context, index) {
              final item = carret.items[index];

              return ListTile(
                title: Text(item.producte.name),
                subtitle: Text('${item.quantitat} units'),
                trailing: Text('${item.preuTotal.toStringAsFixed(2)} €'),
              );
            },
          ),
        ),
        Text('Total: ${carret.preuTotal.toStringAsFixed(2)} €'),
        FilledButton(
          onPressed: () => ref.read(carretProvider.notifier).buida(),
          child: const Text('Empty shopping cart'),
        ),
      ],
    );
  }
}
```

This is where we can see the full potential of Riverpod: the product detail screen, the shopping cart icon, and the summary screen are synchronized without passing callbacks between them.

## Data Flow

When the user adds a product, Riverpod propagates the change to the widgets observing the shopping cart. Let's look at the following data flow:

1. The user presses **"Add"** in `ProducteDetall`.
2. The widget uses `read(carretProvider.notifier)` to access the notifier.
3. `CarretNotifier` executes `afig(producte, 1)`.
4. The notifier calls `AfigProducteUseCase`.
5. The use case executes `execute(state, producte, 1)`.
6. The use case creates a new `Carret`.
7. The new `Carret` is returned to the notifier.
8. The notifier updates its state: `state = nouCarret`.
9. Riverpod detects the change through `ref.watch()`.
10. The observing widgets are rebuilt.
11. `CarretWidget` updates the `Badge` to display the new quantity.

## Let's Practise: The Assignment

At this point, you can complete section 3 of the assignment.

The shopping cart interface will already be prepared in the starter project, and you will need to complete the entities and use cases responsible for managing its state.