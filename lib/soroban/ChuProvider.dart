import 'package:flutter/material.dart';
class ChuProvider extends ChangeNotifier {

  bool chu = false;
  void setChu () {
    chu = true;
    notifyListeners();
  }

}