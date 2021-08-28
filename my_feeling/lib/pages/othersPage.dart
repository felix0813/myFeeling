import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart' as mysql;
import 'package:mysql1/mysql1.dart';

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
                //TO DO
                ),
            FutureBuilder(
                future: connectDatabase(),
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return Text('Press button to start.');
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return Center(
                          child: Text(
                        'Awaiting result...',
                        style: TextStyle(fontSize: 36),
                      ));
                    case ConnectionState.done:
                      return Center(
                          child: Text(
                        'Got result...',
                        style: TextStyle(fontSize: 36),
                      ));
                  }
                }),
          ])),
    );
  }
}
