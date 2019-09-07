import 'book_detail_bean.dart';
class BookList {
  int count;
  int start;
  int total;
  List<BookDetailBean> books;

  BookList({this.count, this.start, this.total, this.books});

  BookList.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    start = json['start'];
    total = json['total'];
    if (json['books'] != null) {
      books = new List<BookDetailBean>();
      json['books'].forEach((v) {
        books.add(new BookDetailBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['start'] = this.start;
    data['total'] = this.total;
    if (this.books != null) {
      data['books'] = this.books.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

