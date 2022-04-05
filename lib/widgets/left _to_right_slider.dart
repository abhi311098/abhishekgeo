import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomedipath/screens/cart%20&%20payment/cart.dart';
import 'package:geomedipath/screens/navigation/blood_test.dart';
import 'package:geomedipath/screens/navigation/get_a_call_back.dart';
import 'package:geomedipath/screens/navigation/product_details.dart';
import 'package:geomedipath/screens/offer_design.dart';

import 'all_colors.dart';
import 'text_design.dart';

class LeftToRightSlider extends StatefulWidget {
  List list;
  int index;
  LeftToRightSlider({Key key, this.list, this.index}) : super(key: key);

  @override
  _LeftToRightSliderState createState() => _LeftToRightSliderState();
}

class _LeftToRightSliderState extends State<LeftToRightSlider> {

  Widget slider(List list, int index) {
    double unitHeightValue = MediaQuery.of(context).size.height * 0.005;
    return InkWell(
      onTap: () {
        list[index]['btn'].toString() == "1" ? Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (context, animation, anotherAnimation) {
              return ProductDetails(id: list[index]['id'], name: list[index]['name'],);
            },
            transitionDuration: Duration(milliseconds: 300),
            transitionsBuilder:
                (context, animation, anotherAnimation, child) {
              return Align(
                child: SizeTransition(
                  sizeFactor: animation,
                  child: child,
                  axisAlignment: 0.0,
                ),
              );
            })) : null;
      },
      child: Container(
        margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
        child: Card(
          shadowColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: CachedNetworkImage(
                        imageUrl:
                        "https://app.geomedipath.com/uploads/test/${list[index]['feature_image']}",
                        width: double.infinity,
                        errorWidget: (context, url, error) => Image.asset("assets/images/image_not_found.jpg",
                          width: double.infinity,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                        ),
                        placeholder: (context, url) => Image.asset("assets/images/image_not_found.jpg",
                          width: double.infinity,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                        ),
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02,
                        vertical: MediaQuery.of(context).size.height * 0.005),
                    child: Column(
                      children: [
                        Container(
                          height: unitHeightValue * 8,
                          margin: EdgeInsets.only(top: unitHeightValue, bottom: unitHeightValue * 2),
                          width: double.infinity,
                          alignment: Alignment.centerLeft,
                          child: TextDesign(
                            align: TextAlign.left,
                            lines: 2,
                            text: list[index]['name'],
                            fontSize: unitHeightValue * 4,
                            colorName: bigTextColor,
                            fontfamily: "Roboto",
                            fontWeight: FontWeight.normal
                            ,
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.symmetric(
                        //     vertical: MediaQuery.of(context).size.height * 0.005,
                        //   ),
                        //   width: double.infinity,
                        //   alignment: Alignment.centerLeft,
                        //   child: TextDesign(
                        //     colorName: smallTextColor,
                        //     fontWeight: FontWeight.w600,
                        //     text: "Includes 55",
                        //     fontSize: unitHeightValue * 3.8,
                        //     fontfamily: "OpenSans",
                        //   ),
                        // ),
                        list[index]['price'] == null ? Container() : list[index]['btn'].toString() == "0" ? Container() : Row(
                          children: [
                            TextDesign(
                              text: "₹${list[index]['price']}",
                              fontSize: unitHeightValue * 5,
                              fontfamily: "Roboto",
                              fontWeight: FontWeight.bold,
                              colorName: bigTextColor,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.01,
                            ),
                            // Image.asset(
                            //   "assets/images/rupee.png",
                            //   width: 9,
                            //   filterQuality: FilterQuality.high,
                            // ),
                            // Text(
                            //   "2500",
                            //   style: TextStyle(
                            //     fontSize: unitHeightValue * 3.8,
                            //     decoration: TextDecoration.lineThrough,
                            //     fontFamily: "Roboto",
                            //     color: smallTextColor,
                            //   ),
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  list[index]['btn'] == null ? Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, anotherAnimation) {
                        return OfferDesign(id: list[index]['category_id']);
                      },
                      transitionDuration: Duration(milliseconds: 300),
                      transitionsBuilder:
                          (context, animation, anotherAnimation, child) {
                        return Align(
                          child: SizeTransition(
                            sizeFactor: animation,
                            child: child,
                            axisAlignment: 0.0,
                          ),
                        );
                      })) : list[index]['btn'].toString() == "1" ? Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, anotherAnimation) {
                        return ProductDetails(id: list[index]['id'], name: list[index]['name']);
                      },
                      transitionDuration: Duration(milliseconds: 300),
                      transitionsBuilder:
                          (context, animation, anotherAnimation, child) {
                        return Align(
                          child: SizeTransition(
                            sizeFactor: animation,
                            child: child,
                            axisAlignment: 0.0,
                          ),
                        );
                      })) :
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, anotherAnimation) {
                        return GetACallBack(id: list[index]['id']);
                      },
                      transitionDuration: Duration(milliseconds: 300),
                      transitionsBuilder:
                          (context, animation, anotherAnimation, child) {
                        return Align(
                          child: SizeTransition(
                            sizeFactor: animation,
                            child: child,
                            axisAlignment: 0.0,
                          ),
                        );
                      }));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.02,
                      vertical: MediaQuery.of(context).size.height * 0.007),
                  decoration: BoxDecoration(
                    color: orangeColor,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: TextDesign(
                      text: list[index]['btn'] == null ? "Select Test" : list[index]['btn'].toString() == "1" ? "Book Now" : "Get A Call Back",
                      colorName: whiteColor,
                      fontfamily: "Roboto",
                      fontSize: unitHeightValue * 5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return slider(widget.list, widget.index);
  }
}
