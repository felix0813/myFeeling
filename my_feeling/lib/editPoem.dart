import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_feeling/databaseManager.dart';

class EditPoem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new EditState();
  }
}

class EditState extends State<EditPoem> {
  int id = -1;
  var title;
  DateTime datetime = DateTime.now().add(Duration(hours: 8));
  int length = 0;
  var content;
  DBManager db = DBManager();
  void lengthChanged(String s) {
    setState(() {
      length = s.length;
    });
  }

  void titleChanged(String s) {
    setState(() {
      title = s;
    });
  }

  void contentChanged(String s) {
    setState(() {
      content = s;
    });
  }

  Future<void> insertPoem() async {
    await db.onCreate();
    if (title != null || content != null) {
      if (title == null) {
        title = "";
      } else if (content == null) {
        content = "";
      }
      await db.addPoem(
        title,
        "未命名分组",
        content,
        datetime.year.toString() +
            "年" +
            datetime.month.toString() +
            "月" +
            datetime.day.toString() +
            "日 " +
            datetime.hour.toString() +
            ":" +
            datetime.minute.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: IconButton(
              alignment: Alignment.bottomLeft,
              onPressed: () {
                insertPoem();
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            margin: EdgeInsets.fromLTRB(0, 20, 310, 0),
          ),
          TextField(
            onChanged: (s) {
              titleChanged(s);
            },
            autofocus: true,
            maxLines: 1,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: "标题",
              icon: Icon(Icons.title),
            ),
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 24),
          ),
          Row(
            children: [
              Container(
                child: Text(
                  datetime.year.toString() +
                      "年" +
                      datetime.month.toString() +
                      "月" +
                      datetime.day.toString() +
                      "日 " +
                      datetime.hour.toString() +
                      ":" +
                      datetime.minute.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              ),
              Container(
                child: Text(
                  length.toString() + "字",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                margin: EdgeInsets.fromLTRB(60, 0, 0, 0),
              )
            ],
          ),
          Container(
            child: Expanded(
              child: SingleChildScrollView(
                child: TextField(
                  onChanged: (str) {
                    lengthChanged(str);
                    contentChanged(str);
                  },
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "在此输入文字",
                  ),
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            margin: EdgeInsets.fromLTRB(10, 0, 5, 0),
          ),
        ],
      ),
    );
  }
}
