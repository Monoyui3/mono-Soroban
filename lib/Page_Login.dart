import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertest/soroban/LoginProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './util.dart';

Widget customTextField({
  required TextEditingController controller,
  required String labelText,
  bool obscureText = false,
}) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
    ),
    obscureText: obscureText,
  );
}
class Page_Login extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // 在登录页面固定屏幕方向为竖屏
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text('中国传统7珠算盘'),
        )
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              '欢迎登录',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            customTextField(
              controller: _usernameController,
              labelText: '用户名',
            ),
            const SizedBox(height: 20),
            customTextField(
              controller: _passwordController,
              labelText: '密码',
              obscureText: true,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;
                // 这里可以添加实际的登录逻辑，例如发送请求到服务器
                print('登录用户名: $username, 密码: $password');

                try {
                  final  response = await Dio().post('http://114.215.187.170:8000/login', data: {
                    'name': username, 'password': password
                  });
                  print("token::${Provider.of<LoginProvider>(context, listen: false).token}");
                  if(response.data["code"] == 200) {
                    //拿到登录token存到本地
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString("token", response.data["token"]);
                    prefs.setBool('isLoggedIn', true);
                    prefs.setInt('loginTime', DateTime.now().millisecondsSinceEpoch);

                    Provider.of<LoginProvider>(context, listen: false).setToken(response.data["token"]);
                    Navigator.pushReplacementNamed(context, '/main');
                  }
                  Utils.showMessage(context, response.data["message"]);
                } catch (error) {
                  Utils.showMessage(context, "登录出错");
                  throw Exception('登录出错: $error');

                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                '登录',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {


                _showRegistrationDialog(context);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Text(
                '注册',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _showRegistrationDialog(BuildContext context) {
  final TextEditingController regUsernameController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('注册'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            customTextField(
              controller: regUsernameController,
              labelText: '用户名',
            ),
            const SizedBox(height: 10),
            customTextField(
              controller: regPasswordController,
              labelText: '密码',
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              String username = regUsernameController.text;
              String password = regPasswordController.text;
              // 这里可以添加实际的注册逻辑，例如发送请求到服务器
              try {
                final  response = await Dio().post('http://114.215.187.170:8000/user', data: {
                  'name': username, 'password': password
                });
                if(response.data["code"] == 200) {
                  Navigator.of(context).pop();
                }
                Utils.showMessage(context, response.data["message"]);
              } catch (error) {
                Utils.showMessage(context, "注册出错");
                throw Exception('注册出错: $error');
              }
              print('注册用户名: $username, 密码: $password');
            },
            child: const Text('注册'),
          ),
        ],
      );
    },
  );
}

//
// void _showMessage(BuildContext context, String message) {
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(message),
//       duration: const Duration(seconds: 5),
//     ),
//   );
// }

// class Page_Login extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     // 在登录页面固定屏幕方向为竖屏
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//           child: const Text('中国传统7珠算盘'),
//         )
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: const InputDecoration(
//                 labelText: '用户名',
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               decoration: const InputDecoration(
//                 labelText: '密码',
//               ),
//               obscureText: true,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 // 简单模拟登录成功
//                 Provider.of<LoginProvider>(context, listen: false).login();
//                 Navigator.pushReplacementNamed(context, '/main');
//               },
//               child: const Text('注册'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 // 简单模拟登录成功
//                 Provider.of<LoginProvider>(context, listen: false).login();
//                 Navigator.pushReplacementNamed(context, '/main');
//               },
//               child: const Text('登录'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
