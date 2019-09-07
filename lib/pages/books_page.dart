import 'package:atlas/bean/book_detail_bean.dart';
import 'package:atlas/constant/book_optype_enum.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../widgets/cache_network_img.dart';


import 'package:qrscan/qrscan.dart' as scanner;
import 'package:flutter/services.dart';
import '../pages/book_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BooksPage extends StatefulWidget {
  BooksPage({Key key}) : super(key: key);

  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
 List bookList;
 String isbnScanResult = "Hey there !";
 String myBookListKey = "myBookList";

  @override
  void initState() {
    super.initState();
    _fetchBookListData().then((data)=>{
      setState(() {
        bookList = data;
      })
    });
  }

  _fetchBookListData() async{
    //从缓存获取列表数据
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    String myBookListStr = prefs.getString(myBookListKey);
    
    if(myBookListStr==null){
      return [];
    }else{
      return json.decode(myBookListStr);
    }
    
    
  }

  List _bookList(){
    return bookList.map((item){
      BookDetailBean _bdb = BookDetailBean.fromJson(item);
      return InkWell(
        onTap: (){
          

        },
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height *
                      0.4,
                  width:
                      MediaQuery.of(context).size.width * 0.2,
                  // decoration: BoxDecoration(
                  //     image: DecorationImage(
                  //         fit: BoxFit.cover,
                  //         image: NetworkImage(_bdb.image))),
                  child : CacheNetworkImg(imgUrl: _bdb.image,onTab: (){
                    // print("inkwell onclick...");
                    //跳转到详情页面
                    String isbn = _bdb.isbn13.isEmpty?_bdb.isbn10:_bdb.isbn13;
                    int opType = BookOptypeEnum.showDetail.index;
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookDetail(
                          isbn:_bdb.isbn13.isEmpty?_bdb.isbn10:_bdb.isbn13,
                          opType: BookOptypeEnum.showDetail.index))
                    );
                  },),
                ),
              ),
                Text(
                  _bdb.title,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ],
          ),
        )
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
       child: Scaffold(
          appBar: AppBar(
            title: Text("书架"),
            actions: <Widget>[
              // 非隐藏的菜单
              new FlatButton(
                  child: Text("编辑"),
                  textTheme: ButtonTextTheme.accent,
                  disabledTextColor: Colors.red,
                  onPressed: () {}
              ),
          ]
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: 
                bookList == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : 
                GridView.count(
                  mainAxisSpacing: 20.0,
                  crossAxisCount: 3,
                  children: _bookList(),
                ),
          ),
          floatingActionButton: FloatingActionButton(
          onPressed: _addBook,
          tooltip: 'add',
          child: Icon(Icons.add),
      ),
       ),
    );
  }

  String barcode = "";

  Future _scan() async {
    try {
      String barcode = await scanner.scan();
      print('barcode:$barcode');
      setState(() => this.barcode = barcode);
      //跳转到详情
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => BookDetail(isbn:barcode,opType:BookOptypeEnum.addShelf.index))
          );
    } on PlatformException catch (e) {
      if (e.code == scanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }



  _addBook(){
    _scan();
  }
}