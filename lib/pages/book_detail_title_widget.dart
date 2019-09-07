import 'package:atlas/constant/book_optype_enum.dart';
import 'package:atlas/routers/routes.dart';

import '../pages/index_page.dart';
import 'package:flutter/material.dart';
import '../bean/book_detail_bean.dart';
import '../constant/constant.dart';
import 'look_confirm_button.dart';
// import '../constant/book_state_enum.dart';
import '../widgets/cache_network_img.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';



class DetailTitleWidget extends StatelessWidget {
  final BookDetailBean bean;
  final Color shadowColor;
  final int opType;
  String myBookListKey = "myBookList";

  DetailTitleWidget(this.bean, this.shadowColor,this.opType);

  @override
  Widget build(BuildContext context) {
    var screenW = MediaQuery.of(context).size.width;
    var imgW = screenW / 4;
    var imgH = imgW * 421 / 297;
    var authors = list2String(bean.author);
    // var genres = list2String(bean.genres);
    // var pubdates = list2String(bean.pubdates);
    // var durations = list2String(bean.durations);
    //将按下的颜色设置较为浅色
    
        // Color.fromARGB(100, shadowColor.red, shadowColor.red, shadowColor.red);
    return Row(
      children: <Widget>[
        Card(
          //影音海报
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          color: shadowColor,
          clipBehavior: Clip.antiAlias,
          elevation: 10.0,
          child: 
          Container(
            width: imgW,
            height: imgH,
            child: CacheNetworkImg(
            imgUrl: bean.image,
            onTab: (){
              print('image click...');
            },
            // imageBuilder: (context, imageProvider)=>Container(
            //   decoration: BoxDecoration(
            //         image: DecorationImage(
            //             image: imageProvider,
            //             fit: BoxFit.cover,
            //             colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
            //           ),
            //       ),
            //   ),
            ),
          ),
          
          // Image.network(
          //   bean.images.large,
          //   width: imgW,
          //   height: imgH,
          //   fit: BoxFit.cover,
          // ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: Constant.MARGIN_LEFT),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  bean.title,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 5.0, bottom: 7.0),
                //   child: Text(
                //     '(${bean.year})',
                //     style: TextStyle(fontSize: 15.0, color: Colors.white),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Text(
                    '${authors}/${bean.publisher}/出版时间：${bean.pubdate}',
                    style: TextStyle(fontSize: 12.0, color: Colors.black87),
                  ),
                ),
                Row(
                  children: _getOpButton(context,opType)
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  List<Widget> _getOpButton(context,opType){
    
    var btnPressedColor = Colors.lightBlue;
    List<Widget> buttonList = List();
    Widget addButton = Expanded(
                      child: LookConfirmButton(
                        btnText: '加入书架',
                        iconAsset: 'assets/images/ic_info_wish.png',
                        defaultColor: Colors.grey,
                        pressedColor: btnPressedColor,
                        onPressed: (){
                          
                          this._addBookListItem(bean);

                          //跳转到列表页,并清空之前路由
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IndexPage(pageIndex: 1),
                            ),
                            (route)=>route==null
                          );
                        },
                      ),
                    );
     Widget division = Padding(
          padding: EdgeInsets.only(left: 15.0),
      );
    
   Widget addCollect = Expanded(
                      child: LookConfirmButton(
                        btnText: '收藏',
                        iconAsset: 'assets/images/ic_info_wish.png',
                        defaultColor: Colors.grey,
                        pressedColor: btnPressedColor,
                      )
                    );

    Widget delButton = Expanded(
                      child: LookConfirmButton(
                        btnText: '移除书架',
                        iconAsset: 'assets/images/ic_info_delete.png',
                        defaultColor: Colors.grey,
                        pressedColor: btnPressedColor,
                        onPressed: (){
                          
                          showDialog(
                            context: context,
                            builder: (context)=>AlertDialog(
                              title:Text("提示"),
                              content: Text("确定要将"+bean.title+"移出书架吗?"),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text("确定"),
                                  onPressed: (){
                                    
                                    this._deleteBookListItem(bean.isbn13);

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IndexPage(pageIndex: 1),
                                      ),
                                      (route)=>route==null
                                    );
                                  },
                                ),
                                FlatButton(
                                  child: Text("取消"),
                                  onPressed: (){
                                    
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            )
                          );
                        },
                      )
                    );
    
    if(BookOptypeEnum.addShelf.index == opType){
      buttonList.add(addButton);
      buttonList.add(division);
    }else if(BookOptypeEnum.showDetail.index == opType){
      buttonList.add(delButton);
      buttonList.add(division);
    }
    return buttonList;
  
  }

  String list2String(List<String> list) {
    var tmp = '';
    for (String item in list) {
      tmp = tmp + item;
    }
    return tmp;
  }

  _deleteBookListItem(isbn) async{
    //从缓存获取列表数据
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    String myBookListStr = prefs.getString(myBookListKey);
    List bookList = json.decode(myBookListStr);
    for (var i = 0; i < bookList.length; i++) {
      BookDetailBean item = BookDetailBean.fromJson(bookList[i]);
      if(item.isbn13 == isbn || item.isbn10 == isbn){
        bookList.removeAt(i);
      }
    }
    prefs.setString(myBookListKey, json.encode(bookList));
  
  }

  _addBookListItem(bean) async{
    //从缓存获取列表数据
    
    SharedPreferences prefs = await  SharedPreferences.getInstance();
    String myBookListStr = prefs.getString(myBookListKey);
    
    
    List bookList = json.decode(myBookListStr);
    bookList.add(bean);
    
    prefs.setString(myBookListKey, json.encode(bookList));
    
  }
}
