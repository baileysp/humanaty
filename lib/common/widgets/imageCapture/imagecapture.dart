import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (_imageFile != null)
            Container(
                padding: EdgeInsets.all(32.0), child: Image.file(_imageFile)),
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
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ),
          Divider(),
          Container(
            width: double.infinity,
            height: 50,
            child: RaisedButton(
              child: Text("Cancel",
                  style:
                      TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource imagesource) async {
    File selected = await ImagePicker.pickImage(source: imagesource);
    setState(() {
      _imageFile = selected;
    });
  }
}
