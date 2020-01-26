import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:flutter/services.dart';

void main() => {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      systemNavigationBarColor: Colors.white, //bottom bar color
      systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    )
  ),
  runApp(Main())
};

//return StreamProvider<User>.value

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Humanaty",
      //theme: ThemeData(fontFamily: 'Nuninto_Sans'),
      
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