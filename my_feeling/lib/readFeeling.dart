import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_feeling/databaseManager.dart';
import 'package:my_feeling/my_class/feeling.dart';

class ReadFeeling extends StatefulWidget {
  Feeling feeling;

  ReadFeeling({
    required this.feeling,
  });

  @override
  State<StatefulWidget> createState() {
    return new ReadState(feeling: feeling);
  }
}

class ReadState extends State<ReadFeeling> {
  ReadState({
    required this.feeling,
  });

  Feeling feeling;
  int id = -1;
  var title;
  late String datetime;
  int length = 0;
  var content;
  DBManager db = DBManager();

  @override
  void initState() {
    datetime = feeling.datetime;
    id = feeling.id;
    title = feeling.title as String;
    content = feeling.content as String;
    length = content.length;
    super.initState();
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
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.arrow_back),
            ),
            margin: EdgeInsets.fromLTRB(0, 20, 310, 0),
          ),
          Container(
            alignment: Alignment.centerLeft,
            //margin: EdgeInsets.fromLTRB(20, 60, 50, 0),
            margin: EdgeInsets.fromLTRB(20, 0, 5, 0),
            child: Text(
              title,
              maxLines: 1,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 24),
            ),
          ),
          Row(
            children: [
              Container(
                child: Text(
                  datetime,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                //margin: EdgeInsets.fromLTRB(20, 120, 0, 0),
                margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
              ),
              Container(
                child: Text(
                  length.toString() + "字",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                //margin: EdgeInsets.fromLTRB(60, 120, 0, 0),
                margin: EdgeInsets.fromLTRB(60, 10, 0, 0),
              )
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            height: MediaQuery.of(context).size.height - 144,
            child: SingleChildScrollView(
              child: Text(
                content,
                maxLines: null,
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 18),
              ),
            ),
            //margin: EdgeInsets.fromLTRB(10, 130, 5, 0),
            margin: EdgeInsets.fromLTRB(20, 15, 5, 0),
          ),
        ],
      ),
    );
  }
}
