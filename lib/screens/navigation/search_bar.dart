import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/navigation/blood_test.dart';
import 'package:geomedipath/screens/nine_hundred_search.dart';
import 'package:http/http.dart' as http;

class SearchBar extends StatefulWidget {
  var type;
  SearchBar({this.type});
  @override
  _SearchBar createState() => _SearchBar();
}

class _SearchBar extends State<SearchBar> {
  TextEditingController _searchText = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) => Scaffold(

          body: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.02),
                    height: MediaQuery.of(context).size.height * 0.08,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 15.0,
                              spreadRadius: 0.0)
                        ]),
                    child: TextField(
                      controller: _searchText,
                      onSubmitted: (text) async {

                        widget.type == "nine" ? Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => NineHundredSearch(id: _searchText.text,),
                          ),
                        ) : Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => BloodTest(search: true, name: "", id: _searchText.text,),
                              ),
                            );
                      },
                      decoration: InputDecoration(
                        hintText: "Search Test",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
  }

}
