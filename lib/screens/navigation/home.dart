import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geomedipath/screens/cart%20&%20payment/cart.dart';
import 'package:geomedipath/screens/navigation/blood_test.dart';
import 'package:geomedipath/screens/navigation/search_bar.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/button_design.dart';
import 'package:geomedipath/widgets/card_design.dart';
import 'package:geomedipath/widgets/horizontal_container.dart';
import 'package:geomedipath/widgets/left%20_to_right_slider.dart';
import 'package:geomedipath/widgets/main_drawer.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _chosenValue;

  Stream _stream;
  StreamController _streamController;
  List blood_test_list;
  var blood_test_status = true;
  List radiology_test_list;
  var radiology_test_status = true;

  var load = false;

  int cartCount = 0;

  Future fetchData() async {
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Slider",
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

  Future fetchData3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    print(


      "Abhishek $logintoken"
    );
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/CartCount/$logintoken",
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
        cartCount = jsonDecode(response.body);
      });
    } else {
      setState(() {
        cartCount = 0;
      });
    }
  }

  Future fetchData1() async {
    setState(() {
      load = true;
    });
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Category",
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
        blood_test_list = jsonDecode(response.body);
        print(blood_test_list.length);
        load = false;
      });
    } else {
      setState(() {
        blood_test_status = false;
        load = false;
      });
    }
  }

  Future fetchData2(var id) async {
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Product/$id",
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
        radiology_test_list = jsonDecode(response.body);
        print(radiology_test_list.length);
        load = false;
      });
    } else {
      setState(() {
        radiology_test_status = false;
        load = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    fetchData();
    fetchData1();
    fetchData3();
  }

  Widget ss(BuildContext context, index) {
    return InkWell(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Card(
          color: Colors.white,
          child: Stack(
            children: [
              Image.asset("images/logo.png"),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.087),
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.051,
                child: Text(
                  "['Title']",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: smallTextColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    double aa = MediaQuery.of(context).size.height * 0.17;
    double unitHeight = MediaQuery.of(context).size.height * 0.005;
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        drawer: MainDrawer(),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(aa),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppBar(
                  backgroundColor: orangeColor,
                  title: Text(
                    "Geomedipath",
                  ),
                  actions: [
                    Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => Cart()));
                          },
                          icon: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          )),
                        Positioned(
                          right: MediaQuery.of(context).size.width * 0.0,
                          left: MediaQuery.of(context).size.width * 0.05,
                          top: MediaQuery.of(context).size.height * 0.003,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.005,
                              vertical: MediaQuery.of(context).size.height * 0.002,
                            ),
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * 0.2,
                            height: MediaQuery.of(context).size.height * 0.03,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: redColor,
                            ),
                            child: FittedBox(
                              child: TextDesign(
                                text: cartCount.toString(),
                              ),
                            ),
                          ),
                        ),
                      ]
                    ),
                  ],
                ),
                Container(
                  color: orangeColor,
                  width: MediaQuery.of(context).size.width * 1,
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * 0.02,
                      horizontal: MediaQuery.of(context).size.height * 0.02),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => SearchBar(type: "",)));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.width * 0.02,
                          horizontal: MediaQuery.of(context).size.height * 0.01),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.06,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.black,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.02,
                          ),
                          Text("Search Test")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
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
              List slider = snapshot.data;
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Swiper(
                          autoplay: true,
                          duration: 5,
                          itemWidth: double.infinity,
                          itemHeight: MediaQuery.of(context).size.height * 0.25,
                          itemCount: slider.length,
                          pagination:
                              SwiperPagination(builder: SwiperPagination.dots),
                          itemBuilder: (context, index) => CachedNetworkImage(
                            imageUrl:
                                "https://app.geomedipath.com/uploads/slider/${slider[index]['image']}",
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
                      blood_test_status == false
                          ? Container()
                          : Flexible(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  itemCount: blood_test_list.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          blood_test_list[index]['category']
                                              ['category_name'],
                                          style: TextStyle(
                                              fontSize: unitHeight * 5,
                                              fontFamily: "Roboto",
                                              color: bigTextColor),
                                        ),
                                        blood_test_list[index]['tests'].length ==
                                                0
                                            ? Container()
                                            : Container(
                                                margin: EdgeInsets.only(
                                                  //horizontal: MediaQuery.of(context).size.width * 0.02,
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.015,
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.31,
                                                padding: EdgeInsets.symmetric(
                                                  //horizontal: MediaQuery.of(context).size.width * 0.02,
                                                  vertical: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.01,
                                                ),
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemBuilder: (context, index1) {
                                                    // List first = blood_test_list[index]['usp'];
                                                    // List second = blood_test_list[index]['tests'];
                                                    // List second1 = first.length == 0 ? second : first + second;
                                                    // print("tests $second1");
                                                    return Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.42,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.25,
                                                      child: LeftToRightSlider(
                                                        list:
                                                        blood_test_list[index]['usp'].length != 0 ? blood_test_list[index]['usp'] + (blood_test_list[index]['tests'])  : blood_test_list[index]
                                                                ['tests'],
                                                        index: index1,
                                                      ),
                                                    );
                                                  },
                                                  itemCount:
                                                      blood_test_list[index]['usp'].length != 0 ? blood_test_list[index]['usp'].length + blood_test_list[index]['tests'].length : blood_test_list[index]
                                                              ['tests']
                                                          .length,
                                                ),
                                              ),
                                      ],
                                    );
                                  }),
                            ),

                      slider.isEmpty
                          ? Container()
                          : Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.03,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.01,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "https://app.geomedipath.com/uploads/slider/${slider[3]['image']}",
                                  width: double.infinity,
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  filterQuality: FilterQuality.high,
                                  placeholder: (context, url) => Image.asset(
                                    "assets/images/image_not_found.jpg",
                                    width: double.infinity,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fill,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    "assets/images/image_not_found.jpg",
                                    width: double.infinity,
                                    filterQuality: FilterQuality.high,
                                    fit: BoxFit.fill,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),

                      // Container(
                      //   width: double.infinity,
                      //   height: MediaQuery.of(context).size.height * 0.33,
                      //   child: HorizontalContainer(),
                      // ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
