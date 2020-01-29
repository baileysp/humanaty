import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          theme: ThemeData(fontFamily: 'Nuninto_Sans'),

          //home: LandingPage(),
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
