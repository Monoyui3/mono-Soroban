import 'package:flutter/cupertino.dart';

class LoginProvider with ChangeNotifier {
  bool isLoggedIn = false;
  String token = '';

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }
  void setToken(String str) {
    token = str;
    notifyListeners();
  }


}