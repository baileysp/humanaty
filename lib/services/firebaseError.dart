import 'package:flutter/services.dart';

String errorConverter(PlatformException error){
  String _errorMessage;
  switch(error.code.toString()){
    case "ERROR_EMAIL_ALREADY_IN_USE":
      _errorMessage = "Looks like you already have a humanaty account.";
      break;
    case "ERROR_WRONG_PASSWORD":
       _errorMessage = "Your email or password was entered incorrectly";
       break;
    case "ERROR_USER_NOT_FOUND":
      _errorMessage = "We couldn't find your humanaty account.";
      break;
    default:
      _errorMessage = "Something went wrong";
  }
  return _errorMessage;
}