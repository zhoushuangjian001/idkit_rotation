import 'package:flutter/material.dart';
import 'package:idkit_rotation/idkit_rotation.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FPage(),
    );
  }
}

class FPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("轮播组件测试"),
      ),
      body: Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: Container(
          child: IDKitRotation(
            height: 120,
            width: 200,
            pageControlState: true,
            rotationDirection: Axis.horizontal,
            pageControlShape: BoxShape.circle,
            pageControlEdgeInsets: PageControlEdgeInsets.only(bottom: 20),
            future: Future.value(["11", "22", "33", "44", "55"]),
            placeholderChild: Container(
              alignment: Alignment.center,
              child: Text("我是默认"),
            ),
            buildItem: (context, index, data) {
              return Container(
                height: 30,
                color: Colors.purple,
                child: Text("我是$data"),
              );
            },
            didSelectItem: (data, index) {
              print("--- $index-----");
            },
          ),
        ),
      ),
    );
  }
}
