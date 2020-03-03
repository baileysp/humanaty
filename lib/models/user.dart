import 'package:enum_to_string/enum_to_string.dart';

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
  //final List<String> consumerEventHistory
  final double consumerRating;
  //final List<String> consumerUpcomingEvents
  final String displayName;
  final String email;
  //final List<String> hostEventHistory
  final double hostRating;
  //final List<String> hostUpcomingEvents
  final bool hostVerified;
  final Map<String, String> location;
  final String photoUrl;
  final String uid;
 
  UserData({
    this.aboutMe,
    this.accessibilityAccommodations,
    this.allergies,
    this.birthday,
    //this.consumerEventHistory,
    this.consumerRating,
    //this.consumerUpcomingEvents,
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
enum Allergens {Eggs, Fish, Milk, Peanut, Shellfish, SoyBean, TreeNut, Wheat}
class Allergy {
  Map<String, bool> allergies;
  final bool hasEggs;
  final bool hasFish;
  final bool hasMilk;
  final bool hasPeanut;
  final bool hasShellFish;
  final bool hasSoyBean;
  final bool hasTreeNut;
  final bool hasWheat;

  Allergy({
    this.hasEggs = false,
    this.hasFish = false,
    this.hasMilk = false,
    this.hasPeanut = false,
    this.hasShellFish = false,
    this.hasSoyBean = false,   
    this.hasTreeNut = false,
    this.hasWheat = false});

  Map get allergyMap {
    allergies = {
      EnumToString.parse(Allergens.Eggs): hasEggs,
      EnumToString.parse(Allergens.Fish): hasFish,
      EnumToString.parse(Allergens.Milk): hasMilk,
      EnumToString.parse(Allergens.Peanut): hasPeanut,
      EnumToString.parse(Allergens.Shellfish): hasShellFish,
      EnumToString.parse(Allergens.SoyBean): hasSoyBean,   
      EnumToString.parse(Allergens.TreeNut): hasTreeNut,
      EnumToString.parse(Allergens.Wheat): hasWheat
    };
    return allergies;
  }
}
