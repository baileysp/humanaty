import 'package:flutter/material.dart';
import 'package:humanaty/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }




  //sign in anon
  Future<User> signInAnon() async {
    try {
      AuthResult authResult = await _auth.signInAnonymously();
      User user = _userFromFirebaseUser(authResult.user);
      
      //FirebaseUser user = authResult.user; 
      return user;
    
    } catch (error){
      print(error.toString());
      return null;
    }
  }




  //sign in with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      final user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print(user);
      return user;
    } catch (error){
      print(error.toString());
      print(email);
      return null;
    } 
  }





}