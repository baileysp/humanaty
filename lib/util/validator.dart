import 'package:flutter/material.dart';

String nameValidator(String displayName){
  String nameValid = (displayName == null || !displayName.isNotEmpty) ? "Your name cannot be blank" : null;
  return nameValid;
}

String emailValidator(String email){
  String emailValid = !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email) ?
                            "Please enter a valid email address" : null;
  return emailValid;
}

String passwordValidator(String password){
  String passValid = password.length < 8 ? "Your password must have at least 8 characters" : null;
  return passValid;
}

String confirmPassValidator(String confirmation, TextEditingController controller){
  String password = controller.text;
  return confirmation == password ? null : "Passwords do not match";
}

String notEmpty(String text){
  return text.isEmpty ? '' : null;
}

String notZero(String number){
  if(number.isEmpty) return '';
  return (double.parse(number) == 0) ? '' : null;
}
