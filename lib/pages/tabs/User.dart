//https://material.io/tools/icons/?icon=favorite&style=baseline

import 'package:flutter/material.dart';
import 'package:flutter_jdshop/widget/JdButton.dart';
import '../../services/ScreenAdapter.dart';
import '../../services/UserServices.dart';
import '../../services/EventBus.dart';
import 'package:flutter/services.dart';

class UserPage extends StatefulWidget {
  UserPage({Key? key}) : super(key: key);

  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool isLogin = false;
  List userInfo = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getUserinfo();

    //监听登录页面改变的事件
    eventBus.on<UserEvent>().listen((event) {
      print(event.str);
      this._getUserinfo();
    });
  }

  _getUserinfo() async {
    var isLogin = await UserServices.getUserLoginState();
    var userInfo = await UserServices.getUserInfo();

    setState(() {
      this.userInfo = userInfo;
      this.isLogin = isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("用户中心"),
        // ),
        body: ListView(
          children: <Widget>[
            Container(
              height: ScreenAdapter.height(220),
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/user_bg.jpg'),
                      fit: BoxFit.cover)),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ClipOval(
                      child: Image.asset(
                        'images/user.png',
                        fit: BoxFit.cover,
                        width: ScreenAdapter.width(100),
                        height: ScreenAdapter.width(100),
                      ),
                    ),
                  ),
                  !this.isLogin
                      ? Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: Text("Sign In/Up",
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      : Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Username：${this.userInfo[0]["username"]}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenAdapter.size(32))),
                              Text("Green Member",
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: ScreenAdapter.size(24))),
                            ],
                          ),
                        )
                ],
              ),
            ),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              leading: Icon(Icons.assignment, color: Colors.red),
              title: Text("Order History"),
              onTap: () {
                Navigator.pushNamed(context, '/order');
              },
            ),
            Divider(),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              leading: Icon(Icons.payment, color: Colors.green),
              title: Text("Pay"),
            ),
            Divider(),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              leading: Icon(Icons.local_car_wash, color: Colors.orange),
              title: Text("Ship"),
            ),
            Container(
                width: double.infinity,
                height: 10,
                color: Color.fromRGBO(242, 242, 242, 0.9)),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              leading: Icon(Icons.favorite, color: Colors.lightGreen),
              title: Text("My Favor"),
            ),
            Divider(),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              leading: Icon(Icons.people, color: Colors.black54),
              title: Text("Customer Service"),
            ),
            Divider(),
            this.isLogin
                ? Container(
                    margin: EdgeInsets.only(top:20),
                    padding: EdgeInsets.all(20),
                    child: JdButton(
                      color: Colors.lightGreen,
                      text: "Sign Out",
                      width: 600,
                      cb: () {
                        UserServices.loginOut();
                        this._getUserinfo();
                      },
                    ),
                  )
                : Text("")
          ],
        ));
  }
}
