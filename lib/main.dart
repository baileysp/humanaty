import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:humanaty/common/widgets.dart';
import 'package:humanaty/services/auth.dart';
import 'package:humanaty/routes/_router.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';



void main() {
  Logger.level = Level.verbose;
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      //statusBarColor: Colors.transparent, //top bar color
      //statusBarIconBrightness: Brightness.dark, //top bar icons
      //systemNavigationBarColor: Colors.white, //bottom bar color
      //systemNavigationBarIconBrightness: Brightness.dark, //bottom bar icons
    ));
  runApp(Main());
}

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
          routes: {
            '/home': (context) => BottomNavBarRouter(),
            '/login': (context) => LoginPage(),
            '/map': (context) => Map(),
            '/settings': (context) => Settings(),
            '/events': (context) => Events(),
            '/registration': (context) => RegisterPage(),
            //'/profile' : (context) => Profile()
            //'/imageEdit' : (context) => ImageEdit(),
          },
        );
      }),
    );
  }
}

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<AuthService>(context);
    switch (_auth.status) {
      case Status.Uninitialized:
        return Loading();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return LoginPage();
      case Status.Anon:
      case Status.Authenticated:
        return BottomNavBarRouter();
    }
  }
}
