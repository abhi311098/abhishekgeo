import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geomedipath/widgets/grid_design_screen.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';

import 'package:http/http.dart' as http;

class Tech extends StatefulWidget {
  Tech({Key key});

  @override
  State<Tech> createState() => _TechState();
}

class _TechState extends State<Tech> {

  Stream _stream;
  StreamController _streamController;

  Future fetchData() async {
    http.Response response;
    var url = Uri.parse("https://app.geomedipath.com/App/Equipment");
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        automaticallyImplyLeading: true,
        title: TextDesign(
          text: "Technology, equipment and partner labs",
          colorName: whiteColor,
          fontSize: (MediaQuery.of(context).size.height * 0.005) * 5,
        ),
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
            return GridDesignScreen(list: list,);
          }),
    );
  }
}
