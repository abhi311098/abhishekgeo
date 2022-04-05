import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geomedipath/screens/navigation/home.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/card_design.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;

class BloodTest extends StatefulWidget {
  String id;
  String name;
  bool search;

  BloodTest({this.name, this.id, this.search});

  @override
  _BloodTestState createState() => _BloodTestState();
}

class _BloodTestState extends State<BloodTest> {
  Stream _stream;
  StreamController _streamController;

  List blood_test_list;

  var unitHeight;

  var load = false;

  Future fetchData() async {
    http.Response response;
    var url = widget.search
        ? Uri.parse("https://app.geomedipath.com/App/Search")
        : Uri.parse(
            "https://app.geomedipath.com/App/TestByCategory/${widget.id}",
          );
    response = widget.search
        ? await http.post(url, body: {"keyword": widget.id}).timeout(
            Duration(
              seconds: 30,
            ), onTimeout: () {
            return http.Response('Error', 500);
          })
        : await http
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
    print("id ${widget.id}");
    print("name ${widget.name}");
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    unitHeight = MediaQuery.of(context).size.height * 0.005;
    return WillPopScope(
      onWillPop: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Home()), (route) => false),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: TextDesign(
            align: TextAlign.center,
            text: "Search Test",
            fontSize: 18,
            fontfamily: "Roboto",
            colorName: Colors.white,
          ),
          backgroundColor: orangeColor,
        ),
        backgroundColor: background,
        body: StreamBuilder<Object>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
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
            blood_test_list = snapshot.data;
            print("Mohit $blood_test_list");
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: CardDesign(
                list: blood_test_list,
                number: 4,
              ),
            );
          },
        ),
      ),
    );
  }
}
