import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';

const textInputDecoration = InputDecoration(
  filled: true,
  //fillColor: Colors.grey,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Pallete.humanGreen, width: 2.0)
  )
);