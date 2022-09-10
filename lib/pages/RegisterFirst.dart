import 'package:flutter/material.dart';

import '../widget/JdText.dart';
import '../widget/JdButton.dart';
import '../services/ScreenAdapter.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterFirstPage extends StatefulWidget {
  RegisterFirstPage({Key? key}) : super(key: key);

  _RegisterFirstPageState createState() => _RegisterFirstPageState();
}

class _RegisterFirstPageState extends State<RegisterFirstPage> {
  String tel="";
  sendCode() async {
    RegExp reg = new RegExp(r"^1\d{10}$");
    if (reg.hasMatch(this.tel)) {
      var api = '${Config.domain}api/sendCode';
      var response = await Dio().post(api, data: {"tel": this.tel});
      if (response.data["success"]) {

        print(response);  //演示期间服务器直接返回  给手机发送的验证码

        Navigator.pushNamed(context, '/registerSecond',arguments: {
          "tel":this.tel
        });
        
      } else {
        print('error message = ${response.data["message"]}');
        Fluttertoast.showToast(
          msg: '${response.data["message"]}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: '手机号格式不对',
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
        title: Text("Phone Number"),
      ),
      body: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            JdText(
              text: "Your Phone Number",
              onChanged: (value) {
                // print(value);
                this.tel = value;
              },
            ),
            SizedBox(height: 20),
            JdButton(
              text: "Next",
              color: Colors.green,
              height: 74,
              cb: sendCode,
            )
          ],
        ),
      ),
    );
  }
}
