# 5.2. Navigation Widgets: Organizing Navigation in an Application

In the previous section, we saw how to use Flutter's navigation system based on `Navigator` and routes (`MaterialPageRoute`). This mechanism allows us to move from one screen to another within the application by adding and removing routes from the navigation stack.

This type of navigation is useful when we want to move from one related view to another, for example:

- From a view containing general information (such as a list or grid of dishes) to a detail view.
- From a form to a confirmation screen.
- From a main screen to a settings screen.

In these cases, we use `Navigator` to open a new screen temporarily and then return to the previous one.

However, real-world applications often have several main sections that users can move between at any time.

To organize this type of navigation, we use specific navigation widgets, such as:

- Bottom navigation bars (`NavigationBar`).
- Navigation rails (`NavigationRail`).
- Tabs (`TabBar`).

These components allow us to define the application's main structure and make it easier for users to move between its main sections.

In this section, we will see how to use these widgets to organize the main and secondary navigation of a Flutter application, while `Navigator` will remain the mechanism we use to navigate between specific screens within each section.

## Main Application Navigation

In the following section, we will look at the different widgets we can use for main navigation in our applications: `NavigationBar` for mobile applications and `NavigationRail` for tablets and desktop applications. We will also look at `NavigationDrawer`, which has traditionally been widely used but is no longer recommended.

## NavigationBar and Mobile Apps

With the introduction of Material 3, the main navigation mechanism for apps is the navigation bar (`NavigationBar`).

*Examples of NavigationBar. Source: m3.material.io*

This widget contains a collection of destinations, usually of type `NavigationDestination`. It also has two important properties: `selectedIndex`, which stores the index of the selected destination, and `onDestinationSelected`, which is associated with a callback that is triggered when the user selects a destination in the bar:

```dart
NavigationBar(
  onDestinationSelected: (int index) {...},
  selectedIndex: indexActual,
  destinations: const <Widget>[
    NavigationDestination(...),
    NavigationDestination(...),
    ...
  ],
)
```

The `NavigationBar` widget is generally placed in the `bottomNavigationBar` property of `Scaffold`. The widget containing this navigation bar must be stateful, and its state stores the currently selected index (which we will call `indexActual`). As shown in the code above, this index determines the value of `selectedIndex` in `NavigationBar`.

In addition, the `Scaffold`'s `body` is obtained from a list of widgets, from which we select the widget currently located at the position indicated by `indexActual`:

```dart
class ExempleBottomNavigationBar extends StatefulWidget {
  ...

  @override
  State<ExempleBottomNavigationBar> createState() =>
      _ExempleBottomNavigationBarState();
}

class _ExempleBottomNavigationBarState
    extends State<ExempleBottomNavigationBar> {

  int indexActual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ...,
      bottomNavigationBar: NavigationBar(...),
      body: <Widget>[
        Container(...), // Widget for the content of destination 1
        Container(...), // Widget for the content of destination 2
        ...
      ][indexActual], // Select the corresponding content
    );
  }
}
```

When the user selects a destination, the `onDestinationSelected` event is triggered. In its callback, we update the selected index in the state. Updating the state also causes the interface (the `body`) to update and display the corresponding content:

```dart
onDestinationSelected: (int index) {
  setState(() {
    indexActual = index;
  });
}
```

We can illustrate the organization and operation of `NavigationBar` schematically.

### Complete example

Let's look at the complete example, based on the examples in the Flutter documentation:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Exemple amb BottomNavigationBar',
      home: ExempleBottomNavigationBar(),
    );
  }
}

class ExempleBottomNavigationBar extends StatefulWidget {
  const ExempleBottomNavigationBar({
    Key? key,
  }) : super(key: key);

  @override
  State<ExempleBottomNavigationBar> createState() =>
      _ExempleBottomNavigationBarState();
}

