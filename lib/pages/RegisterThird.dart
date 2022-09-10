import 'package:flutter/material.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import '../services/ScreenAdapter.dart';

import '../config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../services/Storage.dart';
import 'dart:convert';
//引入Tabs

import '../pages/tabs/Tabs.dart';

class RegisterThirdPage extends StatefulWidget {
  Map arguments;
  RegisterThirdPage({Key? key, required this.arguments}) : super(key: key);

  _RegisterThirdPageState createState() => _RegisterThirdPageState();
}

class _RegisterThirdPageState extends State<RegisterThirdPage> {
  late String tel;
  late String code;
  String password='';
  String rpassword='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.tel = widget.arguments["tel"];
    this.code = widget.arguments["code"];
  }
  //注册
  doRegister() async {
    if (password.length < 6) {
      Fluttertoast.showToast(
        msg: '密码长度不能小于6位',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else if (rpassword != password) {
      Fluttertoast.showToast(
        msg: '密码和确认密码不一致',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      var api = '${Config.domain}api/register';
      var response = await Dio().post(api, data: {
        "tel": this.tel,
        "code": this.code,
        "password": this.password
      });
      if (response.data["success"]) {
        //保存用户信息   
        Storage.setString('userInfo', json.encode(response.data["userinfo"]));

        //返回到根
        Navigator.of(context).pushAndRemoveUntil(
            new MaterialPageRoute(builder: (context) => new Tabs()),
            (route) => route == null);
      } else {
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
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text("Password"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            JdText(
              text: "Password",
              password: true,
              onChanged: (value) {
                this.password=value;
              },
            ),
            SizedBox(height: 10),
            JdText(
              text: "re-type",
              password: true,
              onChanged: (value) {
                this.rpassword=value;
              },
            ),
            SizedBox(height: 20),
            JdButton(
              text: "Sign Up",
              color: Colors.green,
              height: 74,
              cb: doRegister,
            )
          ],
        ),
      ),
    );
  }
}
