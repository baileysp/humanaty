import 'package:humanaty/models/models.dart';
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

  formattedString(Map<String, bool> map){
    List<String> allergyList = List();
    map.forEach((k, v){if(v) allergyList.add(k);});
    String formattedString = '';

    for(int i = 0; i < allergyList.length; i++){
      if(formattedString.length < 40){
         formattedString += allergyList[i];
         if(i < allergyList.length - 1) formattedString += ', ';
      }
      else{
        formattedString += '...';
        break;
      }
    }
    
    return allergyList.isNotEmpty ? formattedString : 'No Allergies';
  }
}

