import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/widgets/video_player_demo.dart';
import 'package:geomedipath/widgets/zoom_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class GridDesignScreen extends StatelessWidget {
  List list;

  GridDesignScreen({this.list});

  Widget gridList(BuildContext context, int index) {
    var imageName = list[index]['type'].toString() == "IMG"
        ? "gallery"
        : list[index]['type'].toString() == "VIDEO"
            ? "youtube"
            : "pdf";
    return Card(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft:
                  Radius.circular(MediaQuery.of(context).size.width * 0.05),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width * 0.05),
              bottomLeft:
                  Radius.circular(MediaQuery.of(context).size.width * 0.05),
            )),
            //color: borderColor,
            child: list[index]['type'].toString() == "IMG"
                ? CachedNetworkImage(
                    imageUrl: "https://app.geomedipath.com/uploads/post/${list[index]['url']}",
                    height: MediaQuery.of(context).size.width * 0.35,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
                  )
                : Image(
                    image: AssetImage("assets/images/$imageName.png"),
                    // topLeftRadius: MediaQuery.of(c
                    // ontext).size.width * 0.05,
                    // topRightRadius: MediaQuery.of(context).size.width * 0.05,
                    // bottomLeftRadius: MediaQuery.of(context).size.width * 0.05,
                    height: list[index]['type'].toString() == "PDF"
                        ? MediaQuery.of(context).size.width * 0.22
                        : MediaQuery.of(context).size.width * 0.35,
                  ),
          ),
          list[index]['type'].toString() == "PDF"
              ? Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                      vertical: MediaQuery.of(context).size.height * 0.01),
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 0.07,
                  child: Text(
                    list[index]['name'],
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.005 * 4,
                    ),
                  ),
                )
              : Container(),
          //screenSpace(context),
        ],
      ),
    );
  }

  _launchURL(var uri) async {
    var url = 'https://app.geomedipath.com/uploads/post/$uri';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.04,
        top: MediaQuery.of(context).size.height * 0.02,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: MediaQuery.of(context).size.width * 0.03,
        mainAxisSpacing: MediaQuery.of(context).size.height * 0.01,
        mainAxisExtent: MediaQuery.of(context).size.height * 0.2,
        crossAxisCount: 2,
      ),
      itemCount: list.length,
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => InkWell(
          onTap: () {
            if (list[index]['type'].toString() == 'PDF') {
              _launchURL(list[index]['url']);
            } else if (list[index]['type'].toString() == 'IMG') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ZoomImage(
                        imageList: "https://app.geomedipath.com/uploads/post/${list[index]['url']}",
                      )));
            } else if (list[index]['type'].toString() == 'VIDEO') {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => VideoDemo(
                        videolink: list[index]['url'],
                      )));
            } else {
              return Fluttertoast.showToast(
                  msg: "Failed",
                  textColor: Colors.black87,
                  backgroundColor: Colors.grey);
            }
          },
          child: gridList(context, index)),
    );
  }
}
