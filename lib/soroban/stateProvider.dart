import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertest/util.dart';

class CountProvider extends ChangeNotifier {
  List<int> id = [];
  List<String> values = [];
  List<List<List<bool>>> kzArray = [];
  List<List<bool>> array = List.generate(13, (i) {
    return List.generate(7, (index) {
      return false;
    });
  });
  void deleteValue(index) {
    id.removeAt(index);
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
  }
  void setOffsetsArray () {
    for(int i = 0;i<13;i++) {
      for(int j =0;j<7;j++) {
        array[i][j] =false;
      }
    }
    notifyListeners();
  }

  Future<String> fetchValuesAndKzArray(String token, BuildContext context) async {
    print("fetchValuesANDKAZARERAY");
    print(token);
    String message = "";
    try {
      Dio dio = Dio();
      // 创建一个包含 token 的请求头
      Options options = Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      // 发送携带 token 的请求
      Response response = await dio.get('http://114.215.187.170:8000/history', options: options);

      if(response.data["code"] == 200 && response.data["data"].length != 0)  {
        message="历史记录获取成功";
        Utils.showMessage(context, message);
        print(response.data["data"]);
        print(response.data["data"].runtimeType);
        List<dynamic> valueArray = response.data["data"];
        List<String> date = [];
        List<List<List<bool>>> state = [];
        for(int i =0;i<valueArray.length;i++) {
          id.add(valueArray[i]["id"]);
          date.add(valueArray[i]["history_date"]);
          List<dynamic> twoDArray =  json.decode(valueArray[i]["history_state"]);
          List<List<bool>> intTwoDArray = twoDArray.map((innerList) => List<bool>.from(innerList)).toList();
          state.add(intTwoDArray);
        }
        values = date;
        kzArray = state;
        notifyListeners();
        print("-------------------------");
      }
    } catch (error) {
      message="历史记录获取失败";
      Utils.showMessage(context, message);
      throw Exception('history出错: $error');
    }
    return message;
  }

 Future<bool>  addValuesAndKzArrayToSql(String token, BuildContext context, String currentStr) async {
    bool success = false;
    try {
      Dio dio = Dio();
      // 创建一个包含 token 的请求头
      Options options = Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      // 发送携带 token 的请求
      Response response = await dio.post('http://114.215.187.170:8000/history', options: options, data: {
        "history_date": currentStr,
        "history_state": array
      });
      if(response.statusCode == 200) {
        success = true;
        Utils.showMessage(context, "history添加成功");
      }
      print(response);
      id.add(response.data["data"]["insertId"]);
    } catch (error) {
      throw Exception('history添加出错: $error');
    }
    return success;
  }

  Future<void> deleteValuesAndKzArrayToSql(index, String token) async {
    try {
      Dio dio = Dio();
      // 创建一个包含 token 的请求头
      Options options = Options(
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      // 发送携带 token 的请求
      Response response = await dio.post('http://114.215.187.170:8000/history/delect', options: options, data: {
        "delectId": id[index]
      });
      print(response);
    } catch (error) {
      throw Exception('history 删除出错: $error');
    }
  }
}


