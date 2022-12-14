import 'package:flutter/material.dart';

class CounterProvider with ChangeNotifier{

  int _count=1;  //状态

  CounterProvider(){
    this._count=10;
  }

  int get count=>_count;  //获取状态

  incCount(){             //更新状态
    this._count++;
    notifyListeners();   //表示更新状态
  }

}