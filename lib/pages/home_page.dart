import 'package:flutter/material.dart';
class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _TabBarControllerState createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController _tabController;
  @override
  void dispose(){
    _tabController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    _tabController = TabController(vsync: this,length: 2); 
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: Scaffold(
         appBar: AppBar(
          title:Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: (){
                    print('search...');
                },
              ),
              Expanded(
                flex: 1,
                child: TabBar(
                controller: _tabController,
                tabs: <Widget>[
                  Tab(text:'推荐'),
                  Tab(text:'关注'),
                ],
              ),
              ),
              // IconButton(
              //   icon: Icon(Icons.more_vert),
              //   onPressed: (){
              //       print('search...');
              //   },
              // ),
            ],
          ),
          // bottom: TabBar(
          //   controller: _tabController,
          //   tabs: <Widget>[
          //     Tab(text:'推荐'),
          //     Tab(text:'关注'),
          //   ],
          // ),

         ),
         body: TabBarView(
           controller: _tabController,
           children: <Widget>[
             ListView(children: <Widget>[
               ListTile(title: Text('第一个tab'),)
             ],),
             ListView(children: <Widget>[
               ListTile(title: Text('第二个tab'),),
               ListTile(title: Text('第二个tab'),),
             ],)
           ],
         ),
       ),
    );
  }
}