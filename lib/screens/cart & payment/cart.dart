import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geomedipath/screens/account/address.dart';
import 'package:geomedipath/screens/cart%20&%20payment/manage_patient.dart';
import 'package:geomedipath/screens/cart%20&%20payment/time_slot.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Cart extends StatefulWidget {
  const Cart({Key key}) : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  Stream _stream;
  StreamController _streamController;

  bool load = false;

  Future fetchData() async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    print("logintoken $logintoken");
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Cart/$logintoken",
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
      _streamController.add("false");
    }
    //return jsonDecode(response.body);
  }

  Future provideData(var id) async {
    setState(() {
      load = true;
    });
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Cart/$id}",
    );
    print(url);
    var dataReturn;
    response = await http
        .delete(
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
        fetchData();
        load = false;
      });
    } else {
      setState(() {
        fetchData();
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
  }

  @override
  Widget build(BuildContext context) {
    var screenSizer = MediaQuery.of(context).size;
    var unitHeight = MediaQuery.of(context).size.height * 0.005;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        automaticallyImplyLeading: true,
        title: TextDesign(
          text: "Cart",
          colorName: Colors.white,
          fontSize: unitHeight * 5,
        ),
      ),
      backgroundColor: background,
      body: StreamBuilder<Object>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print(snapshot.connectionState);
              return Center(child: CircularProgressIndicator());
            } else if (load == true) {
              return Center(child: CircularProgressIndicator());
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
            print(snapshot.connectionState);
            Map map = snapshot.data;
            List list = map['cart'];
            if (list.length == 0) {
              return Center(
                child: Text(
                  "Cart is empty",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenSizer.width * 1,
                    height: screenSizer.height * 0.78,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 2,
                          color: Colors.white,
                          margin: EdgeInsets.symmetric(
                              horizontal: screenSizer.width * 0.02,
                              vertical: screenSizer.height * 0.01),
                          child: Container(
                            width: screenSizer.width * 1,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSizer.width * 0.02,
                              vertical: screenSizer.height * 0.01,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: screenSizer.width * 0.75,
                                      child: Text(
                                        list[index]['name'],
                                        style: TextStyle(
                                          fontSize: unitHeight * 4.5,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                    Container(
                                        width: screenSizer.width * 0.17,
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "₹${list[index]['price']}",
                                          style: TextStyle(
                                            fontSize: unitHeight * 4.5,
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(
                                  height: screenSizer.height * 0.02,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        provideData(list[index]['id']);
                                      },
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: null,
                                              icon: Icon(
                                                Icons.delete_rounded,
                                                color: Colors.grey.shade400,
                                              )),
                                          Text(
                                            "Remove",
                                            style: TextStyle(
                                                fontSize: unitHeight * 4.5,
                                                color: Colors.grey.shade600),
                                          )
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) => ManagePatient(
                                                id: list[index]['id']),
                                          ),
                                        );
                                      },
                                      child: list[index]['pt'].toString() != "0"
                                          ? Text(
                                              "${list[index]['pt']} Patient",
                                              style: TextStyle(
                                                  fontSize: unitHeight * 4.5,
                                                  color: Colors.red.shade600),
                                            )
                                          : Text(
                                              "+Add Patient",
                                              style: TextStyle(
                                                  fontSize: unitHeight * 4.5,
                                                  color: Colors.red.shade600),
                                            ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  map['btn']
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TimeSlot()));
                          },
                          highlightColor: whiteColor,
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                    MediaQuery.of(context).size.width * 0.02,
                                vertical:
                                    MediaQuery.of(context).size.height * 0.02),
                            decoration: BoxDecoration(
                              color: orangeColor,
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: TextDesign(
                              text: "Schedule",
                              colorName: whiteColor,
                              fontSize: 5 * unitHeight,
                              fontfamily: "Roboto",
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.02,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02),
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.02,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.02),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "Add Patient in all test",
                            style: TextStyle(
                              fontSize: unitHeight * 4.5,
                            ),
                          ),
                        ),
                ],
              ),
            );
          }),
    );
  }
}
