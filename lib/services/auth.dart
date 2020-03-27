import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:humanaty/models/user.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/services/firebase_error.dart';
import 'package:humanaty/util/logger.dart';

enum Status {Uninitialized, Authenticated, Authenticating, Unauthenticated, Anon}

class AuthService with ChangeNotifier {
  final log = getLogger('AuthService');
  final _fbError = FirebaseError();
  
  FirebaseAuth _firebaseAuth;
  User _user;
  Status _status = Status.Uninitialized;
  String _error = '';
  final Duration _timeoutDuration = Duration(seconds: 5);

  AuthService.instance() : _firebaseAuth = FirebaseAuth.instance {
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  Status get status => _status;
  User get user => _user;
  String get error => _error;
  bool isAnonUser() => _status == Status.Anon;

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(uid: user.uid) : null;
  }

  Future<bool> signinAnon() async{
    try {
      await _firebaseAuth.signInAnonymously();
      return true;
    } catch(error){
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password);
      //print(result);  
      return result != null;
    } on PlatformException catch (error) {
      _status = Status.Unauthenticated;
      _error = _fbError.errorString(error);
      notifyListeners();
      _onException('signInWithEmailAndPass', error);
      return false;
    }
  }

  Future<bool> createUserWithEmailAndPassword(String displayName, String email, String password) async {
    displayName = displayName.trim();
    email = email.trim();
    password = password.trim();
    
    try {
      _status = Status.Authenticating;
      notifyListeners();
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password);
      
      //consider removing await
      await DatabaseService(uid: user.uid).createUserDoc(displayName, email);
      return result != null;
    } on PlatformException catch (error) {
      _status = Status.Unauthenticated;
      _error = _fbError.errorString(error);
      notifyListeners();
      _onException('createUserWithEmailAndPass', error);
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      final GoogleSignIn _googleSignIn = GoogleSignIn();

      GoogleSignInAccount googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) {
        googleUser = await _googleSignIn.signIn();
      }

      if (googleUser == null) {
        _status = Status.Unauthenticated;
        _error = "User cancelled";
        notifyListeners();
        return false;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      AuthResult result = await _firebaseAuth.signInWithCredential(credential);
      return result != null;
    } on PlatformException catch (error) {
      _status = Status.Unauthenticated;
      print(error.toString());
      _error = _fbError.errorString(error);
      notifyListeners();
      _onException('signInWithGoogle', error);
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } on PlatformException catch (error) {
      _error = _fbError.errorString(error);
      return false;
    }
  }

  Future signOut() async {
    log.d('Logging Out $_user');
    _firebaseAuth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);

    //final GoogleSignIn googleSignIn = GoogleSignIn();
    //await googleSignIn.signOut();
    //return _firebaseAuth.signOut();
  }

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
      _user = null;
    } else {
      _user = _userFromFirebaseUser(firebaseUser);
      _status = firebaseUser.isAnonymous ? Status.Anon : Status.Authenticated;
      log.d('Logging in $_user');
    }
    notifyListeners();
  }

  _onTimeOut(String methodName){
    log.w('$methodName timed out');
    return null;
  }

  _onException(String methodName, PlatformException error){
    print(error);
    String errorString = error.code.toString();
    log.e('$methodName threw $errorString');
  }

}//User
