import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthService with ChangeNotifier{
  FirebaseAuth _firebaseAuth;
  FirebaseUser _user;
  Status _status = Status.Uninitialized;
  
  //final GoogleSignIn googleSignIn = GoogleSignIn();

  AuthService.instance() : _firebaseAuth = FirebaseAuth.instance{
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  FirebaseUser get user => _user;


  


  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (error) {
      _status = Status.Unauthenticated;
      print(error.toString());
      notifyListeners();
      return false;
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final AuthResult authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return authResult.user;
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final AuthResult authResult = await _firebaseAuth
              .signInWithCredential(GoogleAuthProvider.getCredential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ));
          return authResult.user;
        }
      }
    } catch (error) {
      print(error.toString());
    }
  }
  
  Future signOut() async {
    _firebaseAuth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
    
    
    
    //final GoogleSignIn googleSignIn = GoogleSignIn();
    //await googleSignIn.signOut();
    //return _firebaseAuth.signOut();
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async{
    if(firebaseUser == null){
      _status = Status.Unauthenticated;
    } else{
      _user = firebaseUser;
      _status = Status.Authenticated;
    }
    notifyListeners();
  }

}
