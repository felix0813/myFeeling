import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'account/user.dart';
import 'databaseManager.dart';
import 'editFeeling.dart';
import 'my_class/feeling.dart';

class SearchFeeling extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchFeelingState();
  }
}

class SearchFeelingState extends State<SearchFeeling> {
  List<Feeling> list = [];
  int counter = 0;
  var x;
  var y;
  String searchStr='';
  TextEditingController controller=TextEditingController();
  DBManager db = DBManager();
  String chooseTitle(int i) {
    if (list[i].title.toString().length == 0) {
      return list[i].content.toString();
    } else {
      return list[i].title.toString();
    }
  }

  Future<void> editFeeling(Feeling feeling) async {
    await db.deleteFeeling(feeling.id);
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return EditFeeling(
          feeling: feeling,
        );
      },
    ));

      searchStr=controller.text;


    if(searchStr.length==0){
      List<Feeling> _list = [];
      setState(() {
        list=_list;
        counter=_list.length;
      });
      return;
    }

    List<Feeling> _list = [];
    await db.queryFeelingsByString(searchStr).then((value) {
      value.forEach((element) {
        Feeling tmp = new Feeling(
            element['id'] as int,
            element['title'] as String,
            element['_group'] as String,
            element['modifiedDate'] as String,
            element['content'] as String);
        _list.add(tmp);
      });
    });
    setState(() {
      list = _list;
      counter=_list.length;
    });
  }

  Future<bool?> showDeleteConfirmDialog1() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("提示"),
          content: Text("您确定要删除当前文件吗?"),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
            ),
            TextButton(
              child: Text("删除"),
              onPressed: () {
                //关闭对话框并返回true
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: ListView.builder(
          itemCount: counter + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                  margin: EdgeInsets.fromLTRB(15, 15, 5, 5),
                  child: Row(children: [
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            border: Border.all(width: 1, color: Colors.black12),
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        width: MediaQuery.of(context).size.width - 90,
                        child: TextField(
                          controller: controller,
                          onChanged: (str) async {
                            if (str.length != 0) {
                              List<Feeling> newList = [];
                              await db.queryFeelingsByString(str).then((value) {
                                value.forEach((element) {
                                  newList.add(Feeling(
                                      element['id'] as int,
                                      element['title'] as String,
                                      element['_group'] as String,
                                      element['modifiedDate'] as String,
                                      element['content'] as String));
                                });
                              });
                              setState(() {
                                list = newList;
                                counter = newList.length;
                                searchStr=str;
                              });
                            } else {
                              List<Feeling> newList = [];
                              setState(() {
                                list = newList;
                                counter = newList.length;
                                searchStr=str;
                              });
                            }
                            print(searchStr);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                              hintText: "搜索感受"),
                        )),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "取消",
                          style: TextStyle(fontSize: 16),
                        ))
                  ]));
            }
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onPanDown: (details) {
                x = details.globalPosition.dx;
                y = details.globalPosition.dy;
              },
              onLongPress: () async {
                var result;
                result = await showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                        x, y - 50, MediaQuery.of(context).size.width - x, 0),
                    items: [
                      PopupMenuItem(
                        child: Text(
                          "删除",
                          style: TextStyle(fontSize: 15),
                        ),
                        value: "delete",
                      ),
                      PopupMenuItem(
                        child: Text(
                          "上传到云端",
                          style: TextStyle(fontSize: 15),
                        ),
                        value: "upload",
                      ),
                      PopupMenuItem(
                        child: Text(
                          "取消",
                          style: TextStyle(fontSize: 15),
                        ),
                        value: "cancel",
                      )
                    ]);
                switch (result as String) {
                  case "delete":
                    await showDeleteConfirmDialog1().then((value) async {
                      if (value == true) {
                        int _id = list[index - 1].id;
                        await db.deleteFeeling(_id);
                        List<Feeling> _list = [];
                        _list.addAll(list);
                        _list.removeAt(index - 1);
                        setState(() {
                          list = _list;
                          counter = list.length;
                        });
                      }
                    });
                    break;
                  case "upload":
                    if (User.state == false) {
                      Fluttertoast.showToast(
                          msg: "请先登录",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16);
                      break;
                    } else {
                      var conn = await User.connectAliyun();
                      var curTitle = list[index - 1].title;
                      var curDate = list[index - 1].datetime;
                      var curContent = list[index - 1].content;
                      var curUserName = User.userName;
                      await conn.query(
                          "insert into feelings (title,modifiedDate,content,owner) values('$curTitle','$curDate','$curContent','$curUserName')");
                      await conn.close();
                      Fluttertoast.showToast(
                          msg: "添加成功",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 16);
                      break;
                    }
                  case "cancel":
                    break;
                }
              },
              onTap: () async {
                editFeeling(list[index - 1]);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    border: Border.all(width: 1, color: Colors.black)),
                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          chooseTitle(index - 1),
                          maxLines: 1,
                          style: TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            list[index - 1].datetime +
                                "  " +
                                list[index - 1].content,
                            maxLines: 1,
                            style: TextStyle(fontSize: 12),
                            textAlign: TextAlign.left,
                          ),
                        ))
                  ],
                ),
              ),
            );
          },
        ));
  }
}
