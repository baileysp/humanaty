class User {
  final String uid;
  User({this.uid});
}

class UserData{
  final String uid;
  final String displayName;
  final String email;
  final String photo;
  final String aboutMe;
  final String location;
  final String birthday;
  final List<String> dietaryRestrictions;
  final bool wheelchairRequired;
  final int consumerRating;
  final int chefRating;
  //event list
  //final List<Event> eventHistory
  //final List<Event> upcomingEvents

  //information 4 Host
  //final bool hostVerified;
  
  UserData(
    {
      this.uid,
      this.displayName,
      this.email,
      this.photo,
      this.aboutMe = "This is an about me test",
      this.location,
      this.birthday,
      this.dietaryRestrictions,
      this.wheelchairRequired,
      this.consumerRating = 3,
      this.chefRating = 3
    }
  );

}