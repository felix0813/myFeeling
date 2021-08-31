import 'package:flutter/material.dart';
import 'package:my_feeling/account/user.dart';
import 'package:my_feeling/databaseManager.dart';
import 'package:my_feeling/my_class/feeling.dart';
import 'package:my_feeling/readFeeling.dart';

class DeleteFeeling extends StatefulWidget {
  var list;

  DeleteFeeling(this.list);

  @override
  State<StatefulWidget> createState() {
    return DeleteFeelingState(list);
  }
}

class DeleteFeelingState extends State<DeleteFeeling> {
  late List<Feeling> list;
  DBManager db = DBManager();
  List<bool> deleteList = [];

  DeleteFeelingState(this.list);

  @override
  void initState() {
    for (int i = 0; i < list.length; i++) {
      deleteList.add(false);
    }
    super.initState();
  }

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            title: Text("从云端删除感受"),
            actions: [
              IconButton(
                  onPressed: () async {
                    await showDeleteConfirmDialog1().then((value) async {
                      if (value == true) {
                        List<int> ids = [];
                        for (int i = 0; i < deleteList.length; i++) {
                          if (deleteList[i]) {
                            int tmp = list[i].id;
                            ids.add(tmp);
                          }
                        }
                        await User.deleteCloudFeeling(ids);
                      }
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.delete))
            ],
          ),
          body: ListView.builder(
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Checkbox(
                          value: deleteList[index],
                          onChanged: (value) {
                            setState(() {
                              deleteList[index] = value!;
                            });
                          }),
                    ),
                    Expanded(
                      flex: 8,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ReadFeeling(feeling: list[index]);
                          }));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4)),
                              border:
                                  Border.all(width: 1, color: Colors.black)),
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
                      ),
                    )
                  ],
                );
              })),
    );
  }
}
