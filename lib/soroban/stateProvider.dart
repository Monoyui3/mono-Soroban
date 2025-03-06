import 'package:flutter/material.dart';

class CountProvider extends ChangeNotifier {
  List<String> values = [];
  List<List<List<bool>>> kzArray = [];
  List<List<bool>> array = List.generate(13, (i) {
    return List.generate(7, (index) {
      return false;
    });
  });
  void deleteValue(index) {
    values.removeAt(index);
    kzArray.removeAt(index);
    notifyListeners();
  }
  void updateArrayValue(int row, int col, bool newValue) {
    if (row >= 0 && row < array.length && col >= 0 && col < array[row].length) {
      array[row][col] = newValue;
      // 通知所有监听器状态已改变
      notifyListeners();
    }
  }
  void updateKzArrayValue() {
    List<List<bool>> newArray =  List.generate(13, (i) {
      return List.generate(7, (index) {
        return false;
      });
    });;
    for(int i =0;i<13;i++) {
      for(int j =0;j<7;j++) {
        newArray[i][j] = array[i][j];
      }
    }
    kzArray.add(newArray);
    print("updateKzArrayValue");
    if(kzArray.length >=1)   print(kzArray[0]);
    if(kzArray.length >=2) print(kzArray[1]);

  }
  void hositoryClicked (index) {
    List<List<bool>> newArray =  List.generate(13, (i) {
      return List.generate(7, (index) {
        return false;
      });
    });;
    for(int i =0;i<13;i++) {
      for(int j =0;j<7;j++) {
        newArray[i][j] = kzArray[index][i][j];
      }
    }
    array = newArray;
    notifyListeners();
    print("hositorytab");
    print(array);
  }
  void setOffsetsArray () {
    print('111');
    print(array);
    for(int i = 0;i<13;i++) {
      for(int j =0;j<7;j++) {
        array[i][j] =false;
      }
    }
    notifyListeners();
  }

}


