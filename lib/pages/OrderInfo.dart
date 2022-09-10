import 'package:flutter/material.dart';
import 'package:flutter_jdshop/services/ScreenAdapter.dart';

class OrderInfoPage extends StatefulWidget {
  final Map arguments;

  OrderInfoPage({Key? key, required this.arguments}) : super(key: key);

  _OrderInfoPageState createState() => _OrderInfoPageState();
}

class _OrderInfoPageState extends State<OrderInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail of Order")),
      body: Container(
        child: ListView(
          children: <Widget>[
            //收货地址
            Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  ListTile(
                    leading: Icon(Icons.add_location),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            "${widget.arguments["order"].name} : ${widget.arguments["order"].phone} "),
                        SizedBox(height: 10),
                        Text("${widget.arguments["order"].address} "),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 16),
            //列表
            Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: Column(
                children:
                    widget.arguments["order"].orderItem.map<Widget>((value) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/productContent',
                          arguments: {"id": value.productId});
                    },
                    child: Row(children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        width: ScreenAdapter.width(120),
                        child: Image.network("${value.productImg}",
                            fit: BoxFit.cover),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("${value.productTitle}",
                                  maxLines: 2,
                                  style: TextStyle(color: Colors.black54)),
                              Text("${value.selectedAttr}",
                                  maxLines: 2,
                                  style: TextStyle(color: Colors.black54)),
                              ListTile(
                                leading: Text("￥${value.productPrice}",
                                    style: TextStyle(color: Colors.red)),
                                trailing: Text("x${value.productCount}"),
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                  );
                }).toList(),
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text("no.:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${widget.arguments["order"].sId}")
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text("下单日期:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("2019-12-09")
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text("支付方式:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("微信支付")
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: <Widget>[
                        Text("配送方式:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("顺丰")
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Column(
                children: <Widget>[
                  ListTile(
                      title: Row(
                    children: <Widget>[
                      Text("Total:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("￥${widget.arguments["order"].allPrice}元",
                          style: TextStyle(color: Colors.red))
                    ],
                  ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
