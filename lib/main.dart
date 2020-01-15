import 'package:flutter/material.dart';
import 'package:humanaty/routes/home.dart';
import 'package:humanaty/routes/login.dart';
import 'package:humanaty/routes/map.dart';
import 'package:humanaty/routes/settings.dart';
import 'package:humanaty/routes/events.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
        '/events': (context) => Events()
      },
    );
  }
}