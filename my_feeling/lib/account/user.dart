import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_feeling/my_class/poem.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:mysql1/mysql1.dart';

import '../my_class/feeling.dart';

class User {
  static int userID = -1;
  static String userName = '尚未登录';
  static bool state = false;
  static Future<bool> register(String name, String password) async {
    mysql.MySqlConnection conn = await connectAliyun();
    Results results = await conn
        .query("select count(*) as cnt from users where username='$name'");

    if (name.length >= 3 &&
        password.length >= 8 &&
        password.length <= 12 &&
        results.elementAt(0)[0] as int == 0) {
      await conn.query(
          "insert into users (username,userpassword) values('$name','$password')");
      Fluttertoast.showToast(
          msg: "注册成功",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16);
      return true;
    } else if (results.elementAt(0)[0] as int != 0) {
      Fluttertoast.showToast(
          msg: "注册失败，此用户名已被注册",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16);
    } else {
      Fluttertoast.showToast(
          msg: "注册失败，请查看用户名或者密码位数",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16);
    }

    await conn.close();
    return false;
  }

  static Future<bool> login(String name, String password) async {
    mysql.MySqlConnection conn = await connectAliyun();
    Results results = await conn.query(
        "select count(*) as cnt from users where username='$name' and userpassword='$password'");
    await conn.close();
    if (results.elementAt(0)[0] == 1 && state == false) {
      state = true;
      return true;
    } else {
      return false;
    }
  }

  static Future<void> logout() async {
    if (state == true) {
      state = false;
      userName = "尚未登录";
      Fluttertoast.showToast(
          msg: "注销成功",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16);
    } else {
      Fluttertoast.showToast(
          msg: "您没有登录",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16);
    }
  }

  static Future<bool> changePassword(String oldPass, String newPass) async {
    mysql.MySqlConnection conn = await connectAliyun();
    Results results = await conn.query(
        "select count(*) as cnt from users where username='$userName' and userpassword='$oldPass'");
    if (results.elementAt(0)[0] == 1) {
      await conn.query(
          "update users set userpassword='$newPass' where username='$userName'");
      await conn.close();
      return true;
    } else {
      Fluttertoast.showToast(
          msg: "原密码错误",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16);
      await conn.close();
      return false;
    }
  }

  static Future<List<Poem>> getCloudPoem() async{
    List<Poem> list=[];
    if(state)
    {
      mysql.MySqlConnection conn = await connectAliyun();
      Results results = await conn.query(
          "select * from poems where username='$userName'");
      results.forEach((element) {
        var id=element.elementAt(0) as int;
        var title=element.elementAt(1) as String;
        var date=element.elementAt(2) as String;
        var content=element.elementAt(3) as String;
        list.add(Poem(id,title,"未命名分组",date,content));
      });
      return list;
    }
    else{
      Fluttertoast.showToast(msg: "您还没有登录",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM,
          fontSize: 16);
      return list;
    }
  }

  static Future<List<Feeling>> getCloudFeeling() async{
    List<Feeling> list=[];
    if(state)
    {
      mysql.MySqlConnection conn = await connectAliyun();
      Results results = await conn.query(
          "select * from feelings where username='$userName'");
      results.forEach((element) {
        var id=element.elementAt(0) as int;
        var title=element.elementAt(1) as String;
        var date=element.elementAt(2) as String;
        var content=element.elementAt(3) as String;
        list.add(Feeling(id,title,"未命名分组",date,content));
      });
      return list;
    }
    else{
      Fluttertoast.showToast(msg: "您还没有登录",toastLength: Toast.LENGTH_SHORT,gravity: ToastGravity.BOTTOM,
          fontSize: 16);
      return list;
    }
  }

  static Future<mysql.MySqlConnection> connectAliyun() async {
    var settings = new mysql.ConnectionSettings(
        host: 'rm-wz903m77zaza3173jmo.mysql.rds.aliyuncs.com',
        port: 3306,
        user: 'felix',
        password: 'wzf_0813',
        db: 'my_db');
    var conn = await mysql.MySqlConnection.connect(settings);
    return conn;
  }
}
