import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/ScreenAdapter.dart';
import '../config/Config.dart';
import 'package:dio/dio.dart';

//订单列表数据模型
import '../model/OrderModel.dart';

import '../services/UserServices.dart';
import '../services/SignServices.dart';

class OrderPage extends StatefulWidget {
  OrderPage({Key? key}) : super(key: key);

  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  List _orderList = [];
  List _horizontalTextList = [
    'ALL',
    "Processing",
    "Shipping",
    "Finished",
    "Cancelled"
  ];
  int indicator = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._getListData();
  }

  void _getListData() async {
    List userinfo = await UserServices.getUserInfo();

    var tempJson = {"uid": userinfo[0]['_id'], "salt": userinfo[0]["salt"]};

    var sign = SignServices.getSign(tempJson);

    var api =
        '${Config.domain}api/orderList?uid=${userinfo[0]['_id']}&sign=${sign}';

    var response = await Dio().get(api);
    print(response.data is Map);

    setState(() {
      var orderMode = new OrderModel.fromJson(response.data);

      this._orderList = orderMode.result;

      this._orderList = this._orderList.reversed.toList();

      print(this._orderList[0].name);
    });
  }

  //自定义商品列表组件

  List<Widget> _orderItemWidget(orderItems) {
    List<Widget> tempList = [];
    for (var i = 0; i < orderItems.length; i++) {
      tempList.add(Column(
        children: <Widget>[
          SizedBox(height: 10),
          ListTile(
            leading: Container(
              width: ScreenAdapter.width(120),
              height: ScreenAdapter.height(120),
              child: Image.network(
                '${orderItems[i].productImg}',
                fit: BoxFit.cover,
              ),
            ),
            title: Text("${orderItems[i].productTitle}"),
            trailing: Text('x${orderItems[i].productCount}'),
          ),
          SizedBox(height: 10)
        ],
      ));
    }
    return tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Order"),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(0, ScreenAdapter.height(80), 0, 0),
            padding: EdgeInsets.all(ScreenAdapter.width(16)),
            child: ListView(
                children: this._orderList.map((value) {
                  print(value);
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/orderinfo',
                      arguments: {'order': value});
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text("Order No.：${value.sId}",
                            style: TextStyle(color: Colors.black54)),
                      ),
                      Divider(),
                      Column(
                        children: this._orderItemWidget(value.orderItem),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        leading: Text("Total：￥${value.allPrice}"),
                        trailing: FlatButton(
                          child: Text("Customer Service"),
                          onPressed: () {},
                          color: Colors.grey[100],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList()),
          ),
          Positioned(
            top: 0,
            width: ScreenAdapter.width(750),
            height: ScreenAdapter.height(76),
            child: Container(
                width: ScreenAdapter.width(750),
                height: ScreenAdapter.height(76),
                color: Colors.white,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _horizontalTextList.length,
                    itemBuilder: (contxt, index) {
                      return Container(
                          padding: EdgeInsets.fromLTRB(ScreenAdapter.height(50),
                              ScreenAdapter.height(30), 0, 0),
                          child: this.indicator == index
                              ? Text(_horizontalTextList[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blue))
                              : Text(_horizontalTextList[index],
                                  textAlign: TextAlign.center));
                    })

                /*    Row(
                children: <Widget>[
                  Expanded(
                    child: Text("All", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("Processing", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("Shipping", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("Finished", textAlign: TextAlign.center),
                  ),
                  Expanded(
                    child: Text("Cancelled", textAlign: TextAlign.center),
                  )
                ],
              ),*/
                ),
          )
        ],
      ),
    );
  }
}
