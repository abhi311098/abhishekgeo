import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/cart%20&%20payment/cart.dart';
import 'package:geomedipath/screens/navigation/home.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetails extends StatefulWidget {
  var name;
  var id;

  ProductDetails({Key key, this.id, this.name}) : super(key: key);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Stream _stream;
  StreamController _streamController;

  var load = false;

  var unitHeight;

  Widget titleandprice(String name, String price)
  {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      color: whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            textScaleFactor: 0.85,
            style: TextStyle(
                color: bigTextColor,
                fontWeight: FontWeight.normal,
                fontFamily: "Lato",
                fontSize: unitHeight * 5.5),
          ),
          SizedBox(
            height: unitHeight,
          ),
              Text(
                "₹$price",
                textScaleFactor: 0.85,
                style: TextStyle(
                    color: bigTextColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: "Roboto",
                    fontSize: unitHeight * 6),
              ),
        ],
      ),
    );
  }

  Widget overView(String overview) {
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      color: whiteColor,
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.03,
        vertical: MediaQuery.of(context).size.height * 0.01,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Overview",
            textScaleFactor: 0.85,
            style: TextStyle(
                color: bigTextColor,
                fontWeight: FontWeight.bold,
                fontFamily: "Roboto",
                fontSize: unitHeight * 6),
          ),
          SizedBox(
            height: unitHeight,
          ),
          Text(
            overview,
            textScaleFactor: 0.85,
            style: TextStyle(
                color: smallTextColor,
                fontWeight: FontWeight.w600,
                fontFamily: "Lato",
                fontSize: unitHeight * 5),
          ),
        ],
      ),
    );
  }

  Future fetchData() async {
    print("id ${widget.id}");
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/TestDetail/${widget.id}",
    );
    response = await http
        .get(
      url,
    )
        .timeout(
            Duration(
              seconds: 30,
            ), onTimeout: () {
      return http.Response('Error', 500);
    });
    if (response.statusCode == 200) {
      setState(() {
        print(jsonDecode(response.body));
        _streamController.add(jsonDecode(response.body));
      });
    } else {
      setState(() {
        _streamController.add(false);
      });
    }
  }

  Future provideData(var amount) async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Cart/",
    );
    print(url);
    var dataReturn;
    response = await http
        .post(
      url,body: {
        "user_id": logintoken,
      "test_id": widget.id,
      "price": amount.toString(),
      "type":"test",
    }
    )
        .timeout(
            Duration(
              seconds: 30,
            ), onTimeout: () {
      return http.Response('Error', 500);
    });
    if (response.statusCode == 200) {
      setState(() {
        dataReturn = jsonDecode(response.body);
      });
    } else {
      setState(() {
        dataReturn = false;
      });
    }
    return dataReturn;
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    unitHeight = MediaQuery.of(context).size.height * 0.005;
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          Home()), (Route<dynamic> route) => false),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: orangeColor,
          automaticallyImplyLeading: true,
          title: TextDesign(
            text: widget.name,
            colorName: whiteColor,
            fontSize: unitHeight * 5,
          ),
        ),
        backgroundColor: background,
        body: StreamBuilder<Object>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.data == false) {
                return Center(
                  child: Text(
                    "No Data Found",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                );
              } else if (load == true) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              List list = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Swiper(
                              autoplay: true,
                              duration: 5,
                              itemWidth: double.infinity,
                              itemHeight:
                                  MediaQuery.of(context).size.height * 0.25,
                              itemCount: 1,
                              pagination: SwiperPagination(
                                  builder: SwiperPagination.dots),
                              itemBuilder: (context, index) => CachedNetworkImage(
                                imageUrl:
                                    "https://app.geomedipath.com/uploads/test/${list[0]['feature_image']}",
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
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          titleandprice(
                            list[0]['name'],
                            list[0]['price'],
                          ),
                          overView(list[0]['overview']),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 1,
                    height: MediaQuery.of(context).size.height * 0.08,
                    color: whiteColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.03,
                      vertical: MediaQuery.of(context).size.height * 0.01,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Text(
                            "₹${list[0]['price']}",
                            textScaleFactor: 0.85,
                            style: TextStyle(
                                color: bigTextColor,
                                fontWeight: FontWeight.w600,
                                fontFamily: "OpenSans",
                                fontSize: unitHeight * 6),
                          ),
                        ]),

                        InkWell(
                          onTap: () {
                            provideData(list[0]['price']).then((value) {
                              if(value == false) {
                                Fluttertoast.showToast(msg: "Failed to Add");
                              } else {
                                Fluttertoast.showToast(msg: "Product Added");
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart()));
                              }
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                                vertical: MediaQuery.of(context).size.height *
                                    0.02),
                            decoration: BoxDecoration(
                              color: orangeColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextDesign(
                              text: "Add To Cart",
                              colorName: whiteColor,
                              fontSize: 5 * unitHeight,
                              fontfamily: "Roboto",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}
