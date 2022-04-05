import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomedipath/screens/navigation/search_bar.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'cart & payment/cart.dart';
import 'navigation/get_a_call_back.dart';
import 'navigation/home.dart';
import 'navigation/product_details.dart';

class NineHundredSearch extends StatefulWidget {
  var id;

  NineHundredSearch({Key key, this.id}) : super(key: key);

  @override
  State<NineHundredSearch> createState() => _NineHundredSearchState();
}

class _NineHundredSearchState extends State<NineHundredSearch> {
  Stream _stream;
  StreamController _streamController;

  Future fetchData() async {
    http.Response response;
    var url = Uri.parse(
        "https://app.geomedipath.com/App/ItemSearch/");
    response = await http
        .post(
      url,
      body: {
        "keyword": widget.id,
      }
    )
        .timeout(
        Duration(
          seconds: 30,
        ), onTimeout: () {
      return http.Response('Error', 500);
    });
    if (response.statusCode == 200) {
      setState(
            () {
          _streamController.add(jsonDecode(response.body));
          //load = false;
        },
      );
    } else {
      setState(() {
        _streamController.add(false);
        //load = false;
      });
    }
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
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          Home()), (Route<dynamic> route) => false),
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: FloatingActionButton.extended(
              backgroundColor: Colors.redAccent,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Cart()));
              }, label: TextDesign(text: "Cart", fontSize: (MediaQuery.of(context).size.height * 0.005) * 5 ,
            fontWeight: FontWeight.bold,
            fontfamily: "Roboto",)
          ),
          appBar: AppBar(
            backgroundColor: orangeColor,
            automaticallyImplyLeading: true,
            // title: TextDesign(
            //   text: widget.name,
            //   colorName: whiteColor,
            //   fontSize: unitHeight * 5,
            // ),
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SearchBar(
                        type: "nine",
                      ))),
                  icon: Icon(CupertinoIcons.search))
            ],
          ),
          backgroundColor: background,
          body: StreamBuilder(
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
                }
                List list = snapshot.data;
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
                  itemBuilder: (context, index) =>
                      DataDesign(list: list, index: index),
                );
              })),
    );
  }
}

class DataDesign extends StatefulWidget {
  List list;
  int index;

  DataDesign({Key key, this.list, this.index}) : super(key: key);

  @override
  State<DataDesign> createState() => _DataDesignState();
}

class _DataDesignState extends State<DataDesign> {
  var unitHeightValue;

  bool type = false;

  Future provideData(var item_id, var amount) async {
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
      "type": "item",
    }).timeout(
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

  Widget cardDesign({List list, int index}) {
    return Container(
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.02,
                      vertical: MediaQuery.of(context).size.height * 0.005),
                  child: Column(
                    children: [
                      Container(
                        height: unitHeightValue * 18,
                        margin: EdgeInsets.only(
                            top: unitHeightValue, bottom: unitHeightValue * 2),
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        child: TextDesign(
                          align: TextAlign.left,
                          lines: 3,
                          text: list[index]['name'],
                          fontSize: unitHeightValue * 5,
                          colorName: bigTextColor,
                          fontfamily: "Roboto",
                          fontWeight: FontWeight.normal,
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
                      Row(
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
                          list[index]['dis_price'].toString() == "" ? Container() :
                          Text(
                            "₹${list[index]['dis_price'].toString()}",
                            style: TextStyle(
                              fontSize: unitHeightValue * 3.8,
                              decoration: TextDecoration.lineThrough,
                              fontFamily: "Roboto",
                              color: smallTextColor,
                              decorationColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                setState(() {
                  type = true;
                });
                provideData(list[index]['id'], list[index]['price'])
                    .then((value) {
                  print("value $value");
                });
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
                    text: type ? "Added" : "Add To Cart",
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
    );
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.005;
    return cardDesign(
      list: widget.list,
      index: widget.index,
    );
  }
}
