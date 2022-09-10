import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_jdshop/services/CartServices.dart';
import '../../services/ScreenAdapter.dart';
import '../../services/UserServices.dart';
import 'package:provider/provider.dart';
import '../../provider/CartProvider.dart';
import '../../provider/CheckOutProvider.dart';
import '../Cart/CartItem.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartPage extends StatefulWidget {
  CartPage({Key? key}) : super(key: key);

  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isEdit = false;

  var checkOutProvider;

  @override
  void initState() {
    super.initState();
    print("cart");
  }

  //去结算

  doCheckOut() async {
    //1、获取购物车选中的数据
    List checkOutData = await CartServices.getCheckOutData();
    //2、保存购物车选中的数据
    this.checkOutProvider.changeCheckOutListData(checkOutData);
    //3、购物车有没有选中的数据
    if (checkOutData.length > 0) {
      //4、判断用户有没有登录
      var loginState = await UserServices.getUserLoginState();
      if (loginState) {
        Navigator.pushNamed(context, '/checkOut');
      } else {
        Fluttertoast.showToast(
          msg: '您还没有登录，请登录以后再去结算',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        Navigator.pushNamed(context, '/login');
      }
    } else {
      Fluttertoast.showToast(
        msg: '购物车没有选中的数据',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    checkOutProvider = Provider.of<CheckOutProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Shopping Cart"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              setState(() {
                this._isEdit = !this._isEdit;
              });
            },
          )
        ],
      ),
      body: cartProvider.cartList.length > 0
          ? Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    Column(
                        children: cartProvider.cartList.map((value) {
                      return CartItem(value, isEdit: this._isEdit);
                    }).toList()),
                    SizedBox(height: ScreenAdapter.height(80))
                  ],
                ),
                Positioned(
                  bottom: 0,
                  width: ScreenAdapter.width(750),
                  height: ScreenAdapter.height(78),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1, color: Colors.black12)),
                      color: Colors.white,
                    ),
                    width: ScreenAdapter.width(750),
                    height: ScreenAdapter.height(78),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              this._isEdit
                                  ? Container(
                                      width: ScreenAdapter.width(60),
                                      child: Checkbox(
                                        value: cartProvider.isCheckedAll,
                                        activeColor: Colors.pink,
                                        onChanged: (val) {
                                          //实现全选或者反选
                                          cartProvider.checkAll(val);
                                        },
                                      ),
                                    )
                                  : Container(),
                              this._isEdit ? Text("All") : Text(""),
                              SizedBox(width: 20),
                              this._isEdit == false ? Text("Total:") : Text(""),
                              this._isEdit == false
                                  ? Text("${cartProvider.allPrice}",
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.red))
                                  : Text(""),
                            ],
                          ),
                        ),
                        this._isEdit == false
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: ScreenAdapter.height(70),
                                  child: ElevatedButton(
                                    child: Text("Pay",
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    onPressed: doCheckOut,
                                  ),
                                ),
                              )
                            : Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: ScreenAdapter.height(70),
                                  child: ElevatedButton(
                                    child: Text("Delete",
                                        style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    onPressed: () {
                                      cartProvider.removeItem();
                                    },
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: Text("购物车空空的..."),
            ),
    );
  }
}
