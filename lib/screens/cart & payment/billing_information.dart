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
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'success_order.dart';

class BillingInformation extends StatefulWidget {
  String date, time;
  int addressIndex;
  var address_id;

  BillingInformation({Key key, this.time, this.date, this.addressIndex, address_id}) : super(key: key);

  @override
  _BillingInformationState createState() => _BillingInformationState();
}

class _BillingInformationState extends State<BillingInformation> {
  var screenSize;
  var Font_Size;
  Stream _stream;
  StreamController _streamController;
  List address;
  String paymentId = "";
  bool load;
  String price;
  String _site = "Online";
  Map map;
  static const platform = const MethodChannel("razorpay_flutter");

  Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    fetchData();
    fetchdata();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openCheckout(var price1) async {
    var options = {
      'key': 'rzp_live_Z9QHVIOMaQ1C13',
      'amount': int.parse(price1)* 100,
      'name': 'Geomedipath',
      'description': 'geomedipath',
      //'retry': {'enabled': true, 'max_count': 1},
      // 'send_sms_hash': true,
      //'prefill': {'contact': userMobile, 'email': userEmail},
      // 'external': {
      //   'wallets': ['paytm']
      //}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("abhi ${response.orderId}");
    print("abhi ${response.signature}");
    print("abhi ${response.paymentId}");
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.lightBlue.shade100,
        fontSize: 18,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.black);
    setState(() {
      paymentId = response.paymentId.toString();
    });
    providedata(map['total_price'].toString());
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("abhi ${response.code}");
    print("abhi ${response.message}");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Home()));
    Fluttertoast.showToast(
        msg: "Please proceed with the payment to book your order",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.lightBlue.shade100,
        fontSize: 18,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.black);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("abhi ${response.walletName}");
    setState(() {
      // = response.walletName;
    });
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.lightBlue.shade100,
        fontSize: 18,
        gravity: ToastGravity.BOTTOM,
        textColor: Colors.black);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future providedata(amount) async {
    setState(() {
      load = true;
    });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String login = prefs.getString("logintoken");
      http.Response response;
      var url = Uri.parse(
        "https://app.geomedipath.com/App/Checkout",
      );
      print("Abhishek ${login}");
      print("Abhishek ${address[widget.addressIndex]['id']}");
      print("Abhishek ${widget.time}");
      print("Abhishek ${widget.date}");
      print("Abhishek ${amount}");
      print("Abhishek ${paymentId}");

      response = await http.post(url, body: {
        "user_id": login,
        "address_id": "${address[widget.addressIndex]['id']}",
        "slot": "${widget.time}",
        "booking_date": "${widget.date}",
        "price": amount,
        "payment_id": paymentId
      });
      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        print("Abhishek res$res");
        if (res['status'].toString() == "true") {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => SuccessOrder(),
            ),
          );
          Fluttertoast.showToast(
              msg: "Order Successfully Done",
              backgroundColor: Colors.lightBlue.shade100,
              fontSize: 18,
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.black);
        } else {
          Fluttertoast.showToast(
              msg: "Try Again",
              backgroundColor: Colors.lightBlue.shade100,
              fontSize: 18,
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.black);
        }
        setState(() {
          load = false;
        });
      }
    } catch (e) {
      setState(() {
        load = false;
      });
      print(e);
    }
  }

  Future fetchData() async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Checkout/$logintoken",
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

  Future fetchdata() async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    var url = Uri.parse("https://app.geomedipath.com/App/Address/$logintoken");
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
            address = jsonDecode(response.body);
          },
        );
      } else {
        setState(() {

          address = [];
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
                      address[widget.addressIndex]['name'],
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: Font_Size * 4,
                          color: smallTextColor),
                    ),
                    Text(
                      address[widget.addressIndex]['phone'],
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: Font_Size * 4,
                          color: smallTextColor),
                    ),
                    Text(
                      address[widget.addressIndex]['address'] + " " + address[widget.addressIndex]['pin'],
                      style: TextStyle(
                          fontFamily: "Lato",
                          fontSize: Font_Size * 4,
                          color: smallTextColor),
                    ),
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
                  widget.date+ "\n" +widget.time,
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
                        list[index]['name'],
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
          SizedBox(
            height: screenSize.height * 0.01,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: screenSize.width * 0.68,
                child: Text(
                  "TO BE PAID",
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
                  "₹${map['total_price'].toString()}",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      fontFamily: "Lato",
                      fontSize: Font_Size * 4.2,
                      color: bigTextColor),
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
          text: "Order Summary",
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
            // else if (load == true) {
            //   return Center(child: CircularProgressIndicator());
            // }
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
            map = snapshot.data;
              price = map['total_price'].toString();
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
                  Card(
                    semanticContainer: true,
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                MediaQuery.of(context).size.width * 0.03,
                                vertical:
                                MediaQuery.of(context).size.height * 0.01),
                            child: TextDesign(
                              align: TextAlign.left,
                              text: "Payment Option",
                              fontSize: 18,
                              colorName: Colors.black,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text('Online'),
                                  leading: Radio(
                                    value: "Online",
                                    groupValue: _site,
                                    onChanged: (value) {
                                      setState(() {
                                        _site = value;
                                        print("_site 1 $_site");
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: Text('Cash On Collection'),
                                  leading: Radio(
                                    value: "Cash On Collection",
                                    groupValue: _site,
                                    onChanged: (value) {
                                      setState(() {
                                        _site = value;
                                        print("_site 2 $_site");
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  InkWell(
                    highlightColor: Colors.white,
                    onTap: () {
                      _site == "Online" ?
                     openCheckout(map['total_price'].toString()) : providedata(map['total_price'].toString()).then((value) {
                       if(value) {
                         Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Home()
                         ), (route) => false);
                       } else {
                         return Fluttertoast.showToast(msg: "Try Again");
                       }
                      });
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
                ],
              ),
            );
          }),
    );
  }
}


