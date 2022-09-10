import 'package:flutter/material.dart';
import 'package:flutter_jdshop/provider/CartProvider.dart';
import 'package:flutter_jdshop/widget/NamedIcon.dart';
import 'package:provider/provider.dart';
import '../../services/ScreenAdapter.dart';
import 'Home.dart';
import 'Category.dart';
import 'Cart.dart';
import 'User.dart';

class Tabs extends StatefulWidget {
  final Map? arguments;

  Tabs({Key? key, this.arguments}) : super(key: key);

  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    this._pageController = new PageController(initialPage: this._currentIndex);
  }

  List<Widget> _pageList = [HomePage(), CategoryPage(), CartPage(), UserPage()];

  @override
  Widget build(BuildContext context) {
    if (widget.arguments != null) {
      bool backflag = widget.arguments?["backflag"];
      if (backflag) {
        this._currentIndex = widget.arguments?["currentIndex"];
      }
      widget.arguments?["backflag"] = false;
    }
    this._pageController = new PageController(initialPage: this._currentIndex);

    var cartProvider = Provider.of<CartProvider>(context);
    var length = cartProvider.newCarList.length;
    print("length -> ${length}");
    return Scaffold(
      body: PageView(
        controller: this._pageController,
        children: this._pageList,
        onPageChanged: (index) {
          setState(() {
            print("onPageChanged");
            //this._currentIndex = index;
          });
        },
        // physics: NeverScrollableScrollPhysics(),  //禁止pageView滑动，不配置默认可以滑动
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this._currentIndex,
        onTap: (index) async {
          print("BottomNavigationBar tap");
          if (index == 2) {
            await cartProvider.removeNewCartList();
          }
          setState(() {
            this._currentIndex = index;
            //跳转页面
            this._pageController.animateToPage(index,
                curve: Curves.ease, duration: Duration(milliseconds: 500));
          });
        },
        type: BottomNavigationBarType.fixed,
        fixedColor: Colors.green,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: "Category"),
          BottomNavigationBarItem(
              icon: NamedIcon(
                  notificationCount: length,
                  iconData: Icons.shopping_cart,
                  show: length > 0 ? true : false),
              label: "Cart"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Account")
        ],
      ),
    );
  }
}

