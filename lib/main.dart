import 'package:flutter/material.dart';

import './routers/routes.dart';
// import './routers/application.dart';

import 'package:provide/provide.dart';
import './provide/books_provide.dart';

void main(){
    final providers = Providers()
    ..provide(Provider.function((context)=>BooksProvide(0)));

    runApp(ProviderNode(child: MyApp(),providers: providers));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {    
    return Container(
      child: MaterialApp(
        title: "atlas",
        debugShowCheckedModeBanner: false,
        onGenerateRoute: onGenerateRoute,
        theme: ThemeData(
          primaryColor: Colors.white
        ),
        initialRoute: '/',
      ),
      
    );
  }
}