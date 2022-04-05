import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geomedipath/screens/navigation/blood_test.dart';
import 'package:geomedipath/screens/navigation/get_a_call_back.dart';
import 'package:geomedipath/screens/navigation/product_details.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'all_colors.dart';

class CardDesign extends StatefulWidget {
  List list;
  int number;

  CardDesign({this.list, this.number});

  @override
  _CardDesignState createState() => _CardDesignState();
}

class _CardDesignState extends State<CardDesign> {
  List list;
  int number;
  var unitHeightValue;

  @override
  void initState() {
    super.initState();
    print("card $number");
    number = widget.number;
    list = widget.list;
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.005;
    return GridView.builder(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.01),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return SearchDesign(list: list, index: index,);
      },
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisExtent: MediaQuery.of(context).size.height * 0.29,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
    );
  }
}

class SearchDesign extends StatefulWidget {
  List list;
  int index;

  SearchDesign({Key key, this.index, this.list}) : super(key: key);

  @override
  State<SearchDesign> createState() => _SearchDesignState();
}

class _SearchDesignState extends State<SearchDesign> {
  List list;
  int index;
  var unitHeightValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list = widget.list;
    index = widget.index;
  }
  bool type1 = false;
  bool type2 = false;

  Future provideData(var item_id, var amount, var typeData) async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Cart/",
    );
    print(url);
    var dataReturn;
    response = await http.post(url, body: {
      "user_id": logintoken,
      "test_id": item_id.toString(),
      "price": amount.toString(),
      "type": typeData,
    }).timeout(
        Duration(
          seconds: 30,
        ), onTimeout: () {
      return http.Response('Error', 500);
    });
    if (response.statusCode == 200) {
      setState(() {
        dataReturn = jsonDecode(response.body);
        print("Mohit res $dataReturn");
      });
    } else {
      setState(() {
        dataReturn = false;
      });
    }
    return dataReturn;
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.005;
    print("Abhishek ${list}");
    return InkWell(
      child: Container(
        margin:
        EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.01),
        child: Card(
          shadowColor: Colors.black87,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                highlightColor: Colors.white,
                onTap: () {
                  list[index]['btn'].toString() == "1"
                      ? Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (context, animation, anotherAnimation) {
                        return ProductDetails(
                            id: list[index]['id'], name: list[index]['name']);
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
                      }))
                      : null;
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: CachedNetworkImage(
                          imageUrl:
                          "https://app.geomedipath.com/uploads/test/${list[index]['feature_image']}",
                          placeholder: (context, url) => Image.asset(
                            "assets/images/image_not_found.jpg",
                            width: double.infinity,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.fill,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            "assets/images/image_not_found.jpg",
                            width: double.infinity,
                            filterQuality: FilterQuality.high,
                            fit: BoxFit.fill,
                          ),
                          width: double.infinity,
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: MediaQuery.of(context).size.height * 0.005),
                      child: Column(
                        children: [
                          Container(
                            height: unitHeightValue * 8,
                            margin: EdgeInsets.only(top: unitHeightValue),
                            width: double.infinity,
                            alignment: Alignment.centerLeft,
                            child: TextDesign(
                              lines: 2,
                              text: list[index]['name'],
                              fontSize: unitHeightValue * 4,
                              colorName: bigTextColor,
                              fontfamily: "Roboto",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // Container(
                          //   margin: EdgeInsets.symmetric(
                          //     vertical:
                          //         MediaQuery.of(context).size.height * 0.005,
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
                          list[index]['btn'].toString() == "0" ? Container() : Row(
                            children: [
                              TextDesign(
                                text: "₹${list[index]['price']}",
                                fontSize: unitHeightValue * 4.5,
                                fontfamily: "Roboto",
                                fontWeight: FontWeight.bold,
                                colorName: bigTextColor,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              list[index]['dis_price'].toString() == "" ? Container() : Text(
                                "₹${list[index]['dis_price'].toString()}",
                                style: TextStyle(
                                  fontSize: unitHeightValue * 3.8,
                                  decoration: TextDecoration.lineThrough,
                                  fontFamily: "Roboto",
                                  color: smallTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {

                        if (list[index]['btn'].toString() == "1") {
                          setState(() {
                            type1 = true;
                            provideData(list[index]['id'].toString(), list[index]['price'].toString(), "test");
                          });
                        } else if (list[index]['btn'].toString() == "2") {
                          setState(() {
                            type2 = true;
                            provideData(list[index]['id'].toString(), list[index]['price'].toString(), "item");
                          });
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => GetACallBack(id: list[index]['id'].toString(),)));
                        }

                  },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                      vertical: MediaQuery.of(context).size.height * 0.007),
                  decoration: BoxDecoration(
                    color: orangeColor,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: TextDesign(
                      text: type1 ? "Booked" : list[index]['btn'].toString() == "1"
                          ? "Book Now"
                          : type2 ? "Added" :list[index]['btn'].toString() == "2"
                            ? "Add To Cart"
                            : "Get A Call Back",
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
}
