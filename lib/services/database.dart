import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/util/logger.dart';

class DatabaseService{
  final log = getLogger('DatabaseService');
  final String uid;
  DatabaseService({this.uid});

  //final databaseReference = Firestore.instance;
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference eventCollection = Firestore.instance.collection('events');

  Stream<UserData> get userData => userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
   
  Future<void> createUserDoc(String displayName, String email) async{
    String currentYMD = DateTime.now().toString();
    return await userCollection.document(uid).setData({
      'aboutMe' : 'Tell future guests about your qualifications',
      'accessibilityAccommodations' : false,
      'allergies' : [],
      'birthday' : currentYMD.substring(0, currentYMD.indexOf(' ')),
      'consumerRating' : 5,
      'displayName': displayName,
      'email' : email,
      'hostRating' : 5,
      'photoUrl' : 'https://firebasestorage.googleapis.com/v0/b/humanaty-gatech.appspot.com/o/defaultProfilePic%2FdefaultProfilePic.jpg?alt=media&token=e87a7526-daf8-4466-b186-e8703b1da31b',
      'uid': uid
    });
  }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      aboutMe: snapshot.data['aboutMe'],
      accessibilityAccommodations: snapshot.data['accessibilityAccommodations'],
      allergies: Allergy().allergyMapFromList(snapshot.data['allergies'].cast<String>()),
      birthday: DateTime.parse(snapshot.data['birthday']),
      guestRating: snapshot.data['guestRating'].toDouble(),
      displayName: snapshot.data['displayName'],
      email: snapshot.data['email'],
      hostRating: snapshot.data['hostRating'].toDouble(),
      photoUrl: snapshot.data['photoUrl'],
      uid: uid,        
    );
  }

  Future<void> updateUserData(String aboutMe, bool accessibilityAccommodations, DateTime birthday,
    String displayName) async{
    String _birthday = birthday.toString();
    return await userCollection.document(uid).updateData({
      'aboutMe': aboutMe.trim(),
      'accessibilityAccommodations': accessibilityAccommodations,
      'birthday' : _birthday.substring(0, _birthday.indexOf(" ")),
      'displayName' : displayName.trim(),
    });
  }
    
  Future<void> updateAllergyData(Map<String, bool> userAllergies) async{
    return await userCollection.document(uid).updateData({
      'allergies' : Allergy().allergyListFromMap(userAllergies)
    });
  }

  Future<void> updateProfilePic(String url) async{
    await userCollection.document(uid).updateData({
      'photoUrl' : url
    });
  }

}//Database Service