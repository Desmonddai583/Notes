import'dart:math';

import'package:flutter/material.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue, splashColor: Colors.transparent),
      home: HYHomePage(),
    );
  }
}

class HYHomePage extends StatelessWidget {
  final GlobalKey<_AnimationDemo01State> demo01Key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("列表测试"),
      ),
      body: AnimationDemo01(key: demo01Key),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_circle_filled),
        onPressed: () {
          demo01Key.currentState.controller.forward();
        },
      ),
    );
  }
}

class AnimationDemo01 extends StatefulWidget {
  AnimationDemo01({Key key}): super(key: key);

  @override
  _AnimationDemo01State createState() => _AnimationDemo01State();
}

class _AnimationDemo01State extends State<AnimationDemo01> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  Animation<Color> colorAnim;
  Animation<double> sizeAnim;
  Animation<double> rotationAnim;

  @override
  void initState() {
    super.initState();

    // 1.创建AnimationController
    controller = AnimationController(duration: Duration(seconds: 2), vsync: this);
    // 2.动画添加Curve效果
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
    // 3.监听动画
    animation.addListener(() {
      setState(() {});
    });

    // 4.设置值的变化
    colorAnim = ColorTween(begin: Colors.blue, end: Colors.red).animate(controller);
    sizeAnim = Tween(begin: 0.0, end: 200.0).animate(controller);
    rotationAnim = Tween(begin: 0.0, end: 2*pi).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: controller,
        builder: (ctx, child) {
          return Opacity(
            opacity: animation.value,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationZ(rotationAnim.value),
              child: Container(
                width: sizeAnim.value,
                height: sizeAnim.value,
                color: colorAnim.value,
                alignment: Alignment.center,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}