import 'package:flutter/material.dart';
import 'package:my_feeling/databaseManager.dart';
import 'package:my_feeling/my_class/feeling.dart';
import 'package:my_feeling/readFeeling.dart';

class DownloadFeeling extends StatefulWidget {
  var list;

  DownloadFeeling(this.list);

  @override
  State<StatefulWidget> createState() {
    return DownloadFeelingState(list);
  }
}

class DownloadFeelingState extends State<DownloadFeeling> {
  late List<Feeling> list;
  DBManager db = DBManager();
  List<bool> downloadList = [];

  DownloadFeelingState(this.list);

  @override
  void initState() {
    for (int i = 0; i < list.length; i++) {
      downloadList.add(false);
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
          content: Text("您确定要下载当前文件吗?"),
          actions: <Widget>[
            TextButton(
              child: Text("取消"),
              onPressed: () => Navigator.of(context).pop(false), // 关闭对话框
            ),
            TextButton(
              child: Text("下载"),
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
            title: Text("从云端下载感受"),
            actions: [
              IconButton(
                  onPressed: () async {
                    await showDeleteConfirmDialog1().then((value) async {
                      if (value == true) {
                        for (int i = 0; i < downloadList.length; i++) {
                          if (downloadList[i]) {
                            Feeling tmp = list[i];
                            await db.addFeeling(tmp.title, tmp.group,
                                tmp.content, tmp.datetime);
                          }
                        }
                      }
                    });
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cloud_download))
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
                          value: downloadList[index],
                          onChanged: (value) {
                            setState(() {
                              downloadList[index] = value!;
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
