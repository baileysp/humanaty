import 'package:flutter/material.dart';
import 'package:humanaty/home.dart';
import 'package:humanaty/login.dart';
import 'package:humanaty/map.dart';
import 'package:humanaty/settings.dart';
import 'package:humanaty/events.dart';

void main() => runApp(MaterialApp(
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
));

