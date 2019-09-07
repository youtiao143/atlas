//import 'package:doubanapp/widgets/image/cached_network_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef OnTab = void Function();

class CacheNetworkImg extends StatelessWidget {
  final String imgUrl;
  final OnTab onTab;
  final ImageWidgetBuilder imageBuilder;
  CacheNetworkImg({Key key, @required this.imgUrl, this.onTab,this.imageBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CachedNetworkImage(imageUrl: imgUrl,imageBuilder: imageBuilder,),
      onTap: () {
        onTab();
      },
    );
  }
}
