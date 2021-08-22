import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_feeling/databaseManager.dart';
import 'package:my_feeling/editPoem.dart';

class PoemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PoemPageState();
  }
}

class PoemPageState extends State<PoemPage> {
  DBManager db=DBManager();
  int counter=0;
  void newPoem() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPoem();
    }));
  }
  Future<void> countItems() async{
    await db.countPoem().then((value) => counter=value!);
  }
  @override
  Future<void> initState() async {
    await countItems();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(0, 255, 255, 0.6),
        title: new Text("诗词"),
      ),
      body: ListView.builder(
        itemCount: counter,
        itemBuilder: (BuildContext context, int index) {

      },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: newPoem,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    ));
  }
}
