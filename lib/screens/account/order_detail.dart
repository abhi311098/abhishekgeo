import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/navigation/home.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class OrderDetail extends StatefulWidget {
  var id;

  OrderDetail({Key key, this.id});

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  var screenSize;
  var Font_Size;
  Stream _stream;
  StreamController _streamController;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    fetchdata();
  }

  Future fetchdata() async {
    http.Response response;
    var url = Uri.parse("https://app.geomedipath.com/App/OrderDetail/${widget.id}");
    try {
      response = await http.get(url).timeout(
          Duration(
            seconds: 15,
          ), onTimeout: () {
        return http.Response('Error', 500);
      });
      if (response.statusCode == 200) {
        setState(
              () {
                _streamController.add(jsonDecode(response.body));
          },
        );
      } else {
        setState(() {
          _streamController.add(false);
        });
      }
    } on SocketException {
      throw ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          backgroundColor: Colors.redAccent.shade700,
          content: TextDesign(
            text: 'No Internet Connection',
            colorName: Colors.white,
          ),
        ),
      );
    } on TimeoutException catch (e) {
      print('TimeoutException: $e');
    } on Error catch (e) {
      print('Error: $e');
    }
  }

  Widget topContainer(Map map) {
    List list = map['patient'];
    return Container(
      padding: EdgeInsets.fromLTRB(
        screenSize.width * 0.02,
        screenSize.height * 0.02,
        screenSize.width * 0.02,
        screenSize.height * 0.005,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenSize.width * 0.25,
                child: Text(
                  "Patient: ",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: Font_Size * 4,
                      color: smallTextColor),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.68,
                child: ListView.builder(
                  itemCount: list.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[index]['name'],
                          style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: Font_Size * 4.5,
                              color: smallTextColor),
                        ),
                        SizedBox(
                          height: screenSize.height * 0.003,
                        ),
                        Text(
                          list[index]['age'] + ", " + list[index]['gender'],
                          style: TextStyle(
                              fontFamily: "Lato",
                              fontSize: Font_Size * 4.5,
                              color: smallTextColor),
                        ),
                        list.length != index+1 ? Divider(
                          color: Colors.grey,
                        ) : Container(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenSize.width * 0.25,
                child: Text(
                  "Address",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: Font_Size * 4,
                      color: smallTextColor),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.67,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      map['address'],
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: Font_Size * 4,
                          color: smallTextColor),
                    ),
                    // Text(
                    //   address[widget.addressIndex]['phone'],
                    //   style: TextStyle(
                    //       fontFamily: "Lato",
                    //       fontSize: Font_Size * 4,
                    //       color: smallTextColor),
                    // ),
                    // Text(
                    //   address[widget.addressIndex]['address'] + " " + address[widget.addressIndex]['pin'],
                    //   style: TextStyle(
                    //       fontFamily: "Lato",
                    //       fontSize: Font_Size * 4,
                    //       color: smallTextColor),
                    // ),
                  ],
                ),
              ),
            ],
          ),
          Divider(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: screenSize.width * 0.25,
                child: Text(
                  "Date and Time: ",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontSize: Font_Size * 4,
                      color: smallTextColor),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.67,
                child: Text(
                  map['booking_date'],
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: Font_Size * 4,
                      color: smallTextColor),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget secondContainer(Map map) {
    List list = map['tests'];
    return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: screenSize.height * 0.02,
              horizontal: screenSize.width * 0.03,
            ),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: screenSize.width * 0.68,
                      child: Text(
                        list[index]['name'] + " Patient" + "(${list[index]['pt'].toString()})",
                        style: TextStyle(
                            fontFamily: "Roboto",
                            fontWeight: FontWeight.bold,
                            fontSize: Font_Size * 4.2,
                            color: bigTextColor),
                      ),
                    ),
                    SizedBox(
                      width: screenSize.width * 0.01,
                    ),
                    SizedBox(
                      width: screenSize.width * 0.25,
                      child: Text(
                        "₹${list[index]['price']}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontFamily: "Lato",
                            fontSize: Font_Size * 4.2,
                            color: bigTextColor),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        });
  }

  Widget thirdContainer(Map map) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: screenSize.height * 0.02,
        horizontal: screenSize.width * 0.03,
      ),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenSize.width * 0.68,
                child: Text(
                  "MRP  Total",
                  style: TextStyle(
                      fontFamily: "Roboto",
                      fontWeight: FontWeight.normal,
                      fontSize: Font_Size * 3.8,
                      color: smallTextColor),
                ),
              ),
              SizedBox(
                width: screenSize.width * 0.01,
              ),
              SizedBox(
                width: screenSize.width * 0.25,
                child: Text(
                  "₹${map['total_price'].toString()}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontWeight: FontWeight.normal,
                      fontSize: Font_Size * 3.8,
                      color: smallTextColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    Font_Size = screenSize.height * 0.005;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        automaticallyImplyLeading: true,
        title: TextDesign(
          text: "Order Detail",
          colorName: Colors.white,
          fontSize: Font_Size * 5,
        ),
      ),
      backgroundColor: background,
      body: StreamBuilder<Object>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              print(snapshot.connectionState);
              return Center(child: CircularProgressIndicator());
            }
            else if (snapshot.data == false) {
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

            print(snapshot.data.runtimeType);
            Map map = snapshot.data;
            return SingleChildScrollView(
              child: Column(
                children: [
                  topContainer(map),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  secondContainer(map),
                  SizedBox(
                    height: screenSize.height * 0.02,
                  ),
                  thirdContainer(map),
                ],
              ),
            );
          }),
    );
  }
}


