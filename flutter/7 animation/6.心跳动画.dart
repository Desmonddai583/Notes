class HYHomePage extends StatelessWidget {
  final GlobalKey<_AnimationDemo01State> demo01Key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动画测试"),
      ),
      body: AnimationDemo01(key: demo01Key),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_circle_filled),
        onPressed: () {
          if (!demo01Key.currentState.controller.isAnimating) {
            demo01Key.currentState.controller.forward();
          } else {
            demo01Key.currentState.controller.stop();
          }
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

  @override
  void initState() {
    super.initState();

    // 1.创建AnimationController
    controller = AnimationController(duration: Duration(seconds: 1), vsync: this);
    // 2.动画添加Curve效果
    animation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut, reverseCurve: Curves.easeOut);
    // 3.监听动画
    animation.addListener(() {
      setState(() {});
    });
    // 4.控制动画的翻转
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } elseif (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    // 5.设置值的范围
    animation = Tween(begin: 50.0, end: 120.0).animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.favorite, color: Colors.red, size: animation.value,),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}