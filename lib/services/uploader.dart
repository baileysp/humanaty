import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:humanaty/services/database.dart';

class Uploader{
  final String uid;
  Uploader({Key key, this.uid});


  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://humanaty-gatech.appspot.com');
  

  Future<void> test()async{
    print("hello");
    String filePath = 'defaultProfilePic/defaultProfilePic.jpg';
    var storageRef = _storage.ref().child(filePath);
    var url = await storageRef.getDownloadURL() as String;
    print(url);

  }
  
  Future<void> uploadProfilePic(File imageFile) async {
    String filePath = 'users/$uid/profilePicture.png';
    var storageRef = _storage.ref().child(filePath);
    storageRef.putFile(imageFile);
    print("uploading profile picture");
    var url = await storageRef.getDownloadURL().timeout(Duration(seconds: 5)) as String;
    DatabaseService(uid: uid).updateProfilePic(url);
  } 
}

