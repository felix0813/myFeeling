import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_feeling/databaseManager.dart';

class AddFeeling extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new AddState();
  }
}

class AddState extends State<AddFeeling> {
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

  String convertMinute(int minute) {
    String result = minute.toString();
    if (result.length == 1) {
      result = "0" + result;
    }
    return result;
  }

  Future<void> insertFeeling() async {
    if (title != null || content != null) {
      if (title == null) {
        title = "";
      } else if (content == null) {
        content = "";
      }
      await db.addFeeling(
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
            convertMinute(datetime.minute),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            child: IconButton(
              alignment: Alignment.bottomLeft,
              onPressed: () {
                insertFeeling();
                Navigator.pop(context, 1);
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
            height: MediaQuery.of(context).size.height - 144,
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
