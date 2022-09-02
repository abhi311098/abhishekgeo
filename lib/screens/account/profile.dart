import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/button_design.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Stream _stream;
  StreamController _streamController;

  var unitHeight;

  Future fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString("logintoken");
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Profile/$id",
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

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    fetchData();
  }

  Widget txtDesign(String txt1, String txt2, BuildContext context) {
    var unitHeight = MediaQuery.of(context).size.height * 0.005;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.02,
          vertical: MediaQuery.of(context).size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextDesign(
            colorName: Colors.black,
            text: txt1,
            fontWeight: FontWeight.w100,
            fontSize: unitHeight * 4.5,
            fontfamily: "Roboto",
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.02,
                vertical: MediaQuery.of(context).size.height * 0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 1,
                color: Colors.black87,
              ),
            ),
            child: TextDesign(
              text: txt2,
              lines: 3,
              fontSize: unitHeight * 4,
              fontWeight: FontWeight.w600,
              fontfamily: "Lato",
              colorName: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => EditProfile(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      unitHeight = MediaQuery.of(context).size.height * 0.005;
    });
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        automaticallyImplyLeading: true,
        title: TextDesign(
          text: "Profile",
          colorName: whiteColor,
          fontSize: unitHeight * 5,
        ),
      ),
      backgroundColor: background,
      body: StreamBuilder<Object>(
          stream: _stream,
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.connectionState == ConnectionState.waiting) {
              print(snapshot.connectionState);
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
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      txtDesign("Name", map['name'], context),
                      txtDesign("Phone", map['phone'], context),
                      txtDesign("Email", map['email'], context),
                      txtDesign("Address", map['address'], context),
                      txtDesign("Gender", map['gender'], context),
                      txtDesign("Date Of Birth", map['dob'].toString() == "" ? "" : map['dob'].toString().replaceRange(10, 23, ""), context),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              pageBuilder: (context, animation, anotherAnimation) {
                                return EditProfile();
                              },
                              transitionDuration: Duration(milliseconds: 300),
                              transitionsBuilder:
                                  (context, animation, anotherAnimation, child) {
                                return Align(
                                  child: SizeTransition(
                                    sizeFactor: animation,
                                    child: child,
                                    axisAlignment: 0.0,
                                  ),
                                );
                              }));
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * 0.02,
                              vertical: MediaQuery.of(context).size.height * 0.01),
                          decoration: BoxDecoration(
                           color: orangeColor,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ButtonDesign(
                            txt: "Edit Profile",
                            color: whiteColor,
                            fontsize: unitHeight * 5,
                            fontfamily: "Roboto",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
