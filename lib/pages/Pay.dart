import 'package:flutter/material.dart';
import '../widget/JdButton.dart';

class PayPage extends StatefulWidget {
  PayPage({Key? key}) : super(key: key);

  _PayPageState createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  List payList = [
    {
      "title": "ZhifuPay",
      "checked": true,
      "image": "https://www.itying.com/themes/itying/images/alipay.png"
    },
    {
      "title": "WeChatPay",
      "checked": false,
      "image": "https://www.itying.com/themes/itying/images/weixinpay.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay Step"),
      ),
      body: Column(
        children: <Widget>[
          Container(
              height: 400,
              padding: EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: this.payList.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        leading:
                            Image.network("${this.payList[index]["image"]}"),
                        title: Text("${this.payList[index]["title"]}"),
                        trailing: this.payList[index]["checked"]
                            ? Icon(Icons.check)
                            : Text(""),
                        onTap: () {
                          //让payList里面的checked都等于false
                          setState(() {
                            for (var i = 0; i < this.payList.length; i++) {
                              this.payList[i]['checked'] = false;
                            }
                            this.payList[index]["checked"] = true;
                          });
                        },
                      ),
                      Divider(),
                    ],
                  );
                },
              )),
          JdButton(
            text: "Pay",
            color: Colors.red,
            height: 74,
            cb: () {
              print('Payment');
              Navigator.pushNamedAndRemoveUntil(
                  context, "/home", (Route<dynamic> route) => false,
                  arguments: {'backflag': true, 'currentIndex': 3});
              Navigator.pushNamed(context, "/order");
            },
          )
        ],
      ),
    );
  }
}
