import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_feeling/editPoem.dart';

class Poem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PoemState();
  }
}

class PoemState extends State<Poem> {
  int counter = 0;
  void new_poem() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPoem();
    }));
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(0, 255, 255, 0.6),
        title: new Text("诗词"),
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: new_poem,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    ));
  }
}
