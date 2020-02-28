import 'dart:io';

import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';
import 'package:humanaty/common/widgets/appbar/appbar.dart';
import 'package:humanaty/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:simple_image_crop/simple_image_crop.dart';
import 'package:humanaty/services/uploader.dart';

class ImageEdit extends StatefulWidget{
  final File file;
  ImageEdit({Key key, this.file}) : super(key: key);
  createState() => _ImageEditState();
}

class _ImageEditState extends State<ImageEdit>{
  final _imageCropKey = GlobalKey<ImgCropState>();
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    _imageFile = widget.file;
    final _auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: HumanatyAppBar(displayBackBtn: true, title: "Crop Image"),      
      body: _buildCropImage(),
      floatingActionButton: cropBtn(_auth),      
    );
  }

  Widget cropBtn(AuthService _auth){
    return RaisedButton(
      color: Pallete.humanGreen,
      child: Text('Crop', style: TextStyle(color: Colors.white, fontSize: 16.0),),
      onPressed:() async{
        var crop = _imageCropKey.currentState;
        File croppedFile = await crop.cropCompleted(_imageFile, pictureQuality: 900);
        await Uploader(uid: _auth.user.uid).uploadProfilePic(croppedFile);
        Navigator.pop(context); 
      },
    );
  }

  Widget _buildCropImage() {
    return Container(
      color: Colors.white,
      child: ImgCrop(
        key: _imageCropKey,
        chipRadius: 150,  
        chipShape: 'circle',
        image: FileImage(_imageFile),
      ),
    );
  } 
}