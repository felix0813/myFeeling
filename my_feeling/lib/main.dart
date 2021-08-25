import 'package:flutter/material.dart';
import 'package:my_feeling/pages/feelingPage.dart';
import 'package:my_feeling/pages/othersPage.dart';
import 'package:my_feeling/pages/poemPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new PageState();
  }
}

class PageState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController controller;
  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: TabBarView(
        controller: controller,
        children: <Widget>[
          PoemPage(),
          Feeling(),
          Others(),
        ],
      ),
      bottomNavigationBar: Material(
        color: Colors.white,
        child: TabBar(
          controller: controller,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black26,
          tabs: [
            Tab(
              text: "诗词",
              icon: Icon(Icons.book),
            ),
            Tab(
              text: "感受",
              icon: Icon(Icons.sentiment_satisfied),
            ),
            Tab(
              text: "其他",
              icon: Icon(Icons.settings),
            )
          ],
        ),
      ),
    ));
  }
}
