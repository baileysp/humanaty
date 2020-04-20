import 'package:flutter/material.dart';
import 'package:humanaty/routes/_router.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    var args = settings.arguments as Map<String, Object>;

    switch (settings.name) {
      case '/about':
        return MaterialPageRoute(builder: (_) => About());
      case '/aboutMe_edit':
        return MaterialPageRoute(builder: (_) => AboutMeEdit(aboutMe: args['aboutMe']));
     
      case '/allergy_edit':
        return MaterialPageRoute(builder: (_) => AllergyEdit(
          allergyMap: args['allergyMap'],
          updateUserProfile: args['updateUserProfile'] ?? false,
          updateEvent: args['updateEvent'] ?? false,
          eventID: args['eventID'] ?? ''));
      case '/contact':
        return MaterialPageRoute(builder: (_) => Contact());
      case '/create_event':
        return MaterialPageRoute(builder: (_) => CreateEvent(eventDate: args['eventDate'],));
      case '/email_edit':
        return MaterialPageRoute(builder: (_) => EmailEdit(email: args['email']));
      case '/event_info':
        return MaterialPageRoute(builder: (_) => EventInfo(eventID: args['eventID']));
      case '/farm_info':
        return MaterialPageRoute(builder: (_) => FarmInfo(farmID: args['farmID']));
      case '/guest_home':
        return MaterialPageRoute(builder: (_) => GuestRouter());
      case '/host_event_info':
        return MaterialPageRoute(builder: (_) => HostEventInfo(eventID: args['eventID']));
      case '/image_edit':
        return MaterialPageRoute(builder: (_) => ImageEdit(file: args['file']));
      case '/image_options':
        return MaterialPageRoute(builder: (_) => ImageOptions());
      case '/login':
        return MaterialPageRoute(builder: (_) => Login());
      case '/map_events':
        return MaterialPageRoute(builder: (_) => MapEvents(displayBackBtn: args.isNotEmpty ? args['displayBackBtn'] : false));
      case '/map_farms':
        return MaterialPageRoute(builder: (_) => MapFarms());
      case '/meal_edit':
        return MaterialPageRoute(builder: (_) => MealEdit(eventID: args['eventID'], meal: args['meal'],));
      case '/profile':
        return MaterialPageRoute(builder: (_) => Profile());  
      case '/profile_display':
        return MaterialPageRoute(builder: (_) => ProfileDisplay(
          profile: args['profile'],
          guests: args['guests'])); 
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