import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_jdshop/widget/NamedIcon.dart';
import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import '../services/ScreenAdapter.dart';
import 'ProductContent/ProductContentFirst.dart';
import 'ProductContent/ProductContentSecond.dart';
import 'ProductContent/ProductContentThird.dart';

import '../widget/JdButton.dart';

import '../config/Config.dart';
import 'package:dio/dio.dart';
import '../model/ProductContentModel.dart';

import '../widget/LoadingWidget.dart';

import 'package:provider/provider.dart';
import '../provider/CartProvider.dart';
import '../services/CartServices.dart';

import 'package:fluttertoast/fluttertoast.dart';

//广播
import '../services/EventBus.dart';

class ProductContentPage extends StatefulWidget {
  final Map arguments;

  ProductContentPage({Key? key, required this.arguments}) : super(key: key);

  _ProductContentPageState createState() => _ProductContentPageState();
}

class _ProductContentPageState extends State<ProductContentPage>
    with SingleTickerProviderStateMixin {


  List _productContentList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(this._productContentData.sId);
    this._getContentData();
  }

  _getContentData() async {
    var api = '${Config.domain}api/pcontent?id=${widget.arguments['id']}';

    print(api);
    var result = await Dio().get(api);
    var productContent = new ProductContentModel.fromJson(result.data);

    setState(() {
      this._productContentList.add(productContent.result);
    });
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var length = cartProvider.newCarList.length;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: ScreenAdapter.width(400),
                child: TabBar(
                  indicatorColor: Colors.red,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: <Widget>[
                    Tab(
                      child: Text('商品'),
                    ),
                    Tab(
                      child: Text('详情'),
                    ),
                    Tab(
                      child: Text('评价'),
                    )
                  ],
                ),
              )
            ],
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.more_horiz),
              onPressed: () {
                showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        ScreenAdapter.width(600), 76, 10, 0),
                    items: [
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[Icon(Icons.home), Text("首页")],
                        ),
                      ),
                      PopupMenuItem(
                        child: Row(
                          children: <Widget>[Icon(Icons.search), Text("搜索")],
                        ),
                      )
                    ]);
              },
            )
          ],
        ),
        body: this._productContentList.length > 0
            ? Stack(
                children: <Widget>[
                  TabBarView(
                    physics: NeverScrollableScrollPhysics(), //禁止TabBarView滑动
                    children: <Widget>[
                      ProductContentFirst(this._productContentList),
                      ProductContentSecond(this._productContentList),
                      ProductContentThird()
                    ],
                  ),
                  Positioned(
                    width: ScreenAdapter.width(750),
                    height: ScreenAdapter.width(88),
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.black26, width: 1)),
                          color: Colors.white),
                      child: Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              cartProvider.removeNewCartList();
                              Navigator.pushNamedAndRemoveUntil(
                                  context, "/home", (Route<dynamic> route) => false,
                                  arguments: {'backflag': true, 'currentIndex': 0});
                              Navigator.pushNamed(context, '/cart');
                            },
                            child: Container(
                              padding:
                                  EdgeInsets.only(top: ScreenAdapter.height(4)),
                              width: ScreenAdapter.size(120),
                              height: ScreenAdapter.height(84),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        top: ScreenAdapter.height(12)),
                                    child: NamedIcon(
                                        notificationCount: length,
                                        iconData: Icons.shopping_cart,
                                        size: ScreenAdapter.size(36),
                                        show: length > 0 ? true : false),
                                  ),
                                  Text("Cart",
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.size(22)))
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: JdButton(
                              color: Color.fromRGBO(253, 1, 0, 0.9),
                              text: "Add",
                              cb: () async {
                                if (this._productContentList[0].attr.length >
                                    0) {
                                  //广播 弹出筛选
                                  eventBus
                                      .fire(new ProductContentEvent('加入购物车'));
                                } else {
                                  await CartServices.addCart(
                                      this._productContentList[0]);
                                  await CartServices.addNewCart(
                                      this._productContentList[0]);
                                  //调用Provider 更新数据
                                  cartProvider.updateCartList();
                                  Fluttertoast.showToast(
                                    msg: 'Add to cart Successful.',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                  );
                                }
                              },
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: JdButton(
                              color: Color.fromRGBO(255, 165, 0, 0.9),
                              text: "Buy",
                              cb: () {
                                if (this._productContentList[0].attr.length >
                                    0) {
                                  //广播 弹出筛选
                                  eventBus
                                      .fire(new ProductContentEvent('立即购买'));
                                } else {
                                  print("立即购买");
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            : LoadingWidget(),
      ),
    );
  }
}
