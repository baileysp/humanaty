
import 'package:flutter/material.dart';

enum Mode{Consumer, Host}

class AppMode with ChangeNotifier{
  //defaults to 'Consumer Mode' on start up, could store user's current mode in database
  //unlikely they will log out and care that it defaults to preference. Not sure what
  //restarting the app will mean for the mode
  Mode _mode = Mode.Consumer;
  
  Mode get mode => _mode;
  bool isConsumerMode() => mode == Mode.Consumer;
  bool isHostMode() => mode == Mode.Host; 
  
  switchMode(){
    if (_mode == Mode.Consumer) _mode = Mode.Host;
    else if (_mode == Mode.Host) _mode = Mode.Consumer;
    notifyListeners();
  }
}