import 'package:flutter/material.dart';
import 'package:humanaty/routes/_router.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    var args = settings.arguments as Map<String, Object>;

    switch (settings.name) {
      case '/aboutMe_edit':
        return MaterialPageRoute(builder: (_) => AboutMeEdit(aboutMe: args['aboutMe']));
     
      case '/allergy_edit':
        //args = args as Map<String, Object>;
        
        //print(args.runtimeType);
        return MaterialPageRoute(builder: (_) => AllergyEdit(allergyMap: args['allergyMap']));
      case '/create_event':
        return MaterialPageRoute(builder: (_) => CreateEvent());
      case '/email_edit':
        return MaterialPageRoute(builder: (_) => EmailEdit(email: args['email']));
      case '/guest_home':
        return MaterialPageRoute(builder: (_) => GuestRouter());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/map':
        return MaterialPageRoute(builder: (_) => MapPage());
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());  
      case '/register':
        return MaterialPageRoute(builder: (_) => Register());
      case '/settings':
        return MaterialPageRoute(builder: (_) => Settings());  
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}