import 'package:flutter/material.dart';
class ChuProvider extends ChangeNotifier {

  bool chu = false;
  void setChu () {
    print('111');
    chu = true;
    notifyListeners();
  }

}