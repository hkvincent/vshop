import 'package:flutter/cupertino.dart';

class MyAnimatedWidget extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const MyAnimatedWidget(
      {required Key key, required this.controller, required this.child})
      : super(key: key);

  @override
  _MyAnimatedWidgetState createState() => _MyAnimatedWidgetState();
}

class _MyAnimatedWidgetState extends State<MyAnimatedWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.dispose();
  }
}
