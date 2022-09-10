import 'package:flutter/material.dart';

//最新版本的flutter中使用flutter_swiper_null_safety替代flutter_swiper，他们的用法都是一样的。
//import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:dio/dio.dart';
import '../../services/ScreenAdapter.dart';
import '../../model/FocusModel.dart';
import '../../model/ProductModel.dart';
import '../../config/Config.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List _focusData = [];
  List _hotProductList = [];
  List _bestProductList = [];

  @override
  // TODO: implement wantKeepAlive  缓存当前页面
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _getFocusData();
    _getHotProductData();
    _getBestProductData();
  }

  //获取轮播图数据
  _getFocusData() async {
    var api = '${Config.domain}api/focus';
    var result = await Dio().get(api);
    var focusList = FocusModel.fromJson(result.data);
    setState(() {
      this._focusData = focusList.result;
    });
  }

  //获取猜你喜欢的数据
  _getHotProductData() async {
    var api = '${Config.domain}api/plist?is_hot=1';
    var result = await Dio().get(api);
    var hotProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotProductList = hotProductList.result;
    });
  }

  //获取热门推荐的数据
  _getBestProductData() async {
    var api = '${Config.domain}api/plist?is_best=1';
    var result = await Dio().get(api);
    var bestProductList = ProductModel.fromJson(result.data);
    setState(() {
      this._bestProductList = bestProductList.result;
    });
  }

  //轮播图
  Widget _swiperWidget() {
    if (this._focusData.length > 0) {
      return Container(
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                String pic = this._focusData[index].pic;
                pic = Config.domain + pic.replaceAll('\\', '/');
                return new Image.network(
                  "${pic}",
                  fit: BoxFit.fill,
                );
              },
              itemCount: this._focusData.length,
              pagination: new SwiperPagination(builder: SwiperPagination.dots),
              indicatorLayout: PageIndicatorLayout.SCALE,
              autoplay: true),
        ),
      );
    } else {
      return Text('loading...');
    }
  }

  Widget _titleWidget(value) {
    return Container(
      height: ScreenAdapter.height(42),
      margin: EdgeInsets.only(left: ScreenAdapter.width(20)),
      padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
      decoration: BoxDecoration(
          border: Border(
              left: BorderSide(
        color: Theme.of(context).primaryColor,
        width: ScreenAdapter.width(10),
      ))),
      child: Text(
        value,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

//猜你喜欢
  Widget _hotProductListWidget() {
    if (this._hotProductList.length > 0) {
      return Container(
        height: ScreenAdapter.height(258),
        padding: EdgeInsets.all(ScreenAdapter.width(20)),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (contxt, index) {
            //处理图片
            String sPic = this._hotProductList[index].sPic;
            sPic = Config.domain + sPic.replaceAll('\\', '/');

            return InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/productContent',
                    arguments: {"id": this._hotProductList[index].sId});
              },
              child: Column(
                children: <Widget>[
                  Container(
                    height: ScreenAdapter.height(160),
                    width: ScreenAdapter.width(160),
                    margin: EdgeInsets.only(right: ScreenAdapter.width(21)),
                    child: Image.network(sPic, fit: BoxFit.cover),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(10)),
                    height: ScreenAdapter.height(44),
                    child: Text(
                      "¥${this._hotProductList[index].price}",
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                ],
              ),
            );
          },
          itemCount: this._hotProductList.length,
        ),
      );
    } else {
      return Text("");
    }
  }

//热门推荐
  Widget _recProductListWidget() {
    var itemWidth = (ScreenAdapter.getScreenWidth() - 30) / 2;
    return Container(
      padding: EdgeInsets.all(10),
      child: Wrap(
        runSpacing: 5,
        spacing: 5,
        children: this._bestProductList.map((value) {
          //图片
          String sPic = value.sPic;
          sPic = Config.domain + sPic.replaceAll('\\', '/');

          return InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/productContent',
                  arguments: {"id": value.sId});
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width: itemWidth,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Color.fromRGBO(233, 233, 233, 0.9), width: 1)),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    child: AspectRatio(
                      //防止服务器返回的图片大小不一致导致高度不一致问题
                      aspectRatio: 1 / 1,
                      child: Image.network(
                        "${sPic}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                    child: Text(
                      "${value.title}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: ScreenAdapter.height(20)),
                    child: Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "¥${value.price}",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("¥${value.oldPrice}",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  decoration: TextDecoration.lineThrough)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon:
                Icon(Icons.center_focus_weak, size: 28, color: Colors.black87),
            onPressed: null,
          ),
          title: InkWell(
            child: Container(
              height: ScreenAdapter.height(68),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(233, 233, 233, 0.8),
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.only(left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.search),
                  Text("笔记本",
                      style: TextStyle(fontSize: ScreenAdapter.size(28)))
                ],
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.message, size: 28, color: Colors.black87),
              onPressed: null,
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            _swiperWidget(),
            SizedBox(height: ScreenAdapter.height(20)),
            _titleWidget("Your Favor"),
            SizedBox(height: ScreenAdapter.height(20)),
            _hotProductListWidget(),
            _titleWidget("Best Seller"),
            _recProductListWidget()
          ],
        ));
  }
}
