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
            pageControlState: false,
            rotationDirection: Axis.vertical,
            future: Future.value(["11", "22", "33", "44", "55"]),
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
