import 'package:fluttertoast/fluttertoast.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:mysql1/mysql1.dart';
class User {
  static int userID = -1;
  static String userName = '';
  static bool state = false;
  static Future<void> register(String name,String password) async{
    var settings = new mysql.ConnectionSettings(
        host: 'rm-wz903m77zaza3173jmo.mysql.rds.aliyuncs.com',
        port: 3306,
        user: 'felix',
        password: 'wzf_0813',
        db: 'my_db');
    var conn = await mysql.MySqlConnection.connect(settings);
    Results results = await conn.query("select count(*) as cnt from users where username='$name'");

      if(name.length>=3&&password.length>=8&&password.length<=12&&results.elementAt(0)[0] as int ==0){
        await conn.query("insert into users (username,userpassword) values('$name','$password')");
        Fluttertoast.showToast(
            msg: "注册成功",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16);
      }
      else if(results.elementAt(0)[0] as int !=0){
        Fluttertoast.showToast(
            msg: "注册失败，此用户名已被注册",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16);
      }
      else{
        Fluttertoast.showToast(
            msg: "注册失败，请查看用户名或者密码位数",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            fontSize: 16);
      }
    await conn.close();
  }
  static Future<bool> login(String name,String password) async{
    var settings = new mysql.ConnectionSettings(
        host: 'rm-wz903m77zaza3173jmo.mysql.rds.aliyuncs.com',
        port: 3306,
        user: 'felix',
        password: 'wzf_0813',
        db: 'my_db');
    var conn = await mysql.MySqlConnection.connect(settings);
    Results results = await conn.query("select count(*) as cnt from users where username='$name' and userpassword='$password'");
    await conn.close();
    if(results.elementAt(0)[0]==1){
      state=true;
      return true;
    }
    else{
      return false;
    }
  }
  static Future<void> logout() async{
    if(state==true){
      state=false;
      Fluttertoast.showToast(
          msg: "注销成功",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16);
    }
    else{
      Fluttertoast.showToast(
          msg: "您没有登录",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 16);
    }
  }
}
