import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:humanaty/services/database.dart';
import 'package:humanaty/util/logger.dart';

class Uploader{
  final log = getLogger('ImageUploader');
  final String uid;
  Uploader({Key key, this.uid});

  final FirebaseStorage _storage = FirebaseStorage(storageBucket: 'gs://humanaty-gatech.appspot.com');
  
  Future<void> uploadProfilePic(File imageFile) async {
    String filePath = 'users/$uid/profilePicture.png';
    StorageReference storageRef = _storage.ref().child(filePath);
    storageRef.putFile(imageFile);
    String url = await storageRef.getDownloadURL() as String;
    if(url != null) 
      log.v('Uploaded Profile Pic successfully');
      DatabaseService(uid: uid).updateProfilePic(url);
  }

  _onTimeOut(){
    print('Uploading profilePic timed out');
    return null;}


}//Uploader