class _ExempleBottomNavigationBarState
    extends State<ExempleBottomNavigationBar> {
  int indexActual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: [
          const Text('Barra de l\'aplicació del destí 1'),
          const Text('Barra de l\'aplicació del destí 2'),
          const Text('Barra de l\'aplicació del destí 3')
        ][indexActual],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            indexActual = index;
          });
        },
        selectedIndex: indexActual,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Destí 1',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people),
            label: 'Destí 2',
          ),
          NavigationDestination(
            icon: Icon(Icons.work_outline),
            selectedIcon: Icon(Icons.work),
            label: 'Destí 3',
          ),
        ],
      ),
      body: <Widget>[
        Container(
          color: Colors.amber,
          alignment: Alignment.center,
          child: const Text('Contingut del destí 1'),
        ),
        Container(
          color: Colors.lime,
          alignment: Alignment.center,
          child: const Text('Contingut del destí 2'),
        ),
        Container(
          color: Colors.teal,
          alignment: Alignment.center,
          child: const Text('Contingut del destí 3'),
        ),
      ][indexActual],
    );
  }
}
```

In the previous example, notice that to change the `AppBar` content according to the selected index, we use the same mechanism as for the `body`. We use the current selected index to choose the appropriate element from the `AppBar` title list.

The complete, working example is available in this Gist:

https://dartpad.dev/?id=e806d5bc2e934a662726eacab320c497

### References

- `NavigationBar` specification in the Material 3 documentation.
- `BottomNavigationBar` specification in the Flutter API documentation.

## NavigationRail for Tablet and Desktop Applications

The Material 3 `NavigationRail` component is the equivalent of `NavigationBar` for desktop applications and tablets displayed in landscape orientation. It is a column-shaped widget that can appear on either the left or right side of the screen and allows users to navigate between a small number of destinations. Material recommends three to five destinations.

*Examples of NavigationRail. Source: m3.material.io*

The main difference compared with `NavigationBar` is that `Scaffold` does not have a dedicated property for this widget. We must instead add it as a column within the `body` property. The general structure therefore looks like this:

```dart
Scaffold(
  appBar: AppBar(...), // The same as before
  body: Row(
    children: <Widget>[
      NavigationRail(...), // Column containing the NavigationRail
      const VerticalDivider(thickness: 1, width: 1), // Vertical divider
      Expanded(...) // Main content
    ],
  ),
)
```

As we can see, we have added a `Row` inside the `body`. Its first element is the `NavigationRail`, followed by a dividing line (`VerticalDivider`), and then an `Expanded` widget containing the main content corresponding to the selected index.

Some of the basic `NavigationRail` properties are:

- `selectedIndex`: The index of the selected destination.
- `onDestinationSelected`: Defines the callback invoked when the user selects a destination.
- `destinations`: A list of `NavigationRailDestination` elements representing the different destinations. These elements can have properties such as `icon` (icon), `selectedIcon` (icon when selected), and `label` (destination label).
- `labelType`: A value of type `NavigationRailLabelType` that determines how labels are displayed alongside the icons. Its values include `all`, which displays all labels; `none`, which hides all labels; and `selected`, which displays only the selected destination's label.
- `extended`: Displays the component in an extended form, with the icon and label side by side rather than vertically, making the column wider.

Let's see how to adapt the previous `NavigationBar` example to use `NavigationRail`:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Exemple amb NavigationRail',
      home: ExempleNavigationRail(),
    );
  }
}

class ExempleNavigationRail extends StatefulWidget {
  const ExempleNavigationRail({
    Key? key,
  }) : super(key: key);

  @override
  State<ExempleNavigationRail> createState() => _ExempleNavigationRailState();
}

class _ExempleNavigationRailState extends State<ExempleNavigationRail> {
  int indexActual = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: [
          const Text('Barra de l\'aplicació del destí 1'),
          const Text('Barra de l\'aplicació del destí 2'),
          const Text('Barra de l\'aplicació del destí 3')
        ][indexActual],
      ),
      body: Row(
        children: <Widget>[
          NavigationRail(
            labelType: NavigationRailLabelType.all,
            selectedIndex: indexActual,
            onDestinationSelected: (int index) {
              setState(() {
                indexActual = index;
              });
            },
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: Text('Destí 1'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.people_outline),
                selectedIcon: Icon(Icons.people),
                label: Text('Destí 2'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.work_outline),
                selectedIcon: Icon(Icons.work),
                label: Text('Destí 3'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // Main content
          Expanded(
            child: <Widget>[
              Container(
                color: Colors.amber,
                alignment: Alignment.center,
                child: const Text('Contingut del destí 1'),
              ),
              Container(
                color: Colors.lime,
                alignment: Alignment.center,
                child: const Text('Contingut del destí 2'),
              ),
              Container(
                color: Colors.teal,
                alignment: Alignment.center,
                child: const Text('Contingut del destí 3'),
              ),
            ][indexActual],
          ),
        ],
      ),
    );
  }
}
```

