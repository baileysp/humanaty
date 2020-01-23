import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/routes/_router.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Humanaty",
      theme: ThemeData(
        //primaryColor: 
      ),
      
      
      
      
      
      /*
      TODO:
      Check to see if there is an account logged in to decide whether to navigate to
      Home or Login
      */
      initialRoute: '/login',
      routes: {
        '/': (context) => Home(),
        '/login': (context) => LoginPage(),
        '/map': (context) => Map(),
        '/settings': (context) => Settings(),
        '/events': (context) => Events(),
        '/registration': (context) => RegisterPage()
      },
    );
  }
}