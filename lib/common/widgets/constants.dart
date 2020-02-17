import 'package:flutter/material.dart';
import 'package:humanaty/common/design.dart';

const textInputDecoration = InputDecoration(
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Pallete.humanGreen, width: 2.0)
  )
);

String emailValidator(String email){
  var emailValid = !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) ?
                            "Please enter a valid email address" : null;
  return emailValid;
}

String passwordValidator(String password){
  var passValid = password.length < 8 ? "Your password must have at least 8 characters" : null;
  return passValid;
}

String confirmpassValidator(String confirmation, TextEditingController controller){
  String password = controller.text;
  return confirmation == password ? null : "Passwords do not match";
}