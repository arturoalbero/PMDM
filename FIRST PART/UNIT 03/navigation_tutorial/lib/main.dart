import 'package:flutter/material.dart';
import 'package:navigation_tutorial/screens/screen_1.dart';
import 'package:navigation_tutorial/screens/screen_2.dart';
import 'package:navigation_tutorial/screens/screen_3.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: [
            const Text("Screen 1"),
            const Text("Screen 2"),
            const Text("Screen 3"),
          ][currentIndex],
        ),
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentIndex = index;
            });
          },
          selectedIndex: currentIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.people),
              selectedIcon: Icon(Icons.people_outline),
              label: "S1",
            ),
            NavigationDestination(
              icon: Icon(Icons.people),
              selectedIcon: Icon(Icons.people_outline),
              label: "S2",
            ),
            NavigationDestination(
              icon: Icon(Icons.people),
              selectedIcon: Icon(Icons.people_outline),
              label: "S3",
            ),
          ],
        ),
        body: <Widget>[
          Center(child: Screen1()),
          Center(child: Screen2()),
          Center(child: Screen3())
        ][currentIndex]
      ),
    );
  }
}
