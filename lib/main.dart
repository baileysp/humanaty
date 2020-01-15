import 'package:flutter/material.dart';

import 'package:humanaty/routes/_router.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Humanaty",
      /*
      TODO:
      Check to see if there is an account logged in to decide whether to navigate to
      Home or Login
      */
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/login': (context) => Login(),
        '/map': (context) => Map(),
        '/settings': (context) => Settings(),
        '/events': (context) => Events(),
        '/registration': (context) => Register()
      },
    );
  }
}