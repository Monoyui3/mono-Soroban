import 'package:flutter/material.dart';

class kzArrayProvider extends ChangeNotifier {
  bool kzClick = false;
  List<List<bool>> currentArray = List.generate(13, (i) {
    return List.generate(7, (index) {
      return false;
    });
  });
  List<bool> getUp(horIndex) {
    List<bool> res = [];
    for(int i =0;i<2;i++) {
      bool n =currentArray[horIndex][i+5];
      res.add(n);
    }
    return res;
  }
  List<bool> getDown(horIndex) {
    List<bool> res = [];
    for(int i =0;i<5;i++) {
      bool n = currentArray[horIndex][i];
      res.add(n);
    }
    return res;
  }
  void setKzClick () {
    kzClick = true;
  }
  void setCurrentArray(List<List<bool>> kz) {
    List<List<bool>> newArray =  List.generate(13, (i) {
      return List.generate(7, (index) {
        return false;
      });
    });;
    for(int i =0;i<13;i++) {
      for(int j =0;j<7;j++) {
        newArray[i][j] = kz[i][j];
      }
    }
    currentArray = newArray;
    setKzClick();
    print("111111");
    print(currentArray);
    notifyListeners();
  }
}