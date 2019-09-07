class BookDetailBean {
  Rating rating;
  String subtitle;
  List<String> author;
  String pubdate;
  String originTitle;
  String image;
  String binding;
  String catalog;
  String pages;
  Images images;
  String alt;
  String id;
  String publisher;
  String isbn10;
  String isbn13;
  String title;
  String url;
  String altTitle;
  String authorIntro;
  String summary;
  String price;
  String bookState;

  BookDetailBean(
      {this.rating,
      this.subtitle,
      this.author,
      this.pubdate,
      this.originTitle,
      this.image,
      this.binding,
      this.catalog,
      this.pages,
      this.images,
      this.alt,
      this.id,
      this.publisher,
      this.isbn10,
      this.isbn13,
      this.title,
      this.url,
      this.altTitle,
      this.authorIntro,
      this.summary,
      this.price,
      this.bookState
      }
    );

  BookDetailBean.fromJson(Map<String, dynamic> json) {
    rating =
        json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
    subtitle = json['subtitle'];
    author = json['author'].cast<String>();
    pubdate = json['pubdate'];
    originTitle = json['origin_title'];
    image = json['image'];
    binding = json['binding'];
    catalog = json['catalog'];
    pages = json['pages'];
    images =
        json['images'] != null ? new Images.fromJson(json['images']) : null;
    alt = json['alt'];
    id = json['id'];
    publisher = json['publisher'];
    isbn10 = json['isbn10'];
    isbn13 = json['isbn13'];
    title = json['title'];
    url = json['url'];
    altTitle = json['alt_title'];
    authorIntro = json['author_intro'];
    summary = json['summary'];
    price = json['price'];

    bookState = json['bookState'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.rating != null) {
      data['rating'] = this.rating.toJson();
    }
    data['subtitle'] = this.subtitle;
    data['author'] = this.author;
    data['pubdate'] = this.pubdate;
    data['origin_title'] = this.originTitle;
    data['image'] = this.image;
    data['binding'] = this.binding;
    data['catalog'] = this.catalog;
    data['pages'] = this.pages;
    if (this.images != null) {
      data['images'] = this.images.toJson();
    }
    data['alt'] = this.alt;
    data['id'] = this.id;
    data['publisher'] = this.publisher;
    data['isbn10'] = this.isbn10;
    data['isbn13'] = this.isbn13;
    data['title'] = this.title;
    data['url'] = this.url;
    data['alt_title'] = this.altTitle;
    data['author_intro'] = this.authorIntro;
    data['summary'] = this.summary;
    data['price'] = this.price;

    data['bookState'] = this.bookState;
    return data;
  }
}

class Rating {
  int max;
  int numRaters;
  String average;
  int min;

  Rating({this.max, this.numRaters, this.average, this.min});

  Rating.fromJson(Map<String, dynamic> json) {
    max = json['max'];
    numRaters = json['numRaters'];
    average = json['average'];
    min = json['min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max'] = this.max;
    data['numRaters'] = this.numRaters;
    data['average'] = this.average;
    data['min'] = this.min;
    return data;
  }
}

class Images {
  String small;
  String large;
  String medium;

  Images({this.small, this.large, this.medium});

  Images.fromJson(Map<String, dynamic> json) {
    small = json['small'];
    large = json['large'];
    medium = json['medium'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['small'] = this.small;
    data['large'] = this.large;
    data['medium'] = this.medium;
    return data;
  }
}