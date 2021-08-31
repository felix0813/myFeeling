import 'package:flutter/material.dart';
import 'package:my_feeling/account/user.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChangePasswordState();
  }
}

class ChangePasswordState extends State<ChangePassword> {
  var original;
  var newPassword;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "修改密码",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text("云端用户修改密码"),
              leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            body: Column(
              children: [
                Text(
                  "修改密码",
                  style: TextStyle(fontSize: 24),
                ),
                TextField(
                  maxLines: 1,
                  onChanged: (s) {
                    original = s;
                  },
                  decoration: InputDecoration(
                    labelText: "原密码",
                    hintText: "原密码为8-12位",
                    icon: Icon(Icons.password),
                  ),
                ),
                TextField(
                  maxLines: 1,
                  onChanged: (s) {
                    newPassword = s;
                  },
                  decoration: InputDecoration(
                    labelText: "新密码",
                    hintText: "新密码为8-12位",
                    icon: Icon(Icons.password),
                  ),
                ),
                TextButton(
                    child: Text("确认修改"),
                    onPressed: () async {
                      await User.changePassword(original, newPassword)
                          .then((value) {
                        if (value == true) {
                          Navigator.pop(context);
                        }
                      });
                    })
              ],
            )));
  }
}
