import 'package:flutter/material.dart';
import 'package:atlas/bean/book_detail_bean.dart';

class BooksProvide with ChangeNotifier{
  int _value;
  List books;
  int get value => _value;
  BooksProvide(this._value);
  void increment(){
    _value++;
    notifyListeners();
  }
  void addBooks(BookDetailBean bookDetailBean){

  }
  void delBooks(){

  }
}