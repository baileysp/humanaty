import 'package:flutter/material.dart';

import 'package:humanaty/routes/routes.dart' as Routes;

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
        '/': (context) => Routes.Home(),
        '/login': (context) => Routes.Login(),
        '/map': (context) => Routes.Map(),
        '/settings': (context) => Routes.Settings(),
        '/events': (context) => Routes.Events()
      },
    );
  }
}