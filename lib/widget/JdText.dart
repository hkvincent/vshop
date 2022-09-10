import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_jdshop/services/ScreenAdapter.dart';

class JdText extends StatelessWidget {

  final String text;
  final bool password;
  // final Function(String)? onChanged;      //新版flutter中onChanged需要定义为Function(String)?类型  也可以使用var
  var onChanged;
  final int maxLines;
  final double height;
  // final TextEditingController? controller;  //新版flutter中TextEditingController需要为可空类型 也可以使用var
  var controller;
  JdText({Key? key,this.text="输入内容",this.password=false,this.onChanged=null,this.maxLines=1,this.height=68,this.controller=null}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller:controller,
        maxLines:this.maxLines ,
        obscureText: this.password,
        decoration: InputDecoration(
            hintText: this.text,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none)),
        onChanged: this.onChanged,
      ),
      height: ScreenAdapter.height(this.height),
      decoration: BoxDecoration(      
          border: Border(
            bottom: BorderSide(
              width: 1,
              color: Colors.black12
            )
          )
    ),
    );
  }
}