The complete example is also available to try in this Gist:

https://dartpad.dev/?id=31abb90ce11b15d00472dc0fbb7a7c9c

The official documentation provides more information about this widget, along with additional, more complete examples.

### References

- `NavigationRail` specification in the Material 3 documentation.
- `NavigationRail` specification in the Flutter API documentation.

## The Drawer Component

*Examples of Drawer. Source: m3.material.io*

The `Drawer` (Navigation Drawer) component was one of the most common mechanisms for navigating between screens in Material Design applications before Material 3. A `Drawer` is a side navigation menu that allows users to move between different screens. It mainly consists of a header and a list of options.

As we saw earlier, `Scaffold` has a `drawer` property that allows us to integrate this component into the structure of a Material application.

The `Drawer` widget contains a `ListView` child so that we can display the different options and allow users to scroll through them if there is not enough vertical space. The first element in this list is a `DrawerHeader` widget containing the drawer's header. The remaining elements are `ListTile` widgets representing the different options. These widgets can themselves contain other widgets, such as text or images.

Each `ListTile` also has a callback associated with its `onTap` event, where we handle the navigation itself. When implementing this navigation, we must consider which route we are currently on, which routes we can navigate to, and how to manage the route stack.

Schematically, we can represent this structure with a small amount of code.

### Drawer structure

As we can see, inside the `onTap` event handler, we use the abstract `ModalRoute` class to obtain the current route:

```dart
String currentRoute = (ModalRoute.of(context)?.settings.name).toString();
```

With `ModalRoute.of(context)`, we obtain the route closest to our context. We can then access its `settings.name` property, which returns the route's name.

We can compare this current route with the destination route and perform the navigation only if they are different:

```dart
String currentRoute = (ModalRoute.of(context)?.settings.name).toString();

if (currentRoute != "/ruta_desti") {
  Navigator.of(context).pushReplacementNamed('/ruta_desti');
}
```

Notice that we use `pushReplacementNamed` to replace the route in the stack. This allows the drawer to manage navigation without displaying the back arrow. Instead, the menu icon used to open the drawer appears.

You can see how it works in this Gist:

https://dartpad.dev/?id=28ffa02adbeac469f644728ba3dbd806

### References

- Drawer component specification in Material 3.
- `Drawer` class specification in the Flutter documentation.

## Secondary Navigation: Tabs

In addition to the main navigation mechanisms described above, we also have components designed to organize content within a single section of an application. One of the most commonly used is tabs.

Tabs divide a screen's content into different related categories or sections, allowing users to switch quickly between them without leaving the current context.

*Add Google Play Store example.*

Tabs therefore act as a secondary navigation mechanism, complementing other main navigation systems such as `NavigationBar` or `NavigationRail`.

According to the Material Design guidelines, we can distinguish between primary tabs and secondary tabs, which organize content into different hierarchical levels within the same screen.

Visually, tabs are positioned side by side and represent categories of equal importance. When there are many tabs, they can support horizontal scrolling, allowing more options to be displayed without overcrowding the interface.

## The TabBar and TabBarView Widgets

With Flutter, we can create a row of tabs using the `TabBar` component, which is generally placed at the bottom of the application bar. `TabBar` works together with the `TabBarView` widget, which is the container where the content of the different tabs is displayed, and a `TabController`, which controls their behavior.

