import 'package:flutter/material.dart';
import '../services/ScreenAdapter.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';

import '../config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../services/Storage.dart';
import 'dart:convert';

import '../services/EventBus.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //监听登录页面销毁的事件
  dispose() {
    super.dispose();
    eventBus.fire(new UserEvent('登录成功...'));
  }

  String username = '';
  String password = '';

  doLogin() async {
    RegExp reg = new RegExp(r"^1\d{10}$");
    if (!reg.hasMatch(this.username)) {
      Fluttertoast.showToast(
        msg: '手机号格式不对',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else if (password.length < 6) {
      Fluttertoast.showToast(
        msg: '密码不正确',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      var api = '${Config.domain}api/doLogin';
      var response = await Dio().post(api,
          data: {"username": this.username, "password": this.password});
      if (response.data["success"]) {
        print(response.data);
        //保存用户信息
        Storage.setString('userInfo', json.encode(response.data["userinfo"]));

        Navigator.pop(context);
      } else {
        print('error message = ${response.data["message"]}');
        Fluttertoast.showToast(
          msg: '${response.data["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        // title: Text("登录页面"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.people),
              onPressed: () {
                print("cs");
              }),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 5),
                child: AspectRatio(
                    aspectRatio: 16 / 10,
                    child: Image.network(
                        'https://previews.123rf.com/images/ornitopter/ornitopter1510/ornitopter151000171/46712284-lightning-letter-v.jpg',
                        fit: BoxFit.fill)),
                // child: Image.network(
                //     'https://www.itying.com/images/flutter/list5.jpg',
                //     fit: BoxFit.cover),
              ),
            ),
            SizedBox(height: 30),
            JdText(
              text: "User name",
              onChanged: (value) {
                // print(value);
                this.username = value;
              },
            ),
            SizedBox(height: 10),
            JdText(
              text: "Password",
              password: true,
              onChanged: (value) {
                // print(value);
                this.password = value;
              },
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(ScreenAdapter.width(20)),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Forgot password'),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/registerFirst');
                      },
                      child: Text('New Member'),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            JdButton(
              text: "Sign In",
              color: Colors.green,
              height: 68,
              width: 600,
              cb: doLogin,
            )
          ],
        ),
      ),
    );
  }
}
