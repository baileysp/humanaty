import 'package:flutter/material.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/routes/_router.dart';

void main() => runApp(Main());

//return StreamProvider<User>.value

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Humanaty",
      
      //home:  ,
      initialRoute: '/login',
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => LoginPage(),
        '/map': (context) => Map(),
        '/settings': (context) => Settings(),
        '/events': (context) => Events(),
        '/registration': (context) => RegisterPage()
      },
    );
  }
}