*Examples of TabBar. Source: m3.material.io*

The simplest way to implement tabs is to use the default controller, `DefaultTabController`, which specifies how many tabs the row contains and which tab is initially selected.

The different widgets that make up this navigation structure can be represented in the following widget tree.

### Tabs structure

As we can see, the main widget is `DefaultTabController`, which controls the number of tabs and the initial tab. Its child is `Scaffold`.

Within the `Scaffold`'s `AppBar`, we place the row of tabs in the `bottom` property using the `TabBar` widget. This contains a list of `Tab` widgets, with as many elements as specified by `DefaultTabController`.

Meanwhile, the `Scaffold`'s `body` contains a `TabBarView` widget, which has as many children as there are tabs in the controller. The correspondence between tabs and their content is determined by their order: the first tab displays the first widget, the second tab displays the second widget, and so on.

### Keep in mind

The length specified in `DefaultTabController` must match the length of the tab list (`TabBar.tabs`) and the list of widgets (`TabBarView.children`).

Let's make this clearer with the following example, based on the Flutter documentation:

```dart
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String _title = 'Exemple de Pestanyes';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
      home: MyStatelessWidget(),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    /*
    The widget starts with a DefaultTabController, where we specify
    the number of tabs (length) and the index of the
    default tab (initialIndex).
    */
    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Exemple de Pestanyes'),
          /*
          The AppBar's bottom property contains the
          TabBar, which defines the different tabs.
          Tabs can contain text and an icon, but must
          contain at least one of the two.
          */
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(
                text: "Sol",
                icon: Icon(Icons.sunny),
              ),
              Tab(
                text: "Núvol",
                icon: Icon(Icons.cloud_outlined),
              ),
              Tab(
                text: "Pluja",
                icon: Icon(Icons.beach_access_sharp),
              ),
            ],
          ),
        ),
        // The TabBarView widget defines the containers
        // for the content of each tab.
        // This list can contain predefined widgets
        // or custom widgets with any content we want.
        body: const TabBarView(
          children: <Widget>[
            // Content of the first tab
            Center(
              child: Text("Assolellat"),
            ),
            // Content of the second tab
            Center(
              child: Text("Núvol"),
            ),
            // Content of the third tab
            Center(
              child: Text("Pluja"),
            ),
          ],
        ),
      ),
    );
  }
}
```

You can see it working in this Gist:

https://dartpad.dev/?id=478a93cbd07d27057b6b93314b55e3bf

As you can see, each child of `TabBarView` is defined as a `Center` widget containing text. In our own applications, we would instantiate our custom widgets here.

To use a `TabController` that we define ourselves, we need to create a stateful widget and define the controller within that widget's state.

You can find out how to do this in the official Flutter documentation, both in the `TabBar` class definition and in the *Work with tabs* cookbook.

### Documentation

- Tabs specification in the Material 3 documentation.
- `TabBar` class specification in the Flutter API documentation.
- *Work with tabs* cookbook in the Flutter documentation.

---

5.3. Dialogs
Material 3 documentation defines a dialog (also known as a dialog box) as a modal window that appears in front of app content to provide critical information or ask for a decision.

### Use of Dialogs

The fact that dialogs are modal means they are positioned in front of the interface and disable all app functionality until the action required by them is performed.

Given their interruptive nature, dialogs should be used sparingly and restricted to actions that block the app's normal operation, such as requiring user action, communicating critical information, or helping users complete a task.

To display lower-priority information, it is preferable to use other widgets that can be dismissed or disappear automatically, such as the SnackBars or MaterialBanners we have already seen.

### How do we provide information to the user?

In Flutter, we have several mechanisms to communicate information to the user, each designed for a different use:

| Component | Use |
| --- | --- |
| SnackBar | Temporary message |
| MaterialBanner | Persistent information |
| Dialog | User action or decision |

Dialogs are used when the app needs to interrupt the normal flow and require user action.

