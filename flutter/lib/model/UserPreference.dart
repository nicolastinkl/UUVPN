//ignore_for_file: file_names

import 'dart:async';
import 'package:flutter/cupertino.dart';
class UserPreference extends ChangeNotifier {

// Initally Location index is 0  
  int locationIndex = 0;

// Change current location by call setlocationIndex method(function) 
  void setlocationIndex(int index) {
    locationIndex = index;
    notifyListeners();
  }


// Setup for coundown service
  Duration duration = Duration.zero;
  bool isCountDownStart = false;
  final Stream _stream = Stream.periodic(const Duration(seconds: 1));

  UserPreference() {
    _stream.listen((event) {
      if (isCountDownStart) {
        duration += const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  void get countDownSwitch {
    isCountDownStart = !isCountDownStart;
    notifyListeners();
  }
}
