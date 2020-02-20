import 'package:enum_to_string/enum_to_string.dart';

class User {
  final String uid;
  User({this.uid});
}

class UserData {
  final String uid;
  final String displayName;
  final String email;
  final String photo;
  final String aboutMe;
  final String location;
  final String birthday;
  final Map<String, bool> allergies;

  //currently limited to wheelChairAccessibility, can be expanded in future
  bool accessibilityAccommodations;
  final int consumerRating;
  final int chefRating;
  //Allergy allergies;
  //event list
  //final List<Event> eventHistory
  //final List<Event> upcomingEvents

  //information 4 Host
  //final bool hostVerified;

  UserData(
      {this.uid,
      this.displayName,
      this.email,
      this.photo,
      this.aboutMe = "This is an about me test",
      this.location,
      this.birthday,
      this.allergies,
      this.accessibilityAccommodations,
      this.consumerRating = 3,
      this.chefRating = 3});
}

enum Allergies { SoyBean, Fish, Milk, TreeNut, Peanut, Shellfish, Eggs, Wheat}
String test;

class Allergy {
  Map<String, bool> allergies;
  final bool hasSoyBean;
  final bool hasFish;
  final bool hasMilk;
  final bool hasTreeNut;
  final bool hasPeanut;
  final bool hasShellFish;
  final bool hasEggs;
  final bool hasWheat;

  Allergy(
      {this.hasSoyBean = false,
      this.hasFish = false,
      this.hasMilk = false,
      this.hasTreeNut = false,
      this.hasPeanut = false,
      this.hasShellFish = false,
      this.hasEggs = false,
      this.hasWheat = false});

  Map get allergyMap {
    allergies = {
      EnumToString.parse(Allergies.SoyBean): hasSoyBean,
      EnumToString.parse(Allergies.Fish): hasFish,
      EnumToString.parse(Allergies.Milk): hasMilk,
      EnumToString.parse(Allergies.TreeNut): hasTreeNut,
      EnumToString.parse(Allergies.Peanut): hasPeanut,
      EnumToString.parse(Allergies.Shellfish): hasShellFish,
      EnumToString.parse(Allergies.Eggs): hasEggs,
      EnumToString.parse(Allergies.Wheat): hasWheat
    };
    return allergies;
  }
}