### Types of Dialogs

In Material Design, we can find different types of dialogs. The most common are basic dialogs, which occupy only a portion of the screen, and full-screen dialogs, which are used when the task requires more space or multiple actions.

Basic dialogs, although they only occupy a part, leave the rest of the screen inaccessible. Within these, we can display alerts or confirmation messages that require the user's attention and some action on their part.

On the other hand, full-screen dialogs occupy the entire screen and require completing several actions before closing, such as filling out multiple fields in a form.

The Material documentation explains the different elements that make up a dialog, both basic and full-screen:

In this one, we distinguish the following elements:

1. Dialog container
2. Icon (optional)
3. Header (Optional)
4. Dialog text
5. Divider (optional)
6. Actions
7. Scrim, a temporary layer between the dialog and the interface it overlays, partially obscuring it and making this modal behavior possible.

On their part, modal dialogs have the following structure:

Which contains the following elements:

1. Container
2. Header space
3. Icon to close the dialog
4. Header (optional)
5. Actions
6. Divider (optional)

### The Dialog Class and the showDialog Function

The base class for working with dialogs in Flutter is `Dialog`, although you will generally use its subclasses `AlertDialog` and `SimpleDialog`.

To display any dialog, we use the `showDialog` function defined in the Material library. This function allows us to specify various parameters such as colors, animations, or the behavior of the modal barrier (Scrim).

The definition of this function is as follows:

```dart
Future<T?> showDialog<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  bool barrierDismissible = true,
  Color? barrierColor = Colors.black54,
  String? barrierLabel,
  bool useSafeArea = true,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
})

```

Which contains the following mandatory parameters:

* `context`: The build context. This context is used to access the Navigator and the app's Theme, but the dialog widget will be built with a new context provided by the builder.
* `builder`: This second mandatory parameter is an anonymous function that returns the widget corresponding to the dialog. Inside this function is where we must create its content.

In addition to these, we have other optional arguments, among them:

* `barrierDismissible`: A boolean value with which we give the option to close the dialog by tapping outside of it (the modal barrier or scrim). By default, it takes the value `true`.
* `barrierColor`: Allows us to specify the color of the modal barrier (scrim).
* `useSafeArea`: A boolean value defaulting to true, which establishes whether the dialog field should only be displayed in safe areas, or in other words, areas of the screen not used by the operating system.

In Flutter, dialogs are also managed through the routing system. When we show a dialog with `showDialog`, Flutter adds a new temporary route to the Navigator's stack. When the dialog is closed with `Navigator.pop()`, this route is removed from the stack and can return the information collected by the dialog in a `Future`.

### Adaptive Dialogs

Flutter also offers the `showAdaptiveDialog` function, which creates a platform-adapted dialog, such that:

* On Android, the Material style is used.
* On iOS, a style similar to `CupertinoAlertDialog` is used.

This option can be useful when we are developing applications where we want them to have a visual appearance as close as possible to the native style of each platform.

### AlertDialog

`AlertDialog` is used when we want to inform the user about certain situations that require some response on their part. Generally, it consists of a title (`title`), content (`content`), and a list of actions (`actions`). When the content is too large to fit on the screen, the title and actions remain in place, and it is the content that overflows. To avoid this, a `SingleChildScrollView` is often used to manage scrolling in the content.

Let's see what the code would look like to create a simple `AlertDialog` when a button is pressed:

```dart
ElevatedButton(
  onPressed: () {
    // When the button is pressed, we show the dialog
    showDialog(
      // We provide the context
      context: context,
      // And the function (builder) that builds the dialog
      builder: (context) {
        // This will consist of an AlertDialog containing
        // * A title
        // * The content
        // * And an action button (TextButton type)
        return AlertDialog(
          title: const Text("Alert Dialog Example"),
          content: const Text("Dialog box content"),
          actions: [
            TextButton(
              // When this button is clicked, the dialog is popped
              // to return to the previous view.
              onPressed: () {
                Navigator.pop(context, "Cancel");
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  },
  // ElevatedButton content
  child: const Text("Show an AlertDialog"),
)

```

