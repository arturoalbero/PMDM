# 1 Introduction. Declarative and Imperative Interfaces

Traditional user interface development has been based on an imperative style, in which we define what we want to be represented in the interface and how we want to do it. In desktop, web, and mobile applications, we typically specify the user interface using XML-based files (pure XML, HTML, QML, etc.), which must then be transformed into manipulable elements and somehow linked to the application code.

In contrast to this approach, the declarative paradigm, which has been present in programming since the 1950s, proposes a higher level of abstraction and focuses on *what* rather than *how*. When applied to interface design, the idea is to focus on *describing* the *current* state of the interface, leaving it to the framework to render that state and handle the transitions between states. In other words, the user interface is generated based on the state we want to represent:

![Interface as a function of state. Source: esflutter.dev, licensed under CC BY 4.0](https://joamuran.net/flutter2026/u3/img/ui-equals-function-of-state.png)

The current trend toward declarative user interface development emerged with frameworks such as *React*, which introduced JSX files, where JavaScript code and HTML coexist. Later, *Flutter* came into the picture at Google I/O in 2017. This shift has also reached native Android development with *Jetpack Compose* and *composable* interfaces, iOS with *SwiftUI*, and even environments such as Unity, with *UIWidget*.

## Thinking Declaratively

This change in direction requires us to change the way we think about manipulating user interfaces and to introduce a declarative syntax for them. To do this, we will use a well-known feature of Dart: passing arguments by name.

Let's look at a simplified example. In web development, we might have the following `div` element in our HTML code, with CSS properties added to center the container horizontally and vertically:

```xml
<div id="Container"></div>
```

We would then need to manipulate it using JavaScript to add content, that is, find the element in the interface and modify it:

```javascript
let container = document.getElementById("Container");
container.innerHTML = "Hello World!";
```

The declarative approach to this problem would be: *I want some text saying "Hello World" centered on the screen.* In code, this would translate into something like the following:

```yaml
Center(
    child: Text(
        'Hello World'
    )
)
```

This defines a container that centers its elements, with the text *Hello World* inside it.

If we take a closer look at the code, we can see that we are not introducing anything new. Instead, we are using **constructors with positional and named parameters** in a different way:

- The constructor for the `Center` element receives a single named argument: `child`, which specifies the element it contains.
- This inner element is a `Text`, whose constructor receives the text *Hello World* as its only argument.

**References**

You can find more information about the topics covered here in the following articles:

- [*Start thinking declaratively*](https://docs.flutter.dev/data-and-backend/state-mgmt/declarative), from the Flutter documentation.
- [*Introduction to declarative UI*](https://docs.flutter.dev/get-started/flutter-for/declarative), from the Flutter documentation.
- [*Flutter: La imposición del Declarative UI o UI as Code*](https://medium.com/comunidad-flutter/flutter-la-imposici%C3%B3n-del-declarative-ui-o-del-ui-as-code-5e5ec099ba84), on Medium (in Spanish).
- [*Imperative vs. declarative programming: Google Jetpack Compose*](https://www2.deloitte.com/es/es/blog/todo-tecnologia/2021/programacion-imperativa-vs-declarativa-google-jetpack-compose.html), on Deloitte (in Spanish).

# 2 Concepts

## Widgets

The fundamental concept around which all Flutter development revolves is the *widget*. In fact, in Flutter, apart from our own classes for maintaining information and data models, almost everything consists of *widgets*.

But what exactly are *widgets*? They are **Dart classes whose constructors accept both positional and named arguments, and which we use to represent the elements of our interfaces**. In the example from the previous section, we have already introduced two types of widgets: `Center`, a container-type *widget*, and `Text`.

Widgets can also be composed to create a tree structure that represents the interface. They can be stateless (*Stateless*) or stateful (*Stateful*), depending on whether the widget needs an associated state that may change.

For example, a button or static text that does not change and can be declared as a constant would be a good candidate for a stateless widget. In contrast, a component that displays the result of an asynchronous call would be a good candidate for a stateful widget.

An important difference between these two types is that stateful widgets can *redraw* themselves whenever their state changes, whereas stateless widgets cannot do so on their own.

> **Note**
>
> There is a third type of widget: inherited widgets (*InheritedWidget*), which allow data to be shared among the components contained within them. We will cover this type of widget later.

## The Widget Tree

As mentioned above, the widgets in an application can be composed to form a hierarchical tree structure. We can therefore think of a Flutter application as a large tree containing all its widgets. Whenever a widget's state changes, Flutter itself takes care of rebuilding the affected subtree and redrawing the interface.

As an example, let's look at the code for a basic interface consisting of an application bar, a central body, and a floating action button, along with the execution result and the corresponding widget tree:

![Basic interface example](https://joamuran.net/flutter2026/u3/img/mateapp.png)

Without going into details that we will cover later, we can see that the main widget, and the root of the widget tree, is a `MaterialApp` widget. Within it, the `home` property defines another widget of type `Scaffold`, which in turn has three child nodes: the `AppBar` widget in the `appBar` property; the container-type `Center` widget in the `body` property; and the `FloatingActionButton` widget in the `floatingActionButton` property. These last nodes also have child nodes of type `Text` or `Icon`.

As you can imagine, as we add more widgets to our interface, this tree will grow larger and larger. Flutter is responsible for generating and maintaining this tree, as well as performing the corresponding animations whenever the state changes, and thus managing the tree's structure.

One of the most complex aspects of working with Flutter is managing information and passing it from one part of the tree to another, especially when those parts belong to different branches.

You can find the working code in the following *gist*:

- [https://dartpad.dev/embed-flutter.html?id=9ea7b34384268a68e11cb8750eecf9b0](https://dartpad.dev/embed-flutter.html?id=9ea7b34384268a68e11cb8750eecf9b0)
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Material',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Barra d\'aplicació',
          ),
        ),
        body: const Center(
          child: Text('Hola Món'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
```

[Embedded DartPad example](https://dartpad.dev/embed-flutter.html?id=9ea7b34384268a68e11cb8750eecf9b0)

**Advanced: The Three Trees in Flutter**

So far, we have discussed the widget tree, which describes our user interface in an immutable way.

Internally, however, Flutter uses two additional trees to manage state and render these widgets on the screen:

- **Element Tree**: Once a widget has been created, Flutter creates an *Element*, which is a concrete instance associated with the widget's state. The element is the mutable link between the immutable widget and its actual rendering.
- **RenderObject Tree**: This tree manages the size and position of widgets on the screen. *RenderObjects* communicate with the GPU to determine how elements should be drawn. The objects in this tree are responsible for the actual layout and rendering of widgets.

These three trees work together to build the UI: the widget tree defines what we see, the element tree handles interactions with state, and the RenderObject tree manages the visual appearance and actual position of the widgets.

You can learn more about these three trees in the video [*How Flutter Works: The Three Trees* by #DecodingFlutter](https://www.youtube.com/watch?v=xiW3ahr4CRU).

# 3. Getting Started: From Hello World to the Counter

Let's move on to creating our first *Flutter* project. We'll start with a simple *Hello World* application and see how we can gradually add widgets until we turn it into an application that manages a simple click counter, similar to Flutter's example app.

> **ACTIVITY:** Read the following text and implement the examples in order to create your first Flutter project with widgets.

## Creating the Project

In the first unit, we saw how to create a Flutter project using both VS Code and the command line. Let's review the steps:

- **Option 1. Creating the project in VS Code**
  - Press `Ctrl+Shift+P` to open the Command Palette. Start typing to search for the *"Flutter: New Project"* command, and configure the project as follows:
    - *Which Flutter Template?*: Application
    - Project folder location: Choose wherever you want to store your Flutter projects.
    - *Project Name*: *hola_mon* (Remember that, like any Dart project, it cannot contain uppercase letters, but it can contain the `_` symbol.)
  - If we check the output for the `hola_mon` project in VS Code, we will see that the following command has been executed:

    ![Output of the Flutter: New Project command](https://joamuran.net/flutter2026/u3/img/create_project.png)

  - What we have done is invoke the command `flutter create --template app --overwrite .` to create the project and download its dependencies using `flutter pub get`. The output also tells us where the source code of our application will be located: `Your application code is in ./lib/main.dart.`

- **Option 2. Creating the project from the command line**
  - Open a terminal, navigate to the directory where you keep your projects, and run the following command:

```bash
flutter create --overwrite hola_mon
```

  - As you can see, we specified the project name instead of `.`, so that the `hola_mon` directory is created for the project.

Whether we create it through VS Code or the terminal, a new project will be generated with its complete structure and support for multiple platforms, such as *Android*, *iOS*, *Linux*, *macOS*, *web*, and *Windows*.

**Creating a Project for Specific Platforms**

Remember that, by default, a project is generated for all supported platforms. To restrict the application to specific platforms, we can use the `--platforms` option. For example:

```bash
flutter create --platforms linux,android,web hola_mon
```

Notice that we do not need to explicitly specify the `app` template because it is the default template.

**Adding New Platforms**

Once a project has been created, we can also use the `--platforms` option with `flutter create` to add new platforms to it.

For example, suppose we create a project for Linux only using the following command:

```bash
flutter create --platforms linux hola_mon
```

We can add another platform, such as Android, from inside the `hola_mon` directory by running:

```bash
flutter create --platforms android .
```

This preserves the existing code and generates only the `android` directory for Android support.

### Running the Default Application

Remember that in the first unit we also learned how to run Flutter applications, either from the command line (using a system terminal or the integrated VS Code terminal) or from the VS Code Command Palette.

To select the device on which to run the application, open the Command Palette with `Ctrl+Shift+P` and search for the *Flutter: Select Device* command. This lets us choose a device. In addition, the bottom-right corner of the VS Code window displays the currently selected default device and allows us to change it.

![Default device](https://joamuran.net/flutter2026/u3/img/selectDevice1.png)

![Device selection](https://joamuran.net/flutter2026/u3/img/selectDevice2.png)

Once we have selected a device, we can run and debug the application by pressing `F5`.

> **Warning!**
>
> Keep in mind that the first time you run a project on a particular platform, Flutter must download and install all the native libraries required by that platform. Consequently, the first run will take a little longer.

Once the application is running, we can tell that it is being debugged because debugging buttons appear at the top, the status bar turns red, and the Debug panel and Debug Console become active on the right-hand side.

![Debugging view](https://joamuran.net/flutter2026/u3/img/depuracio.png)

To stop debugging, click the *Stop* button, represented by a rectangle with a red outline in the top toolbar.

Alternatively, to run the project from the terminal, execute the following command from inside the application directory:

```bash
flutter run
```

If no device is currently running, Flutter will ask us which device we want to launch the application on.

**Running Flutter from the Command Line**

The following commands are available for managing devices from the command line:

- `flutter devices`: Displays the devices on which we can run our application, whether emulated or physical.
- `flutter emulators`: Displays the configured emulators. The `--launch` parameter allows us to start an emulator.

**Flutter Updates**

When a new version of Flutter is available, a message like the following will appear in the terminal:

```text
┌─────────────────────────────────────────────────────────┐
│ A new version of Flutter is available!                  │
│                                                         │
│ To update to the latest version, run "flutter upgrade". │
└─────────────────────────────────────────────────────────┘
```

As indicated in the message, we can update Flutter by running `flutter upgrade`.

We may also receive a message indicating that there are local changes in our Flutter installation. In that case, we can use the `-f` or `--force` option to ignore those local changes.

## Starting with "Hello World"

The default application generated by Flutter is a counter application that combines different widgets, both stateful and stateless. Although this application will help us explore many concepts, we will start with simpler code: a *Hello World* application that we will gradually expand.

First, open the `lib/main.dart` file and replace its entire contents with the following code:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Text(
      'Hello World',
      textDirection: TextDirection.ltr,
    ),
  );
}
```

This program works as follows:

- Remember that a Dart application always starts by executing the `main` function, which in this case takes no arguments.
- Inside `main`, we call `runApp`, which is responsible for running the Flutter application.
- The `runApp` function receives a single argument: a `Widget` object, which becomes the application's main widget and the widget that must be rendered. In this case, it is a `Text` widget containing the text *Hello World* (its first positional argument), displayed from left to right (the optional named argument `textDirection`, set to `TextDirection.ltr`). Without this named argument, Flutter produces the following error because it does not know how to render the text:

![Rendering error](https://joamuran.net/flutter2026/u3/img/error_text_direction.png)

**Constant Widgets**

Notice that the `Text` widget has been declared as a constant using `const`. If we do not do this, we will see the warning *Prefer const with constant constructors*.

In Flutter, **widgets that will not change during execution should generally be declared as constants**. In this case, the text is created directly from a string. Declaring it as a constant tells Flutter that the widget, or subtree of widgets, does not need to be reconstructed, improving rendering efficiency.

Our application displays *Hello World* in the upper-left corner. Therefore, when we run it on a mobile device, the text appears below the system notification bar.

![Text positioned in the upper-left corner](https://joamuran.net/flutter2026/u3/img/holaMon1.png)

On some mobile devices, depending on the notification bar configuration, the text might not even be visible.

To center the text, we will place it inside a `Center` widget. We can do this manually or **use the code actions provided by the Flutter extension for VS Code**. To display these actions, click the yellow light bulb that appears next to the line containing the `Text` widget, or place the cursor over the widget and press `Ctrl`+`.`.

![Code actions](https://joamuran.net/flutter2026/u3/img/holaMon2.png)

As you can see, the *More Actions* section lets us wrap (*Wrap*) the widget in another container widget.

**Warning**

On Ubuntu 22.04 and derivatives, the `Ctrl`+`.` keyboard shortcut is used by IBus to access emojis. As a result, you might see an underlined `e` instead of the menu. If this happens, run `ibus-setup` in a terminal and change the keyboard shortcuts in the Emoji tab.

![IBus configuration](https://joamuran.net/flutter2026/u3/img/2/ibus.png)

Once the code actions menu is open, select *Wrap with Center*. The resulting code will be:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    Center(
      child: const Text(
        'Hello World',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
```

This code displays the warning *"Prefer const..."* again because the `Center` widget we just introduced will not change during the application's execution either. It should therefore also be declared as a constant:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Center(
      child: Text(
        'Hello World',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
```

As you can see, we have also removed `const` from the `Text` widget. When we declare a widget as a constant, its descendant widgets in the widget tree are constant as well. If we leave `const` in front of `Text`, a new warning appears: *Unnecessary 'const' keyword*.

Therefore, the `const` keyword should be declared as high up in the widget tree as possible.

With this change, the text will be centered on the screen.

You can see a summary of this process in the following animation:

![Centering the text. This is an animated GIF available in the online version only](https://joamuran.net/flutter2026/u3/img/2/wrapWithCenter.gif)

### Creating Our Own Widget

The `runApp` function, which we call from `main`, sets the application's main widget and attaches it to the screen.

So far, we have defined this widget directly in the function call. However, the usual approach is to define it independently as a custom widget.

To create a custom widget, we must define a class that extends either the abstract `StatefulWidget` class if we want a **stateful widget**, or the abstract `StatelessWidget` class if we want a **stateless widget**.

To define `MyApp` as a stateless widget, we would declare the following class:

```dart
class MyApp extends StatelessWidget {}
```

As it stands, this class declaration produces the error `non_abstract_class_inherits_abstract_member`. To read the error description, hover the mouse pointer over it. A window similar to the following will appear:

![Inspecting the error](https://joamuran.net/flutter2026/u3/img/2/error_build.png)

As we can see, the message tells us that when we extend `StatelessWidget`, we must provide an implementation of the `build` method.

If we select the *Quick Fix* option, a dialog will appear with the possible corrections. Select the first option, *Create 1 missing Override*.

![Quick fix for errors](https://joamuran.net/flutter2026/u3/img/2/error_build_quickFix.png)

The generated code will be:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
```

As we can see, the `build` method returns a `Widget` and, as its name suggests, it is responsible for *building* that widget.

Notice also that this method receives a `context` argument of type `BuildContext`. Let's take a moment to examine this concept.

**What Is Context?**

In general, context refers to the circumstances in which an event occurs. In Android, for example, it refers to the current state of an application or object, from which we can obtain information about the application and access certain resources, databases, or preferences.

In Flutter, `BuildContext` literally means *build context*: the state of the application at the time a widget is built. This context is represented by the path through the widget tree from the root to the node being created. By following this path, we can obtain information from ancestor nodes.

**Further Reading**

You can find more information about context in the following articles:

- About `BuildContext`: [What Is BuildContext in Flutter?](https://www.educative.io/answers/what-is-buildcontext-in-flutter)
- About context in Android: [Context in Android: Application Context vs Activity Context](https://www.oodlestechnologies.com/dev-blog/context-in-android-:-application-context-vs-activity-context/)

Returning to our practical example, we now need to add the code that builds the application's main widget inside the `build` method.

As mentioned earlier, this method **builds the main interface based on other widgets**. Specifically, it will return the `Center` widget that we previously passed directly to `runApp`:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello World',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
```

We must also modify the `main` method to pass an instance of our widget to `runApp`:

```dart
void main() {
  Widget mainWidget = MyApp();
  runApp(mainWidget);
}
```

We can simplify this to:

```dart
void main() {
  runApp(MyApp());
}
```

We can even express `main` as an arrow function:

```dart
void main() => runApp(MyApp());
```

**Important!**

Notice that creating an instance of `MyApp` only requires calling its constructor; there is no need to use the `new` keyword. In fact, using it would produce the warning *Unnecessary new keyword*.

We have now created our first custom widget class and used it as the application's main widget. However, a warning still appears on the `MyApp` class. If we hover over it, we will see the message *Use key in widget constructors*.

![Warning: Use Key in Widget Constructors](https://joamuran.net/flutter2026/u3/img/2/warningKey.png)

If we accept the *Add key to constructors* quick fix:

![Quick fix for Use Key in Widget Constructors](https://joamuran.net/flutter2026/u3/img/2/warningKey_2.png)

A constructor with an optional key will be generated for our widget:

```dart
const MyApp({super.key});
```

This key is used to identify the widget more efficiently within the tree, similarly to how an `id` is used in Kotlin views or HTML.

**Further Reading**

For more information about keys, see the article [Keys! What Are They Good For?](https://medium.com/comunidad-flutter/llaves-para-que-son-buenas-aec7b539ee2a).

This new correction will generate another warning, *Prefer const with constant constructors*, which we have already encountered. Since the `MyApp` widget will not change during program execution, the warning suggests declaring it as a constant.

Our final code will therefore look like this:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hello World', textDirection: TextDirection.ltr),
    );
  }
}
```

### The *Extract Widget* Code Action

Another very useful code action, especially as our widget compositions grow, is widget extraction. This action allows us to extract a new widget from part of the tree we are building.

To apply it to our example, let's return to the initial code, before we created our custom widget:

```dart
void main() {
  runApp(
    const Center(
      child: Text(
        'Hello World',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
```

Place the cursor over the `Center` widget. The light bulb for code actions will appear on the left. Click it (or press `Ctrl`+`.`) and select *Extract Widget* from the contextual menu.

![Extracting a widget](https://joamuran.net/flutter2026/u3/img/extractWidget.png)

A dialog will appear asking for the widget's name. Enter `MyApp`:

![Extracting a widget](https://joamuran.net/flutter2026/u3/img/extractWidget2.png)

The code will be generated automatically. We only need to add `const` before `MyApp`:

```dart
void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello World',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
```

You can see this process in the following animation:

![Extracting a widget. This animated GIF is available in the online version only](https://joamuran.net/flutter2026/u3/img/2/ExtractWidget.gif)

### Creating Custom Widgets with Parameters

As we know, a widget is also a class, so we can declare as many properties as we need and provide values for them through its constructor.

For example, let's create a simple stateless widget with a property called `propietatText`. The `build` method will simply return a `Text` widget containing the value of this property:

```dart
class ElMeuGinyPersonalitzat extends StatelessWidget {
  final String? propietatText;
  const ElMeuGinyPersonalitzat({required this.propietatText, super.key});

  @override
  Widget build(BuildContext context) {
    return Text("$propietatText");
  }
}
```

Notice that `propietatText` is declared as `final`, allowing us to define the constructor as constant and **thereby improve rendering efficiency.** If this property could change in the future, we could not declare it as `final`, and the constructor could not be declared as `const`.

Also notice that `propietatText` is initialized directly in the constructor using the simplified syntax, as a named argument alongside the widget's key (`key`). The key is added automatically when the widget is generated from snippets. Although it is possible to remove the key from the constructor, Flutter always recommends using one.

To use this widget, we simply call its constructor as many times as necessary, supplying a value for the property. For example, to include two widgets in a column, we could write:

```dart
Column(
  children: const [
    ElMeuGinyPersonalitzat(propietatText: "Text 1"),
    ElMeuGinyPersonalitzat(propietatText: "Text 2"),
  ],
)
```

As you can see, we only need to provide the `propietatText` property. Flutter generates the `key` based on the widget's type and other factors.

If we want, we can also provide the key ourselves using the `Key` constructor and passing it a string:

```dart
Column(
  children: const [
    ElMeuGinyPersonalitzat(
      propietatText: "Text 1",
      key: Key("key 1"),
    ),
    ElMeuGinyPersonalitzat(
      propietatText: "Text 2",
      key: Key("key 2"),
    ),
  ],
)
```

**Note**

As you can see, in this `Column` widget we used `children` instead of `child`, and we supplied a list of widgets rather than a single widget.

This is how widgets that accept multiple children work. A `Column`, for example, arranges widgets vertically, one below another. With these widgets, even if there is only one child, we must use the `children` parameter instead of `child` and pass it a list of values.

## Material Design Applications

Material Design is a design system created by Google in 2014. It includes design guidelines for improving the user experience, as well as implementations of interface components that can be used in Android, Flutter, and web applications.

Our projects include the Material component library, but we have not yet created a *Material* application as such. For this purpose, Flutter provides the `MaterialApp` widget, which serves as the foundation for Material applications and offers a set of interface elements and styles commonly used in these applications.

Among the different properties of `MaterialApp`, we should highlight the following:

- **`theme`**: Used to define the application's theme. In Flutter versions before 3.16 (November 2023), Material 2 was used, with a theme based on shades of blue. Starting with version 3.16, Material 3 became the default, offering an even more minimalist theme. With the introduction of Material You, application themes can also be customized using dynamic colors generated from the user's wallpaper.
- **`debugShowCheckedModeBanner`**: A Boolean value indicating whether to display the debug banner in the upper-right corner of the application. Its default value is `true`. To remove the banner, set this property to `false`.
- **`title`**: Specifies the application name displayed to the user.
- **`home`**: Defines the application's entry point. We will explore this property in more detail when we cover routes in the next unit.

The *Flutter Snippets* extension includes a snippet for generating a basic Material application. If we delete our existing code and type the abbreviation `mateapp`, we can select this snippet:

![The `mateapp` snippet](https://joamuran.net/flutter2026/u3/img/mateappSnippet.png)

It will generate the application's entire skeleton:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

Let's see this process in an animation:

![Snippet for creating a Material application](https://joamuran.net/flutter2026/u3/img/2/mateapp.gif)

### The `Scaffold` Widget

As we can see, the Material application generated by the snippet includes the application title (`title: 'Material App'`) and its entry point (`home: Scaffold(...)`).

The `Scaffold` widget used as the entry point implements the basic visual layout structure of Material Design and provides several APIs for managing navigation. By default, as we anticipated in the introductory section, this `Scaffold` contains the following two elements:

- **`appBar`**: The application's top bar, implemented using an `AppBar` widget. This widget supports many customizations, although for now we are only adding a title.
- **`body`**: The main body or content of the application, which by default contains a `Center` container with a `Text` widget.

To adapt this structure to our example, we only need to change *Hello World* to *Hello World!* in the body. Since this is a `MaterialApp`, the text direction is already defined by the application style, so we no longer need to set the `textDirection` property explicitly.

In this example, we will also change the text in the top bar to *"Bar Text"*.

Our code could therefore look like this:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Application',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bar Text'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

When we launch the application, we will see how its appearance changes:

![Hello World with Material](https://joamuran.net/flutter2026/u3/img/2/mateappHola.png)

As you can see, the *Debug* label appears in the upper-right corner. To hide it, we can use the `debugShowCheckedModeBanner` parameter of the `MaterialApp` widget as follows:

```dart
MaterialApp(
  title: 'Material Application',
  debugShowCheckedModeBanner: false,
  home: Scaffold(...),
)
```

**Note**

Remember that the parameters passed to the constructor are named parameters, not positional parameters. Therefore, their order does not matter.

**References and Useful Documentation**

- [Official Flutter documentation on Material](https://docs.flutter.dev/ui/widgets/material)
- [Building user interfaces with Flutter](https://docs.flutter.dev/ui), from the official Flutter documentation.
- [The `MaterialApp` class in the Flutter API reference](https://api.flutter.dev/flutter/material/MaterialApp-class.html)
- [Material Design website](https://m3.material.io/)

## Organizing the Code

Although we have placed all our code in the application's main file so far, it is more common to use a dedicated directory for the graphical user interface.

A common practice is to create a `screens` directory (or `views` or `ui`) inside the project's `lib` directory to hold the different *screens* of the application.

In our case, following the CLEAN architecture recommendations introduced in the previous assignment, we will introduce **a presentation layer**, where we will place the directory for our screens (`lib/presentation/screens`). We can create this directory either from the terminal or through the VS Code file explorer.

**The Presentation Layer**

The **Presentation Layer** is where all user interface (UI) components and their interactions with the user are managed.

Instead of having only a `screens` directory, we will follow the Clean Architecture convention and use `presentation/screens` for our screens. These screens will communicate with the domain layer, where the business logic resides, and, when necessary, with the data layer through the repository.

This approach maintains a clear separation of responsibilities across layers for managing application logic, state, and appearance. It also makes the application easier to maintain, improves modularity, and facilitates teamwork.

Inside `lib/presentation/screens`, we will create a file for the application's home screen, for example `home_screen.dart`. We will move the `MyApp` class we created earlier into this file and rename it `HomeScreen`.

The result would be:

```dart
/*
File: lib/presentation/screens/home_screen.dart
Contains the application's home screen.
*/

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material Application',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bar Text'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

We would then leave `lib/main.dart` with the following code:

```dart
import 'package:flutter/material.dart';
import 'package:hola_mon/presentation/screens/home_screen.dart';

void main() => runApp(const HomeScreen());
```

As we can verify, replacing `MyApp()` with `HomeScreen()` allows VS Code to import `home_screen.dart` automatically.

Notice that the file path includes the package name `hola_mon` and the `presentation/screens` subdirectory, but not the `lib` directory, because that is understood to be the location of the source code.

**Important: The Material Library**

In the new `HomeScreen` class, we must import the Material library to use Material classes such as `Widget`, `MaterialApp`, and `StatelessWidget`:

```dart
import 'package:flutter/material.dart';
```

## Turning Hello World into a Counter App

Let's now move from our simple *Hello World* application to creating a counter app.

To do this, we mainly need to modify the layout to display the number of clicks and add a button to increment the counter. We must also implement the button's functionality.

### Adding the Number of Clicks

Before displaying the number of clicks, we need to introduce a special type of widget: *layout containers*. These widgets organize groups of widgets according to different layout rules.

Broadly speaking, layout widgets can be divided into those that have a single child and determine how that child is displayed, and those that have multiple children and arrange them relative to one another.

The widget we will use belongs to the second group: `Column`, which arranges its child widgets vertically.

The main difference between a container with a single child and one with multiple children is that the former uses the `child` property to specify a single widget, whereas the latter uses the `children` property, initialized with a list of widgets.

We will now add a `Column` container inside the `Center` widget we already have, so that the column is centered. We can write the code directly or wrap our existing `Text` widget in a `Column` container.

To do this, place the cursor over the text again, click the light bulb to display the contextual menu, and select *Wrap with Column*. This will add the `Column` widget with its `children` property, initialized with a list containing the existing `Text` widget.

![Wrapping Text with Column](https://joamuran.net/flutter2026/u3/img/2/wrapColumn.png)

Now we only need to modify the first text and add a second one to display the counter value. The code would look like this:

```dart
body: const Center(
  child: Column(
    children: [
      Text('Hello World'),
      Text('0'),
    ],
  ),
)
```

**Tip: Trailing Commas**

The way the editor automatically formats elements depends on how we write them. According to the formatting rules, when several arguments—whether function arguments or elements in a list—fit on one line, the formatter places them on that line.

However, if we want the different arguments or elements to appear on separate lines for readability, we only need to add a comma at the end of the list and format the code again (`Ctrl+Shift+I` or automatic formatting on save).

You can see this visually in the following animation:

![Trailing commas](https://joamuran.net/flutter2026/u3/img/2/comma.gif)

This code displays the two texts vertically in a column, but perhaps not where we intended: they appear at the top of the screen.

![Code result](https://joamuran.net/flutter2026/u3/img/2/comptador_1.png)

This happens because the column widget is centered but occupies all the available space inside the `Center` widget. Within that space, it stacks its children from top to bottom.

We can control how the widgets and the remaining space inside the column are arranged in several ways using the `mainAxisAlignment` property of `Column`.

For example, to center the widgets:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  ...
)
```

`MainAxisAlignment` is an enumeration (`enum`) containing the possible values for this property. In addition to `center`, we have `start` (the default), `end`, `spaceAround`, `spaceBetween`, and `spaceEvenly`.

These values have the following visual effects:

![Values of MainAxisAlignment](https://joamuran.net/flutter2026/u3/img/2/MainAxisAlignment.png)

### Modifying Text Properties

The `Text` widget requires a first positional argument containing the text to display. It also accepts several named arguments to define the text's properties.

One of these properties is `style`, which determines the text style and is defined using the `TextStyle` class. This class allows us to configure several properties, including `fontSize`, which determines the font size.

Our text could look like this:

```dart
Text(
  '0',
  style: TextStyle(fontSize: 50),
)
```

### Adding the Floating Action Button

To increment the counter, we will use a *Floating Action Button*.

The `Scaffold` widget, which provides the basic layout for a Material application, accepts the named arguments `appBar` and `body`, among others. It also accepts `floatingActionButton`.

This argument can contain any widget, but it will generally be a `FloatingActionButton` object defined in the Material library.

This button requires an `onPressed` property containing an anonymous callback function (or arrow function) that executes whenever the button is clicked. If this callback contains no code, we could declare the button as a constant.

To specify the button's content, we use the `child` property, which will generally contain an `Icon` widget. This widget requires a first positional argument specifying the icon to display.

In our case, we will use `Icons.add`, which displays the `+` symbol. For now, the resulting code, with an empty callback, will be:

```dart
Scaffold(
  appBar: ...,
  body: ...,
  floatingActionButton: FloatingActionButton(
    onPressed: () => {},
    child: const Icon(Icons.add),
  ),
)
```

With this, we have completed the counter's layout. All that remains is to implement its functionality.

### Adding Functionality to the Counter: The First Problems

The functionality is fairly simple. We need to define a variable that stores the counter's value and increment it whenever the floating action button is clicked. We also need to replace the `"0"` text with the current value.

The code would include the following changes. Notice that we have had to remove some `const` keywords because we now have an element that is not constant:

```dart
@override
Widget build(BuildContext context) {
  int counter = 0;

  return MaterialApp(
    ...
    home: Scaffold(
      appBar: ...,
      body: Center(
        child: Column(
          ...
          children: [
            const Text('Counter value'),
            Text(
              '$counter',
              style: const TextStyle(fontSize: 50),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          counter++;
          debugPrint('[LOG]: Updating counter to $counter');
        },
        child: const Icon(Icons.add),
      ),
    ),
  );
}
```

Let's examine some details of this code:

- We defined the counter inside the widget's `build` method.
- We had to remove `const` from the `Column` element because now only the first `Text` and the second text's style are constant.
- We added the counter value to the second `Text` widget using string interpolation: we insert the variable into the string using `$`.
- We added the counter increment operation to the `onPressed` method and included a `debugPrint` statement to display updates in the console. Since the callback now contains two instructions instead of one, we expressed it as an anonymous function rather than an arrow function.

**Note**

In Flutter applications, it is preferable to use `debugPrint` rather than `print` when writing messages to the console. If we use `print`, the application will still work, but we will receive a warning advising us not to use it in production code.

If we run the program again, we will see that although the log message correctly displays the counter value, the value shown in the interface does not change.

**Stateful and Stateless Widgets**

This behavior occurs because we used a stateless widget: `HomeScreen` extends `StatelessWidget`. As mentioned in the introduction, stateless widgets cannot redraw themselves.

The solution is to use a stateful widget so that it can redraw itself whenever its state changes.

*Does this mean that stateless widgets cannot reflect the state of our application?*

No. As we will see later, we can use state management solutions together with stateless widgets. The widgets can then update *reactively* when the state changes, without maintaining state themselves.

*When should we use one type of widget or the other?*

Generally, when we use a state management solution, we can use stateless widgets that update automatically according to the state.

However, when we need a widget to interact with the user and maintain its own changing state, we often use a stateful widget, as in the case of this counter.

### Adding Stateful Widgets

As their name suggests, stateful widgets are associated with *state*, understood as a set of variables whose values can change.

Before modifying our code, let's examine the structure of a stateful widget.

The `statefulW` snippet provides a basic template for these widgets, which we can customize with the desired name. The following animation shows how to use it:

![Animation showing the use of the StatefulW snippet](https://joamuran.net/flutter2026/u3/img/2/myWidget.gif)

After renaming the widget to `MyWidget`, the resulting code is:

```dart
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

Let's examine some details:

- First, notice that we are now defining **two classes**: one for the widget itself (`MyWidget`) and another representing its state (`_MyWidgetState`). The second class starts with `_`, indicating that it is private.
- The widget class (`MyWidget`) now extends `StatefulWidget`, indicating that it is associated with mutable state. Like other widgets, its constructor also has a `key` property so that the widget can be referenced within the widget tree.
- The `MyWidget` class no longer contains the `build` method. Instead, it overrides the `createState()` method inherited from `StatefulWidget`. The framework invokes this method when the widget is first inserted into the widget tree, creating an instance of `_MyWidgetState()`. This state instance is reused when the widget is rebuilt.
- The class representing the state (`_MyWidgetState`) is now responsible for overriding the `build` method and therefore for *redrawing* the widget.

Let's modify our code. We can use a code action to convert a stateless widget into a stateful widget.

Place the cursor over the `HomeScreen` class declaration and click the light bulb that appears beside it, or press `Ctrl`+`.`. The following option will appear:

![Converting a widget to Stateful](https://joamuran.net/flutter2026/u3/img/convertStateful.png)

Apply this change and **add the counter as a property of the class itself**, rather than defining it inside the `build` method:

```dart
class _HomeScreenState extends State<HomeScreen> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(...);
  }
}
```

**Note**

To run the application after these changes, we need to perform a *Hot Restart* (`R`) rather than a *Hot Reload* (`r`), because we have changed the widget type.

If we run the application now, we will see that the interface still does not update. One final detail remains: **we must notify Flutter that the widget's internal state has changed**, so that it needs to redraw the widget.

We do this using the `setState()` function, passing it an anonymous function containing the code that modifies the state.

The resulting code for the `FloatingActionButton`'s `onPressed` event will therefore be:

```dart
onPressed: () {
  setState(() {
    counter++;
  });
  print('[LOG]: Updating counter to $counter');
}
```

With this change, our counter application finally works.

**Note**

State changes can also be made outside the anonymous function passed to `setState()`. Therefore, we could have written the following:

```dart
onPressed: () {
  counter++;
  print('[LOG]: Updating counter to $counter');
  setState(() {});
}
```

## Summary

In this section, we have learned how to create a new Flutter project, starting with a simple centered *Hello World* text and gradually modifying it until it becomes a counter application similar to the one in the default Flutter project.

Although we have not yet explored widgets in depth, we have learned several useful concepts:

- Creating Flutter projects from both the command line and VS Code, and specifying particular platforms for the application.
- Running our project from both the command line and VS Code.
- Understanding the `main` and `runApp` functions in a Flutter project.
- Knowing when widgets should be declared as constants.
- Creating custom widgets using snippets.
- Understanding `BuildContext` and its relationship with the widget tree.
- Extracting a widget from a nested structure in VS Code to create a custom widget.
- Understanding the structure of a *Material Design* application.
- Understanding the structure of the `Scaffold` widget.
- Organizing code into directories.
- Arranging content in columns using the `Column` widget.
- Adding a floating action button and implementing its functionality.
- Understanding the difference between *Stateless* and *Stateful* widgets and how to define state.

> **ACTIVITY:**
>
> To check that you understand these concepts and can work with Flutter UIs, try the following exercise:
>
> **Add another button to decrement the counter and another button to reset its value to 0.**
> 
>- **Hints for the solution:**
>  - The `floatingActionButton` property of `Scaffold` does not necessarily have to contain a `FloatingActionButton`. It can contain, for example, a `Row` or `Column` container, inside which we can place several buttons.
>  - If you want to change the position of the `floatingActionButton` component, you can use the `floatingActionButtonLocation` property of `Scaffold`. Its possible values are available under `FloatingActionButtonLocation.*`.