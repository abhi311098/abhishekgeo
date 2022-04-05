import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geomedipath/screens/account/order_detail.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key key}) : super(key: key);

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  var unitHeight;
  var w;
  var h;
  Stream _stream;
  StreamController _streamController;

  _launchURL(var index) async {
    var url = 'https://app.geomedipath.com/uploads/post/$index';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future fetchdata() async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    var url = Uri.parse(
      "https://app.geomedipath.com/App/MyOrders/$logintoken",
    );
    try {
      response = await http.get(url);
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
          content: Text('No Internet Connection',),
        ),
      );
    } on TimeoutException catch (e) {
      print('TimeoutException: $e');
    } on Error catch (e) {
      print('Error: $e');
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    fetchdata();
  }


  Widget cardDesign(ctx, index, list) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        vertical: h * 0.007,
        horizontal: w * 0.03,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: h * 0.02,
          horizontal: w * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    TextDesign(text: "Invoice No.",fontWeight: FontWeight.w600, fontSize: unitHeight * 4.5,),
                    TextDesign(text: list[index]['invoice'],fontWeight: FontWeight.w500, fontSize: unitHeight * 4,),
                  ],
                ),
                Column(
                  children: [
                    TextDesign(text: "Payment Status",fontWeight: FontWeight.w600, fontSize: unitHeight * 4.5,),
                    TextDesign(text: list[index]['payment_status'],fontWeight: FontWeight.w500, fontSize: unitHeight * 4,),
                  ],
                ),
                Column(
                  children: [
                    TextDesign(text: "Amount",fontWeight: FontWeight.w600, fontSize: unitHeight * 4.5,),
                    TextDesign(text: "₹${list[index]['price']}",fontWeight: FontWeight.w500, fontSize: unitHeight * 4,),
                  ],
                ),
              ],
            ),
            Container(
              width: w * 1,
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => OrderDetail(id: list[index]['id'],)));
                },
                child: TextDesign(text: "View Details",fontWeight: FontWeight.bold, fontSize: unitHeight * 4,),
              ),
            ),
            list[index]['reports'].length == 0 ? Container() : TextDesign(text: "Report",fontWeight: FontWeight.w600, fontSize: unitHeight * 4,),
            list[index]['reports'].length == 0 ? Container() : Container(
              width: w * 1,
              height: h * 0.1,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: list[1]['reports'].length,
                  itemBuilder: (ctx, index1) {
                    return IconButton(onPressed: () {
                      _launchURL(list[index]['reports'][index1]);
                    }, icon: Icon(Icons.picture_as_pdf_rounded, color: Colors.red,));
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    w = MediaQuery.of(context).size.width;
    h = MediaQuery.of(context).size.height;
    unitHeight = h * 0.005;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        automaticallyImplyLeading: true,
        title: TextDesign(
          text: "My Order",
          colorName: whiteColor,
          fontSize: unitHeight * 5,
        ),
      ),
      backgroundColor: background,
      body: StreamBuilder<dynamic>(
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
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          List list = snapshot.data;
          return list.length == 0 ? Center(child: TextDesign(text: "No Data Found", fontSize: unitHeight * 5, fontWeight: FontWeight.bold, fontfamily: "Roboto",),) : ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
            return cardDesign(context, index, list);
          });
        }
      ),
    );
  }
}
