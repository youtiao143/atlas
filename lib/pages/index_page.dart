import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'books_page.dart';
import 'notice_page.dart';
import 'my_page.dart';

class IndexPage extends StatefulWidget {
    final int pageIndex;
    IndexPage({this.pageIndex=0});
  _IndexPageState createState() => _IndexPageState(pageIndex);
}



class _IndexPageState extends State<IndexPage> {
  
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      title: Text("首页")
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.book),
      title: Text("书架"),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      title: Text("通知")
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.people),
      title: Text("我的")
    ),
  ];
  _IndexPageState(pageIndex){
    this.currentIndex = pageIndex;
  }
  final List tabBodies = [
    HomePage(),
    BooksPage(),
    NoticePage(),
    MyPage(),
  ];

  int currentIndex = 0;
  
  var currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = tabBodies[currentIndex];
    // if(defaultPageIndex>0){
      // currentPage = tabBodies[defaultPageIndex];
      currentPage = tabBodies[currentIndex];
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Colors.lightBlue),
        selectedItemColor: Colors.lightBlue,
        type:BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: bottomTabs,
        onTap: (index){
          setState(() {
           currentIndex = index; 
           currentPage = tabBodies[currentIndex];
          });
        },
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              child: Text('Hello'),
            ),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.home),
              ),
              title: Text('Home'),
            ),
            Divider(),
            ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.settings),
              ),
              title: Text('setting'),
            )
          ],
        ),
      )
    );
  }
}