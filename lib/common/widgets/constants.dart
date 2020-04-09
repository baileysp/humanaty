import 'package:flutter/material.dart';

import 'package:humanaty/common/design.dart';

const textInputDecoration = InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
    filled: true,
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Pallete.humanGreen, width: 2.0)));

const eventInputDecoration = InputDecoration(
    border: InputBorder.none,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent, width: 2.0)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    errorStyle: TextStyle(height: 0.0),
    filled: true,
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Pallete.humanGreen, width: 2.0)));

const errorBorderOutline =
    UnderlineInputBorder(borderSide: BorderSide(color: Colors.red));
