import 'package:atlas/bean/book_detail_bean.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:convert';
import '../config/service_url.dart';

Future getBooks() async{
  print("获取书籍数据...");
  Response response;
  Dio dio = new Dio();
  response = await dio.get(servicePath['getBooks']);

  if(response.statusCode == 200){
    return json.decode(response.toString())['data'];
  } else {
    throw Exception("获取书籍列表错误...");
  } 
}


Future getDoubanBookByISBN(isbn) async{
  Response response;
  var params = {"q":isbn};
  Dio dio = new Dio();
  response = await dio.get(
    doubanServicePath['searchDoubanBookSearch'],
    queryParameters: params
    );

  if(response.statusCode == 200){
    return json.decode(response.toString())['books'].length>0?json.decode(response.toString())['books'][0]:{};
  } else {
    throw Exception("获取书籍详情错误...");
  }
}