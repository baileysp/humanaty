import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in anon
  Future signInAnon() async {
    try {
      AuthResult authResult = await _auth.signInAnonymously();
      FirebaseUser user = authResult.user;
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
      return user;
    } catch (error){
      print(error.toString());
      print(email);
      return null;
    } 
  }





}