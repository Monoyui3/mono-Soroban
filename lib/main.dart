import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/soroban/LoginProvider.dart';
import 'package:fluttertest/soroban/kuaizhao.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Page_Login.dart';
import 'Page_Soroban.dart';
import 'soroban.dart';
import './value.dart';
import './soroban/stateProvider.dart';
import 'soroban/ChuProvider.dart';
import 'jilvs.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool hasToken = await checkLoginStatus();

  LoginProvider loginProvider = LoginProvider();
  if(hasToken) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    loginProvider.setToken(token!);
  }
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => CountProvider()),
      ChangeNotifierProvider(create: (ctx) => ChuProvider()),
      ChangeNotifierProvider(create: (ctx) => kzArrayProvider()),
      ChangeNotifierProvider.value(value: loginProvider),
    ],
    child: MaterialApp(
      initialRoute: hasToken ? "/main" : '/',
      routes: {
        "/": (ctx) =>  Page_Login(),
        '/main': (ctx) => Page_Soroban()
      },
    ),

  ));
}

Future<bool> checkLoginStatus() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  if (isLoggedIn) {
    int loginTime = prefs.getInt('loginTime') ?? 0;
    DateTime currentTime = DateTime.now();
    DateTime lastLoginTime = DateTime.fromMillisecondsSinceEpoch(loginTime);
    Duration duration = currentTime.difference(lastLoginTime);
    if (duration.inHours < 1000) {
      return true;
    } else {
      prefs.setBool('isLoggedIn', isLoggedIn);
      prefs.setString('token', "");
      return false;
    }
  }
  return false;
}