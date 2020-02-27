import 'dart:io';

import 'package:flutter/material.dart';
import 'package:humanaty/routes/_router.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';

class ImageOptions extends StatefulWidget {
  _ImageOptionsState createState() => _ImageOptionsState();
}

class _ImageOptionsState extends State<ImageOptions>{
  File _imageFile;

  Widget build(BuildContext context) {      
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 50,
            child: RaisedButton(
              child: Text("Take Photo", style: TextStyle(fontSize: 16.0)),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: RaisedButton(
              child: Text("Select Photo", style: TextStyle(fontSize: 16.0)),
              onPressed: () async {
                await _pickImage(ImageSource.gallery);
                await Navigator.push(context,MaterialPageRoute(builder: (context) => ImageEdit(file: _imageFile)),);
                Navigator.pop(context);
                },
            ),
          ),
          Divider(),
          Container(
            width: double.infinity,
            height: 50,
            child: RaisedButton(
              child: Text("Cancel", style:TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource imagesource) async{
    File selected = await ImagePicker.pickImage(source: imagesource);
    print("image selected");
    setState(() {
      _imageFile = selected;
    });
  }

}
