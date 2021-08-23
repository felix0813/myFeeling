import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_feeling/databaseManager.dart';
import 'package:my_feeling/editPoem.dart';

import '../poem.dart';

class PoemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PoemPageState();
  }
}

class PoemPageState extends State<PoemPage> {
  DBManager db = DBManager();
  var counter;
  List<Poem> list = [];
  String chooseTitle(int i) {
    if (list[i].title.toString().length == 0) {
      return list[i].content.toString();
    } else {
      return list[i].title.toString();
    }
  }

  Future<void> getData() async {
    await db.countPoem().then((value) => counter = value!);
    await db.queryPoems().then((value) {
      print("getData:" + value.length.toString());
      value.forEach((element) {
        Poem tmp = new Poem(
            element['id'] as int,
            element['title'] as String,
            element['_group'] as String,
            element['modifiedDate'] as String,
            element['content'] as String);
        list.add(tmp);
      });
    });
    print("got data");
  }

  void newPoem() {
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
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Press button to start.');
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text('Awaiting result...');
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return ListView.builder(
                itemCount: counter,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin:EdgeInsets.fromLTRB(10, 10, 10, 5),
                          child:Align(
                          alignment:Alignment.centerLeft,
                          child:Text(
                          chooseTitle(index),
                          maxLines: 1,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                        ),),
                        Container(
                          margin:EdgeInsets.fromLTRB(10, 5, 10, 10),
                            child:Align(
                          alignment:Alignment.centerLeft,
                          child:Text(
                          list[index].datetime + "  " + list[index].content,
                          maxLines: 1,
                          style: TextStyle(fontSize: 12),
                          textAlign: TextAlign.left,
                        ),
                        ))
                      ],
                    ),
                  );
                },
              );
              ;
          }
          //return null;
        },
        future: getData(),
      ),
      /**/
      floatingActionButton: FloatingActionButton(
        onPressed: newPoem,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    ));
  }
}
