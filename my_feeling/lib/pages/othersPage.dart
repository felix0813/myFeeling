import 'package:flutter/material.dart';

class Others extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new OthersState();
  }
}

class OthersState extends State<Others> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 255, 255, 0.5),
          title: Text("其他设置"),
        ),
      ),
    );
  }
}
