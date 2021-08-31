import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_feeling/account/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  var name;
  var password;

  LoginUser(this.name, this.password);

  @override
  State<StatefulWidget> createState() {
    return LoginState(name, password);
  }
}

class LoginState extends State<LoginUser> {
  bool checkboxState = true;
  var name;
  var password;
  var initName;
  var initPassword;

  LoginState(this.initName, this.initPassword);

  @override
  void initState() {
    setState(() {
      name = initName;
      password = initPassword;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "用户登录",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text("云端用户登录"),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            body: Column(
              children: [
                Text(
                  "用户登录",
                  style: TextStyle(fontSize: 24),
                ),
                TextField(
                  maxLines: 1,
                  onChanged: (s) {
                    name = s;
                  },
                  controller: TextEditingController(text: initName),
                  decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "用户名为3-10位",
                    icon: Icon(Icons.person),
                  ),
                ),
                TextField(
                  maxLines: 1,
                  onChanged: (s) {
                    password = s;
                  },
                  controller: TextEditingController(text: initPassword),
                  decoration: InputDecoration(
                    labelText: "密码",
                    hintText: "密码为8-12位",
                    icon: Icon(Icons.password),
                  ),
                ),
                Row(children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.width / 2 - 24, 0, 0, 0),
                    child: TextButton(
                        child: Text(
                          "登录",
                          style: TextStyle(fontSize: 24),
                        ),
                        onPressed: () async {
                          await User.login(name, password).then((value) async {
                            if (value == true) {
                              User.state = true;
                              User.userName = name;
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (checkboxState) {
                                prefs.setString("name", name);
                                prefs.setString("password", password);
                                prefs.setBool("remember", true);
                              } else {
                                prefs.clear();
                                prefs.setBool("remember", false);
                              }
                              Navigator.of(context).pop();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "用户名不存在或者密码不匹配",
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                  fontSize: 16);
                            }
                          });
                        }),
                  ),
                  Text("记住密码"),
                  Checkbox(
                      value: checkboxState,
                      onChanged: (value) {
                        setState(() {
                          checkboxState = value!;
                        });
                      })
                ])
              ],
            )));
  }
}
