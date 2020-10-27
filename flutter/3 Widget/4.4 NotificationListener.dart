class MyHomeNotificationDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomeNotificationDemoState();
}

class MyHomeNotificationDemoState extends State<MyHomeNotificationDemo> {
  int _progress = 0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        // 1.判断监听事件的类型
        if (notification is ScrollStartNotification) {
          print("开始滚动.....");
        } elseif (notification is ScrollUpdateNotification) {
          // 当前滚动的位置和总长度
          final currentPixel = notification.metrics.pixels;
          final totalPixel = notification.metrics.maxScrollExtent;
          double progress = currentPixel / totalPixel;
          setState(() {
            _progress = (progress * 100).toInt();
          });
          print("正在滚动：${notification.metrics.pixels} - ${notification.metrics.maxScrollExtent}");
        } elseif (notification is ScrollEndNotification) {
          print("结束滚动....");
        }
        returnfalse;
      },
      child: Stack(
        alignment: Alignment(.9, .9),
        children: <Widget>[
          ListView.builder(
            itemCount: 100,
            itemExtent: 60,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(title: Text("item$index"));
            }
          ),
          CircleAvatar(
            radius: 30,
            child: Text("$_progress%"),
            backgroundColor: Colors.black54,
          )
        ],
      ),
    );
  }
}
