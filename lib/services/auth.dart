import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  FirebaseUser currentUser;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final AuthResult authResult = await _firebaseAuth
          .signInWithCredential(EmailAuthProvider.getCredential(
        email: email,
        password: password,
      ));
      currentUser = authResult.user;
      return authResult.user;
    } catch (error) {
      print(error.toString());
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final AuthResult authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      currentUser = authResult.user;
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
          currentUser = authResult.user;
          return authResult.user;
        }
      }
    } catch (error) {
      print(error.toString());
    }
  }

  // Future<FirebaseUser> currentUser() async {
  //   final FirebaseUser user = await _firebaseAuth.currentUser();
  //   return user;
  // }

  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    return _firebaseAuth.signOut();
  }
}
