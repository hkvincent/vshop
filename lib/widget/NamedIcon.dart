import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NamedIcon extends StatelessWidget {
  final IconData iconData;
  final int notificationCount;
  final bool show;
  final double size;

  const NamedIcon(
      {Key? key,
      required this.iconData,
      this.notificationCount = 0,
      this.show = false,
      this.size = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return show
        ? Stack(
            children: <Widget>[
              this.size == 0 ? Icon(iconData) : Icon(iconData, size: this.size),
              Positioned(
                right: 0,
                child: new Container(
                  padding: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 12,
                    minHeight: 12,
                  ),
                  child: new Text(
                    '${notificationCount}',
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          )
        : this.size == 0
            ? Icon(iconData)
            : Icon(iconData, size: this.size);
  }
}