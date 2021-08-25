import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  static Database? db;
  Future<int?> countPoem() async {
    var dbpath = await getDatabasesPath();
    var path = join(dbpath, 'my_db.db');
    db = await openDatabase(path);
    int? count =
        Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM poems'));
    print("countPoem:$count");
    return count;
  }

  Future<bool> deletePoem(int id) async {
    var dbpath = await getDatabasesPath();
    var path = join(dbpath, 'my_db.db');
    db = await openDatabase(path);
    db!.execute("delete from poems where id=$id");
    return false;
  }

  Future<bool> addPoem(
      String title, String group, String content, String modifiedDate) async {
    var dbpath = await getDatabasesPath();
    var path = join(dbpath, 'my_db.db');
    db = await openDatabase(path);
    int id = -1;
    int? count =
        Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM poems'));
    print(count);
    if (count != 0) {
      await db!.rawQuery("select max(id) from poems ").then((value) {
        value.forEach((item) {
          item.forEach((key, value) {
            print("$key $value");
            id = value as int;
            id++;
          });
        });
      });
      print("final id " + id.toString());
    } else {
      id = 1;
    }
    await db!.execute(
        "insert into poems (id,_group,content,modifiedDate,title) values ($id,'未命名分组','$content','$modifiedDate','$title')");
    return false;
  }

  Future<List<Map<String, Object?>>> queryPoems() async {
    var dbpath = await getDatabasesPath();
    var path = join(dbpath, 'my_db.db');
    db = await openDatabase(path);
    List<Map<String, Object?>> list = [];
    await db!.rawQuery("select * from poems order by id desc").then((value) {
      list.addAll(value);
    });
    return list;
  }

  Future<void> onCreate() async {
    var dbpath = await getDatabasesPath();
    var path = join(dbpath, 'my_db.db');
    if (!await Directory(dirname(path)).exists()) {
      await Directory(dirname(path)).create(recursive: true);
    }
    db = await openDatabase(path);
    await db!.execute(
        "create table if not exists poems(id int primary key,title varchar(20),modifiedDate varchar(50) not null,_group varchar(20),content text)");
    await db!.execute(
        "create table if not exists feelings(id int primary key,title varchar(20),modifiedDate varchar(50) not null,_group varchar(20),content text)");
    //await db!.close();
  }
}
