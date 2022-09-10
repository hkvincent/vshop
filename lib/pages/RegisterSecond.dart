import 'dart:async';

import 'package:flutter/material.dart';
import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import '../services/ScreenAdapter.dart';
import 'dart:async'; //Timer定时器需要引入
import '../config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterSecondPage extends StatefulWidget {
  Map arguments;

  RegisterSecondPage({Key? key, required this.arguments}) : super(key: key);

  _RegisterSecondPageState createState() => _RegisterSecondPageState();
}

class _RegisterSecondPageState extends State<RegisterSecondPage> {
  late String tel;
  bool sendCodeBtn = false;
  int seconds = 10;
  late String code;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.tel = widget.arguments['tel'];
    this._showTimer();
  }

  //倒计时
  _showTimer() {
    Timer t;
    t = Timer.periodic(Duration(milliseconds: 1000), (timer) {
      setState(() {
        this.seconds--;
      });
      if (this.seconds == 0) {
        timer.cancel(); //清除定时器
        setState(() {
          this.sendCodeBtn = true;
        });
      }
    });
  }

  //重新发送验证码
  sendCode() async {
    setState(() {
      this.sendCodeBtn = false;
      this.seconds = 10;
      this._showTimer();
    });
    var api = '${Config.domain}api/sendCode';
    var response = await Dio().post(api, data: {"tel": this.tel});
    if (response.data["success"]) {
      print(response); //演示期间服务器直接返回  给手机发送的验证码
    }
  }

  //验证验证码

  validateCode() async {
    var api = '${Config.domain}api/validateCode';
    var response =
        await Dio().post(api, data: {"tel": this.tel, "code": this.code});
    if (response.data["success"]) {
      Navigator.pushNamed(context, '/registerThird',
          arguments: {"tel": this.tel, "code": this.code});
    } else {
      Fluttertoast.showToast(
        msg: '${response.data["message"]}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Verify Code"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text("Code has been sent to your number ${this.tel}，please input the code"),
            ),
            SizedBox(height: 80),
            Stack(
              children: <Widget>[
                Container(
                  child: JdText(
                    text: "请输入验证码",
                    onChanged: (value) {
                      // print(value);
                      this.code = value;
                    },
                  ),
                  height: ScreenAdapter.height(100),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: this.sendCodeBtn
                      ? ElevatedButton(
                          child: Text('Resend'),
                          onPressed: this.sendCode,
                          style:
                              ElevatedButton.styleFrom(primary: Colors.lightGreen))
                      : ElevatedButton(
                          child: Text('${this.seconds} Seconds'),
                          onPressed: () {},
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green)),
                )
              ],
            ),
            SizedBox(height: 20),
            JdButton(
              text: "next",
              color: Colors.green,
              height: 74,
              cb: this.validateCode,
            )
          ],
        ),
      ),
    );
  }
}
