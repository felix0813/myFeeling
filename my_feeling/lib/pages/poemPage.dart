import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_feeling/account/user.dart';
import 'package:my_feeling/addPoem.dart';
import 'package:my_feeling/cloud/deletePoem.dart';
import 'package:my_feeling/cloud/downloadPoem.dart';
import 'package:my_feeling/databaseManager.dart';

import '../editPoem.dart';
import '../my_class/poem.dart';

class PoemPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PoemPageState();
  }
}

class PoemPageState extends State<PoemPage> {
  DBManager db = DBManager();
  var counter;
  var x;
  var y;

  List<Poem> list = [];

  String chooseTitle(int i) {
    if (list[i].title.toString().length == 0) {
      return list[i].content.toString();
    } else {
      return list[i].title.toString();
    }
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

  Future<void> getData() async {
    try {
      await db.onCreate();
    } catch (e) {
      print("error");
    }
    List<Poem> _list = [];
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
        _list.add(tmp);
      });
    });
    list = _list;
    print("got data");
  }

  Future<void> newPoem() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AddPoem();
    }));
    print("update start");
    await db.queryPoems().then((value) {
      List<Poem> _list = [];
      list = _list;
      value.forEach((element) {
        Poem tmp = new Poem(
            element['id'] as int,
            element['title'] as String,
            element['_group'] as String,
            element['modifiedDate'] as String,
            element['content'] as String);
        _list.add(tmp);
      });
      setState(() {
        list = _list;
      });
    });
    await db.countPoem().then((value) {
      setState(() {
        counter = value!;
      });
    });
    print("update end");
  }

  Future<void> editPoem(Poem poem) async {
    await db.deletePoem(poem.id);
    await Navigator.push(context, MaterialPageRoute(
      builder: (context) {
        return EditPoem(
          poem: poem,
        );
      },
    ));
    await db.queryPoems().then((value) {
      print("getData:" + value.length.toString());
      setState(() {
        List<Poem> _list = [];
        list = _list;
        value.forEach((element) {
          Poem tmp = new Poem(
              element['id'] as int,
              element['title'] as String,
              element['_group'] as String,
              element['modifiedDate'] as String,
              element['content'] as String);
          _list.add(tmp);
        });
        list = _list;
      });
    });
    await db.countPoem().then((value) {
      setState(() {
        counter = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(0, 255, 255, 0.6),
        title: new Text("诗词"),
        actions: [
          IconButton(
              onPressed: () async {
                if (!User.state) {
                  Fluttertoast.showToast(
                      msg: "您还没有登录",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 16);
                } else if (User.state) {
                  List<Poem> tmp = await User.getCloudPoem();
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return DownloadPoem(tmp);
                  }));
                  await db.queryPoems().then((value) {
                    List<Poem> _list = [];
                    list = _list;
                    value.forEach((element) {
                      Poem tmp = new Poem(
                          element['id'] as int,
                          element['title'] as String,
                          element['_group'] as String,
                          element['modifiedDate'] as String,
                          element['content'] as String);
                      _list.add(tmp);
                    });
                    setState(() {
                      list = _list;
                    });
                  });
                  await db.countPoem().then((value) {
                    setState(() {
                      counter = value!;
                    });
                  });
                }
              },
              icon: Icon(Icons.cloud_download)),
          IconButton(
              onPressed: () async {
                Fluttertoast.showToast(
                    msg: "此功能为从云端删除数据",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16);
                if (!User.state) {
                  Fluttertoast.showToast(
                      msg: "您还没有登录",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 16);
                } else {
                  List<Poem> tmp = await User.getCloudPoem();
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
                    return DeletePoem(tmp);
                  }));
                }
              },
              icon: Icon(Icons.delete))
        ],
      ),
      body: FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('Waiting to start.');
            case ConnectionState.active:
              return Text('In progress.');
            case ConnectionState.waiting:
              return Center(
                  child: Text(
                'Loading...',
                style: TextStyle(fontSize: 36),
              ));
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error} ');
              return ListView.builder(
                itemCount: counter,
                itemBuilder: (BuildContext context, int index) {
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
                          position: RelativeRect.fromLTRB(x, y - 50,
                              MediaQuery.of(context).size.width - x, 0),
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
                              int _id = list[index].id;
                              await db.deletePoem(_id);
                              List<Poem> _list = [];
                              _list.addAll(list);
                              _list.removeAt(index);
                              setState(() {
                                list = _list;
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
                            var curTitle = list[index].title;
                            var curDate = list[index].datetime;
                            var curContent = list[index].content;
                            var curUserName = User.userName;
                            await conn.query(
                                "insert into poems (title,modifiedDate,content,owner) values('$curTitle','$curDate','$curContent','$curUserName')");
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
                    onTap: () {
                      editPoem(list[index]);
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
                                chooseTitle(index),
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
                                  list[index].datetime +
                                      "  " +
                                      list[index].content,
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
              );
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
