import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_feeling/user.dart';

class RegisterUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<RegisterUser> {
  var name;
  var password;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "用户注册",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text("云端用户注册"),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            body: Column(
              children: [
                Text(
                  "用户注册",
                  style: TextStyle(fontSize: 24),
                ),
                TextField(
                  maxLines: 1,
                  onChanged: (s) {
                    name = s;
                  },
                  decoration: InputDecoration(
                    labelText: "用户名",
                    helperText: "用户名为3-10位",
                    icon: Icon(Icons.person),
                  ),
                ),
                TextField(
                  maxLines: 1,
                  onChanged: (s) {
                    password = s;
                  },
                  decoration: InputDecoration(
                    labelText: "密码",
                    helperText: "密码为8-12位",
                    icon: Icon(Icons.password),
                  ),
                ),
                TextButton(
                    child: Text("注册"),
                    onPressed: () async {
                      await User.register(name, password).then((value) {
                        if (value == true) {
                          Navigator.of(context).pop();
                        }
                      });
                    }),
              ],
            )));
  }
}
