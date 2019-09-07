import 'package:flutter/material.dart';
import '../pages/book_detail.dart';
import '../pages/books_page.dart';
import '../pages/index_page.dart';
var routes = {
  '/': (context,{arguments})=>IndexPage(),
  'bookDetail': (context)=>BookDetail(),
  'booksPage': (context)=>BooksPage(),
};

var onGenerateRoute = (RouteSettings settings){
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if(pageContentBuilder!=null){
    if(settings.arguments!=null){
      final Route route = MaterialPageRoute(
        builder: (context)=>
          pageContentBuilder(context,arguments:settings.arguments)
        
      );
      return route;
    }else{
      final Route route = MaterialPageRoute(
        builder: (context)=>
          pageContentBuilder(context)
      );
      return route;
    }
  }
};