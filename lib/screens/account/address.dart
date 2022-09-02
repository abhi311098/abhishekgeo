import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/cart%20&%20payment/billing_information.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_address.dart';

class Address extends StatefulWidget {
  bool buttonShow;
  String date, time;
  bool routeFromTimeslot;
  Address({this.date, this.time, this.buttonShow, this.routeFromTimeslot});

  @override
  _AddressState createState() => _AddressState();
}

class _AddressState extends State<Address> {
  Stream _stream;
  String addressid;
  StreamController _streamController;
  bool net = true;
  bool loader = false;
  bool buttonShow;

  Future fetchdata() async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    var url = Uri.parse("https://app.geomedipath.com/App/Address/$logintoken");
    setState(() {
      net = true;
    });
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
      setState(() {
        net = false;
      });
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

  Future provideData3(var addressId) async {
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Address/$addressId",
    );
    response = await http.delete(
      url,
    );
    return response.body;
  }

  int selectIndex = 0;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    buttonShow = widget.buttonShow;
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    print("Address => ${widget.routeFromTimeslot}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        automaticallyImplyLeading: true,
        title: TextDesign(
          text: "Address",
          colorName: Colors.white,
          fontSize: MediaQuery.of(context).size.height * 0.005 * 5,
        ),
      ),
        backgroundColor: background,
      body: StreamBuilder<Object>(
          stream: _stream,
          builder: (context, snapshot) {
            if (net == false) {
              return Center(
                child: ElevatedButton(
                  child: TextDesign(
                    text: "Try Again",
                    fontSize: 20,
                    colorName: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  onPressed: () {
                    setState(() {
                      fetchdata();
                    });
                  },
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (loader) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: TextDesign(
                  text: snapshot.error.toString(),
                  fontSize: 20,
                ),
              );
            }
            if (snapshot.data == false) {
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
            //Map map = ;
            List list = snapshot.data;
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditAddress(
                          newAddress: "new",
                          addressId: "0",
                          routeFromTimeslot: widget.routeFromTimeslot,
                        ),
                      ),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.05,
                          vertical: MediaQuery.of(context).size.height * 0.01),
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.1,
                      color: Colors.grey.shade50,
                      alignment: Alignment.centerLeft,
                      child: TextDesign(
                        text: "+ Add a new address",
                        colorName: Colors.blue,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        align: TextAlign.left,
                      ),
                    ),
                  ),
                  list.length == 3
                      ? Container()
                      : SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                  // Container(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: MediaQuery.of(context).size.width * 0.05,
                  //   ),
                  //   width: double.infinity,
                  //   child: TextDesign(
                  //     text: "${list.length} Saved Address",
                  //     colorName: smallTextColor,
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w500,
                  //     align: TextAlign.left,
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: MediaQuery.of(context).size.height * 0.02,
                  // ),
                  ListView.builder(
                    itemCount: list.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => Card(
                      elevation: 4,
                      color: Colors.white,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02),
                      child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height * 0.01,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * 0.02,
                          vertical: MediaQuery.of(context).size.height * 0.02,
                        ),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  child: Text(
                                    list[index]['name'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                buttonShow == true
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectIndex = index;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                            right: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.04,
                                          ),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.04,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          color: index == selectIndex
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextDesign(
                                  text: list[index]['phone'],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  colorName: Colors.black54,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.01,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => EditAddress(
                                          newAddress: "edit",
                                          addressId: list[index]['id'],
                                            routeFromTimeslot: widget.routeFromTimeslot,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.03),
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Text(
                                    list[index]['address'] +
                                        ", " +
                                        list[index]['pin'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),


                                InkWell(
                                    onTap: () {
                                      setState(() {
                                        loader = true;
                                      });
                                      provideData3(list[index]['id'])
                                          .then((value) {
                                        if (value.toString() == "true") {
                                          setState(() {
                                            loader = false;
                                            fetchdata();
                                          });
                                        } else {
                                          setState(() {
                                            loader = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg: "Failed to delete address");
                                        }
                                      });
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          // vertical:
                                          // MediaQuery.of(context).size.height *
                                          //     0.01,
                                          horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.03),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.red.shade400,
                                      ),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Text(
                              list[index]['type'],
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  list.length == 0
                      ? Container()
                      : buttonShow == true
                          ? InkWell(
                    highlightColor: Colors.white,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => BillingInformation(date: widget.date, time: widget.time, addressIndex: selectIndex, address_id: list[selectIndex]['id']),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.03),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.015),
                                decoration: BoxDecoration(
                                  color: orangeColor,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextDesign(
                                      align: TextAlign.center,
                                      text: "Check Out",
                                      fontSize: 18,
                                      colorName: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                ],
              ),
            );
          }),
    );
  }
}