As we can see, the most common approach is to provide the `AlertDialog` with the header title, its content, and a list containing the various action buttons. Note that these buttons are of type `TextButton`. Since the dialog is already a widget containing elevation, according to Material Design guidelines, other elevated elements should not be included inside it, which is why this type of button is used within a dialog. Keep in mind that, although in the example we only added one button for simplicity, it is a list that can hold more buttons.

Finally, as you can see, the way to close the dialog is by popping it off the route stack via a `Navigator.pop`. This is why we need to provide the context when creating it, since without it, it would not have access to the Navigator. In this case, moreover, when we pop, we also return the value "Cancel".

> **Warning!**
> As with any Material widget, we need this `AlertDialog` to be inside a widget that has a Material ancestor, such as `MaterialApp`. Otherwise, we will get the exception `No MaterialLocalizations found`.
> Remember that it will not be enough to add the code directly to the body of a `MaterialApp`, but it must be in another widget and that widget added to the body.

### Capturing the Return Value

In order to inform ourselves about the value the user has selected in the dialog, a `Future` with the return value is used. We can either use `async/await` to capture it, or handle this `Future` with `.then`. For example:

```dart
ElevatedButton(
  onPressed: () {
    // When the button is pressed we show the dialog
    Future<String?> response = showDialog<String?>(
      // ...
    );
    // When a response is received we print it to the console
    response.then((value) => debugPrint(value));
  },
  child: ...
)

```

In this example, if we click the Cancel button, the text "Cancel" will be displayed in the console.

Another way to close the dialog, since we haven't specified otherwise in the `barrierDismissible` property, is by clicking on the outside part of the dialog. In this case, the value returned will be `null`. If we want the user to be forced to click on a button in the dialog to close it, we should specify this value as false (`barrierDismissible: false`).

Another option is to return nothing when dealing with the Cancel value, and directly do a `Navigator.pop(context)`, so that it returns `null` in both cases. We will thus know that this is the value returned when the dialog is cancelled in either of the two ways.

### SimpleDialog

The `SimpleDialog` subclass represents a slightly more advanced dialog where the user is offered the possibility to choose between different options.

This dialog contains a title (although optional) and a list of different options, which are generally widgets of type `SimpleDialogOption`. These widgets will have two components: `onPressed` with the anonymous function that determines the action to perform for the option (usually closing the dialog returning a specific value), and the `child` component with the content to be displayed in the option (usually text).

Let's see it in the following example that presents a dialog with three options:

```dart
showDialog(
  // We provide the context
  context: context,
  // And the function (builder) that builds the dialog
  builder: (context) {
    // This will consist of a SimpleDialog containing
    // * A title
    // * Different widgets (SimpleDialogOption) with the options
    return SimpleDialog(
      title: const Text("Alert Dialog Example"),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, "Option 1");
          },
          child: const Text('Option 1'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, "Option 2");
          },
          child: const Text('Option 2'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, "Option 3");
          },
          child: const Text('Option 3'),
        ),
      ],
    );
  },
);

```

As we can see, despite having a different structure, it works similarly to the `AlertDialog`.

### Dialog

The `AlertDialog` and `SimpleDialog` classes are usually sufficient for a large number of situations. However, sometimes we may need to use the `Dialog` class to generate a more customized dialog.

The most important component of `Dialog` is `child`, to which we define a widget with the content of the entire dialog.

Thus, broadly speaking, the schema to create a `Dialog` would be:

```dart
showDialog(
  context: context, // We provide the context
  builder: (context) { // And the builder function
    return Dialog(
      child: WidgetForDialog(),
    );
  },
);

```

And keeping in mind that any widget can fit inside the `child` component, such as an entire form.

Let's look at it with a more complete example. Let's see how we would create a dialog with an adaptation of the form we covered in section 4.2 of this unit.

First, we invoke `showDialog` just as we have done so far:

