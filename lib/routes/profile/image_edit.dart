import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_image_crop/simple_image_crop.dart';

import 'package:humanaty/services/auth.dart';
import 'package:humanaty/services/uploader.dart';

class ImageEdit extends StatefulWidget{
  final File file;
  ImageEdit({this.file});

  @override
  _ImageEditState createState() => _ImageEditState();
}

class _ImageEditState extends State<ImageEdit>{
  final _imageCropKey = GlobalKey<ImgCropState>();
  File _imageFile;
  AuthService auth;

  @override
  void initState() {
    _imageFile = widget.file;
    super.initState();
  }  

  @override
  Widget build(BuildContext context) {
    auth = Provider.of<AuthService>(context);
    return Scaffold(   
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _buildCropImage(),
          Container(
            color: Colors.black38,
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _cancel(),
                _crop()
              ],
            ),
          )
        ]
      ),           
    );
  }

  Widget _cancel(){
    return FlatButton(
      child: Text('Cancel', 
        style: TextStyle(color: Colors.white, fontSize: 22)), 
      onPressed:() => Navigator.pop(context, 'cancelled'),);
  }

  Widget _crop(){
    return FlatButton(
      child: Text('Select', style: TextStyle(color: Colors.white, fontSize: 22.0),),
      onPressed:() async{
        Navigator.pop(context);
        var crop = _imageCropKey.currentState;
        File croppedFile = await crop.cropCompleted(_imageFile, pictureQuality: 900);
        Uploader(uid: auth.user.uid).uploadProfilePic(croppedFile);
      },
    );
  }

  Widget _buildCropImage() {
    return Container(
      color: Colors.black,
      child: ImgCrop(
        key: _imageCropKey,
        chipRadius: 150,  
        chipShape: 'circle',
        image: FileImage(_imageFile),
      ),
    );
  } 
}