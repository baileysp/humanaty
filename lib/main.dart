import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:flutter/services.dart';

void main() => {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //top bar color
      statusBarIconBrightness: Brightness.dark, //top bar icons
      //systemNavigationBarColor: Colors.white, //bottom bar color
      //systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    )
  ),
  runApp(Main())
};

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService.instance(),
      child: Consumer(builder: (context, AuthService user, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Humanaty",
          theme: ThemeData(fontFamily: 'Nuninto_Sans'),

          home: LandingPage(),
          //initialRoute: '/login',
          routes: {
            '/home': (context) => Home(),
            '/login': (context) => LoginPage(),
            '/map': (context) => Map(),
            '/settings': (context) => Settings(),
            '/events': (context) => Events(),
            '/registration': (context) => RegisterPage()
          },
        );
      }),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthService>(context);
    switch (user.status) {
      case Status.Uninitialized:
        //splash scren
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginPage();
      case Status.Anon:
      case Status.Authenticated:
        return Home();
    }
  }
}