```dart
Future<String?> showMyDialog(BuildContext context) {
  return showDialog(
    context: context, // We provide the context
    builder: (context) { // And the builder function that builds the dialog
      return const FormDialog();
    },
  );
}

```

As we can see, instead of building the dialog directly, we have used a custom widget, which we have named `FormDialog`.

This `FormDialog` widget will be a widget with associated state, since it will need a controller for the text field. Thus, we must define the class itself and the class corresponding to the state, in which we will define the private properties `_formKey` and `_controller`:

```dart
class FormDialog extends StatefulWidget {
  const FormDialog({ super.key });

  @override
  State<FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<FormDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ...
    );
  }
}

```

And the `child` component will be the one that defines the `Form`, just as we saw in the unit on forms:

```dart
child: Form(
  key: _formKey,
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        createDialogHeader(),
        const Divider(height: 64),
        createRegisterNameFormField(),
        createCheckboxConditionsFormField(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            createSubmitButton(context),
            createCancelButton(context),
          ],
        ),
      ],
    ),
  ),
),

```

As we can see, we incorporate `_formKey` as a key to reference it later, and as a child of this form we add a `Padding` widget (to add spacing at the edges) containing a column with the various widgets. Notice that in this column, we have set the `mainAxisSize: MainAxisSize.min` property. With it, we achieve that the height of the column (and therefore the dialog) adjusts to its content. The elements contained in the column will be:

* Text acting as a header (generated by the `createDialogHeader` function),
* A divider bar,
* A `FormField` for the email (generated by the `createRegisterNameFormField` function),
* A checkbox (generated by the `createCheckboxConditionsFormField()` function), and
* A row with two buttons, generated by the `createSubmitButton` and `createCancelButton` functions.

Most of these functions are the ones we used in section 4.2. The main change regarding these functions will be when processing the click on the accept or cancel buttons, since these will now need to close the dialog and return the entered information or not.

Let's look at the code corresponding to these:

```dart
// Button to close the dialog processing the form,
// after validating the widgets
Widget createSubmitButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      // We access the form using _formKey.
      // From here, we access the current state via currentState,
      // and validate it with the "validate" method.
      // This method will invoke all validations of each widget.
      // If all are valid, the form is valid.
      if (_formKey.currentState?.validate() ?? false) {
        // For now, we will show a Snackbar to indicate
        // that the form is correct.
        Navigator.pop(context, _controller.text);
      }
    },
    child: const Text('Register'),
  );
}

```

As we can see, in this method we perform form validation, and if successful, we execute `Navigator.pop` returning the content of the text field containing the email.

On the other hand, regarding the button to cancel the dialog, it will be very similar, with the difference that it will not provide any value alongside the context in the `pop` method:

```dart
// Button to cancel the form
Widget createCancelButton(BuildContext context) {
  return TextButton(
    onPressed: () {
      Navigator.pop(context);
    },
    child: const Text(
      'Cancel',
      style: TextStyle(color: Colors.redAccent),
    ),
  );
}

```

### Full-Screen Dialog

In the example, you will see how the dialog containing this form can be created in two ways:

* As a simple dialog, with `return Dialog(...)`, or
* As a full-screen dialog, with `return Dialog.fullscreen(...)`. This line is commented out in the code, but you can try replacing the previous one with this to see the effect.

You can view the complete example with the three types of Dialogs in the following Gist: [https://dartpad.dev/?id=1b5ca965e57012bd287561f9fd516ff2](https://dartpad.dev/?id=1b5ca965e57012bd287561f9fd516ff2).

### References

* Dialog Class Reference: [https://api.flutter.dev/flutter/material/Dialog-class.html](https://api.flutter.dev/flutter/material/Dialog-class.html)
* AlertDialog Class Reference: [https://api.flutter.dev/flutter/material/AlertDialog-class.html](https://api.flutter.dev/flutter/material/AlertDialog-class.html)
* SimpleDialog Class Reference: [https://api.flutter.dev/flutter/material/SimpleDialog-class.html](https://api.flutter.dev/flutter/material/SimpleDialog-class.html)