import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class ZoomImage extends StatelessWidget {

  String imageList;
  ZoomImage({this.imageList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        // title: TextDesign(
        //   text: "Wishlist",
        //   fontSize: 18,
        //   fontfamily: "NotoSans",
        //   fontWeight: FontWeight.w700,
        //   color: textColor,
        // ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: CachedNetworkImage(
            filterQuality: FilterQuality.high,
            imageUrl: imageList,
            width: double.infinity,
            //height: MediaQuery.of(context).size.height * 0.8,
            fit: BoxFit.contain,
          ),
      ),
    );
  }
}
