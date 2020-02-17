import 'package:flutter/material.dart';

String emailValidator(String email){
  var emailValid = !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) ?
                            "Please enter a valid email address" : null;
  return emailValid;
}

String passwordValidator(String password){
  var passValid = password.length < 8 ? "Your password must have at least 8 characters" : null;
  return passValid;
}

String confirmPassValidator(String confirmation, TextEditingController controller){
  String password = controller.text;
  return confirmation == password ? null : "Passwords do not match";
}