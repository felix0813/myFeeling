import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_feeling/account/changePassword.dart';
import 'package:my_feeling/account/registerUser.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:mysql1/mysql1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../account/loginUser.dart';
import '../account/user.dart';

class Others extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new OthersState();
  }
}

class OthersState extends State<Others> {
  //连接数据库&查询
  Future connectDatabase() async {
    var settings = new mysql.ConnectionSettings(
        host: 'rm-wz903m77zaza3173jmo.mysql.rds.aliyuncs.com',
        port: 3306,
        user: 'felix',
        password: 'wzf_0813',
        db: 'my_db');
    var conn = await mysql.MySqlConnection.connect(settings);
    //var userId = yxcode;
    Results results = await conn.query('select count(*) as cnt from users');
    await conn.close();
    print(results.elementAt(0)[0]);
  }

  String username = User.userName;
  String buttonText = "";
  void getButtonText() {
    setState(() {
      if (User.state == true) {
        buttonText = "登出";
      } else {
        buttonText = "登录";
      }
    });
  }

  @override
  void initState() {
    getButtonText();
    if (User.state == true) {
      setState(() {
        username = User.userName;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromRGBO(0, 255, 255, 0.5),
            title: Text("其他设置"),
          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
              child: Row(
                children: [
                  Text(
                    username,
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(150, 0, 0, 0),
                      child: Column(
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (User.state) {
                                  await User.logout();
                                  setState(() {
                                    username = User.userName;
                                    getButtonText();
                                  });
                                } else {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  String initName = "";
                                  String initPassword = "";
                                  if (prefs.getBool("remember") == true) {
                                    initName = prefs.getString("name")!;
                                    initPassword = prefs.getString("password")!;
                                  }
                                  await Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return LoginUser(initName, initPassword);
                                  }));
                                  setState(() {
                                    username = User.userName;
                                    getButtonText();
                                  });
                                }
                              },
                              child: Text(buttonText)),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .push(MaterialPageRoute(builder: (context) {
                                  return RegisterUser();
                                }));
                              },
                              child: Text(
                                "注册新账号",
                              ))
                        ],
                      ))
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 20,
              margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                  border: Border.all(width: 1, color: Colors.black)),
              child: TextButton(
                onPressed: () {
                  if (User.state == true) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return ChangePassword();
                    }));
                  } else {
                    Fluttertoast.showToast(
                        msg: "您尚未登录",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 16);
                  }
                },
                child: Text("修改密码",
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ),
            )

            /*FutureBuilder(
                future: connectDatabase(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                      return Center(
                          child: Text(
                        'Got result...',
                        style: TextStyle(fontSize: 36),
                      ));
                  }
                }),*/
          ])),
    );
  }
}
