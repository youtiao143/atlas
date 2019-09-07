import 'package:atlas/bean/book_detail_bean.dart';
import 'package:atlas/constant/book_optype_enum.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_drag_widget.dart';
import 'dart:convert';
import '../constant/constant.dart';
import './book_detail_title_widget.dart';
import '../service/service_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class BookDetail extends StatefulWidget {
  final String isbn;
  final int opType;
  
  BookDetail({this.isbn,this.opType}); 
  _BookDetailState createState() => _BookDetailState(isbn:isbn,opType:opType);
}

class _BookDetailState extends State<BookDetail> {
  final String isbn;
  final int opType;
  int op;
  _BookDetailState({this.isbn,this.opType});
  BookDetailBean _bookDetailBean;
  Color pickColor = Color(0xffffffff); 
  double get screenH => MediaQuery.of(context).size.height;
  String myBookListKey = "myBookList";
  
  

  @override
  void initState() { 
    super.initState();
    _getDoubanBookByISBN();
    this.op = opType;
  }
  
  _getDoubanBookByISBN() async{
    //从缓存获取数据
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    String myBookListStr = prefs.getString(myBookListKey);
    List _bookList=[];
    bool bookExist=false;
    
    if(myBookListStr != null && myBookListStr!=''){
      _bookList = json.decode(myBookListStr);
      for (var item in _bookList) {
        if(item['isbn13']==isbn || item['isbn10']==isbn){
          // _bdnStr = json.encode(item.toString());
          bookExist = true;
          setState((){
            // if(_bdnStr!=null && _bdnStr.isNotEmpty){
              _bookDetailBean = BookDetailBean.fromJson(item);
            // }
            
          });
        }
      }
    }
    if(!bookExist){
      getDoubanBookByISBN(isbn).then((data)=>{
        setState((){
          if(data!=null){
            
            _bookDetailBean = BookDetailBean.fromJson(data);
            // _bookList.add(data);
            // prefs.setString(myBookListKey, json.encode(_bookList));
          }else{
             Fluttertoast.showToast(
              msg: "未找到该书",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1
             );
            Navigator.of(context).pop();
          }
        })
      });
    }else{
      
      if(opType==BookOptypeEnum.addShelf.index){
        Fluttertoast.showToast(
          msg: "书架该书已存在",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1
          );
        }

        setState(() {
        //修改操作
          op = BookOptypeEnum.showDetail.index; 
        });
      }
      
    
  }


  Widget _getBody() {
    // print(op);
    // var allCount = _movieDetailBean.rating.details.d1 +
    //     _movieDetailBean.rating.details.d2 +
    //     _movieDetailBean.rating.details.d3 +
    //     _movieDetailBean.rating.details.d4 +
    //     _movieDetailBean.rating.details.d5;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverAppBar(
          title: Text('书籍'),
          centerTitle: true,
          pinned: true,
          // backgroundColor: pickColor,
        ),
        SliverToBoxAdapter(
          child: getPadding(DetailTitleWidget(_bookDetailBean, pickColor,op)),
        ),
        // SliverToBoxAdapter(
        //   child: Container(
        //     padding: EdgeInsets.only(top: 15.0, bottom: 25.0),
        //     margin: padding(),
        //     child: ScoreStartWidget(
        //       score: _movieDetailBean.rating.average,
        //       p1: _movieDetailBean.rating.details.d1 / allCount,
        //       p2: _movieDetailBean.rating.details.d2 / allCount,
        //       p3: _movieDetailBean.rating.details.d3 / allCount,
        //       p4: _movieDetailBean.rating.details.d4 / allCount,
        //       p5: _movieDetailBean.rating.details.d5 / allCount,
        //     ),
        //   ),
        // ),
        //  (),
        sliverSummary(),
        catalog()
        // sliverCasts(),
        // trailers(context),
        // sliverComments(),
      ],
    );
  }

  ///简介
  SliverToBoxAdapter sliverSummary() {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
              child: Text(
                '简介',
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              _bookDetailBean.summary==null?"暂无简介":_bookDetailBean.summary,
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Color(0x44000000),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
      ),
    );
  }
  //目录

  SliverToBoxAdapter catalog() {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
              child: Text(
                '目录',
                style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              _bookDetailBean.catalog==null?"暂无目录":_bookDetailBean.catalog,
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Color(0x44000000),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        padding: EdgeInsets.all(12.0),
        margin: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    if(_bookDetailBean==null){
      return Scaffold(
         body: Center(
          child: CircularProgressIndicator()
        )
      );
    }
    return Container(
       child: Scaffold(
        //  appBar: AppBar(title: Text("详情"),),
         body: Container(
           child: SafeArea(
             child: BottomDragWidget(
                body: _getBody(),
                dragContainer: DragContainer(
                    drawer: Container(
                      // child: OverscrollNotificationWidget(
                      //   child: Text("评论"),
                      // ),
                      // decoration: BoxDecoration(
                      //     color: const Color.fromARGB(255, 243, 244, 248),
                      //     borderRadius: BorderRadius.only(
                      //         topLeft: const Radius.circular(10.0),
                      //         topRight: const Radius.circular(10.0))),
                    ),
                    defaultShowHeight: screenH * 0.1,
                    height: screenH * 0.8))),
           ),
      )
    );
    
  }

  padding() {
    return EdgeInsets.only(
        left: Constant.MARGIN_LEFT, right: Constant.MARGIN_RIGHT);
  }

  getPadding(Widget body) {
    return Padding(
      padding: EdgeInsets.only(
          left: Constant.MARGIN_LEFT, right: Constant.MARGIN_RIGHT),
      child: body,
    );
  }
}
