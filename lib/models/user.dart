import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:google_maps_webservice/places.dart';

class User {
  final String uid;
  User({this.uid});

  @override
  String toString() => uid;
}

class UserData {
  final String aboutMe;
  final bool accessibilityAccommodations;
  final Map<String, bool> allergies;
  final DateTime birthday;
  //final List<String> guestEventHistory
  final double guestRating;
  //final List<String> guestUpcomingEvents
  final String displayName;
  final String email;
  //final List<String> hostEventHistory
  final double hostRating;
  //final List<String> hostUpcomingEvents
  final bool hostVerified;
  final HumanatyLocation location;
  final String photoUrl;
  final String uid;

  UserData(
      {this.aboutMe,
      this.accessibilityAccommodations,
      this.allergies,
      this.birthday,
      //this.guestEventHistory,
      this.guestRating,
      //this.guestUpcomingEvents,
      this.displayName,
      this.email,
      //this.hostEventHistory,
      this.hostRating,
      //this.hostUpcomingEvents,
      this.hostVerified,
      this.location,
      this.photoUrl,
      this.uid});

  @override
  String toString() => '$displayName $uid';
}

class Allergy {
  allergyMapFromList(List<String> list) {
    return {
      'Eggs': list.contains("eggs"),
      'Fish': list.contains("fish"),
      'Milk': list.contains("milk"),
      'Peanut': list.contains("peanut"),
      'ShellFish': list.contains("shellfish"),
      'SoyBean': list.contains("soybean"),
      'TreeNut': list.contains("treenut"),
      'Wheat': list.contains("wheat")
    };
  }
  
  allergyListFromMap(Map<String, bool> map){
    List<String> allergyList = List();
    map.forEach((k, v){if(v) allergyList.add(k.toLowerCase());});
    return allergyList;
  }
}

class HumanatyLocation {
  final String address;
  final String city;
  final GeoPoint geoPoint;  
  final String state;
  final int zip;
  
  HumanatyLocation({
    this.address,
    this.city,
    this.geoPoint = const GeoPoint(0, 0),  
    this.state,  
    this.zip
  });

  humanantyLocationFromMap(Map<dynamic, dynamic> location){
    return HumanatyLocation(
      address: location['address'].toString(),
      city: location['city'].toString(),
      geoPoint: location['coordinates'],
      state: location['state'],
      zip: location['zip']
    );
  }
  
  @override
  String toString() => '${geoPoint.latitude} + ${geoPoint.longitude}';

}