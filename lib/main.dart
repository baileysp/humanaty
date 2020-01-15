import 'package:flutter/material.dart';
import 'package:humanaty/home.dart';
import 'package:humanaty/login.dart';

void main() => runApp(MaterialApp(
  title: "Humanaty",
  initialRoute: '/',
  routes: {
    '/': (context) => Home(),
    '/login': (context) => Login()
  },
));

