import 'package:flutter/material.dart';
import '../../pages/Cart/CartNum.dart';
import '../../services/ScreenAdapter.dart';
import 'package:provider/provider.dart';
import '../../provider/CartProvider.dart';

class CartItem extends StatefulWidget {
  Map _itemData;
  bool isEdit;

  CartItem(this._itemData, {this.isEdit = false, Key? key}) : super(key: key);

  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late Map _itemData;

  @override
  Widget build(BuildContext context) {
    //注意：给属性赋值
    this._itemData = widget._itemData;

    var cartProvider = Provider.of<CartProvider>(context);
    return Container(
      height: ScreenAdapter.height(220),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: InkWell(
        child: Row(
          children: <Widget>[
            Container(
              width: widget.isEdit ? ScreenAdapter.width(60) : 0,
              child: widget.isEdit
                  ? Checkbox(
                      value: _itemData["checked"],
                      onChanged: (val) {
                        _itemData["checked"] = !_itemData["checked"];
                        cartProvider.itemChage();
                      },
                      activeColor: Colors.pink,
                    )
                  : Container(),
            ),
            Container(
              width: ScreenAdapter.width(160),
              child: Image.network("${_itemData["pic"]}", fit: BoxFit.cover),
            ),
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("${_itemData["title"]}",
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                    Text("${_itemData["selectedAttr"]}", maxLines: 1),
                    Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("￥${_itemData["price"]}",
                              style: TextStyle(color: Colors.red)),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: widget.isEdit
                              ? CartNum(_itemData)
                              : Text("${_itemData["count"]}"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, '/productContent',
              arguments: {"id": _itemData['_id']});
        },
      ),
    );
  }
}
