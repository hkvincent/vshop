import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'routers/router.dart';

// 引入provider
import 'package:provider/provider.dart';
import 'provider/CheckOutProvider.dart';
import 'provider/CartProvider.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(750, 1334), //配置设计稿的宽度高度
      builder: () => MultiProvider(
        //配置Provider
        providers: [
          ChangeNotifierProvider(create: (_) => CheckOutProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider())
        ],
        child: MaterialApp(
          color: Colors.lightGreen,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          onGenerateRoute: onGenerateRoute,
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.blueGrey,
            fontFamily: 'Georgia',
          ),
        ),
      ),
    );
  }
}
