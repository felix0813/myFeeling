import 'package:flutter/material.dart';

class Feeling extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FeelingState();
}

class FeelingState extends State<Feeling> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(0, 255, 255, 0.55),
          title: Text("感受"),
        ),
      ),
    );
  }
}
