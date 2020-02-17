import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:humanaty/models/user.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future<void> createUserDoc(String displayName, String email) async{
    return await userCollection.document(uid).setData({
      'displayName': displayName,
      'email' : email,
      'uid': uid
    });
  }

   // Future<void> updateUserData(String displayName, String photo, String aboutMe, String location, String birthday, List<String> dietaryRestrictions, bool wheelchairRequired) async {
  //   return await userCollection.document(uid).setData({
  //     'displayName' : displayName,
  //     'photo' : photo,
  //     'aboutMe'
  //   }, merge: true);
  // }

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot){
    return UserData(
      uid: uid,
      displayName: snapshot.data['displayName'],
      email: snapshot.data['email']
    );
  }

  Stream<UserData> get userData{
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  
  // Future<void> updateUserData(String displayName, String photo, String aboutMe, String location, String birthday, List<String> dietaryRestrictions, bool wheelchairRequired) async {
  //   return await userCollection.document(uid).setData({
  //     'displayName' : displayName,
  //     'photo' : photo,
  //     'aboutMe'
  //   }, merge: true);
  // }



}