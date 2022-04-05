import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/cart%20&%20payment/manage_patient.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:geomedipath/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditPatient extends StatefulWidget {
  String apiType;
  String patientId;
  String cartId;
  EditPatient({Key key, this.apiType, this.patientId, this.cartId}) : super(key: key);

  @override
  _EditPatientState createState() => _EditPatientState();
}

class _EditPatientState extends State<EditPatient> {
  var _formkey = GlobalKey<FormState>();
  var userName = TextEditingController();
  var userAge = TextEditingController();

  Stream _stream;
  StreamController _streamController;

  int selectedIndex = 0;

  Future fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString("logintoken");

    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/patient/?user_id=$id&cart_id=${widget.cartId}&pt_id=${widget.patientId}",
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
        List list = jsonDecode(response.body);
        userName.text = list[0]['name'];
        userAge.text = list[0]['age'];
        selectedIndex = list[0]['gender'] == "Male" ? 0 : 1;
      });
    } else {
      _streamController.add("false");
    }
    //return jsonDecode(response.body);
  }

  Future provideData3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");

    http.Response response;
    var url = Uri.parse(
      widget.apiType == "new"
          ? "https://app.geomedipath.com/App/Patient/"
          : "https://app.geomedipath.com/App/Patient/${widget.patientId}",
    );
    print(userName.text);
    print(userAge.text);
    print(url);
    print(selectedIndex == 0 ? "Male" : "Female");
    response = widget.apiType == "new"
        ? await http.post(url, body: {
      "user_id": logintoken,
      "name": userName.text,
      "age": userAge.text,
      "gender": selectedIndex == 0 ? "Male" : "Female",
    })
        : await http.put(url, body: {
      "user_id": logintoken,
      "name": userName.text,
      "age": userAge.text,
      "gender": selectedIndex == 0 ? "Male" : "Female",
    });
    return response.body;
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    widget.apiType == "new" ? "" : fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSizer = MediaQuery.of(context).size;
    var unitHeight = screenSizer.height * 0.005;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        automaticallyImplyLeading: true,
        title: TextDesign(
          fontfamily: "Roboto",
          text: "Patient",
          colorName: Colors.white,
          fontSize: unitHeight * 5,
        ),
      ),
      backgroundColor: background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextfieldDesign(
              controller: userName,
              text: "Name*",
              //hint: "Phone Number",
              icon: Icons.person_outline,
            ),
            TextfieldDesign(
              controller: userAge,
              text: "Age*",
              //hint: "Phone Number",
              icon: Icons.confirmation_number,
            ),
            Row(
              children: [
                InkWell(
                  highlightColor: Colors.white,
                  overlayColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.white),
                  onTap: () {
                    setState(() {
                      selectedIndex = 0;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                      vertical:
                          MediaQuery.of(context).size.height * 0.01,
                      horizontal:
                          MediaQuery.of(context).size.width * 0.01,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical:
                          MediaQuery.of(context).size.height * 0.01,
                      horizontal:
                          MediaQuery.of(context).size.width * 0.03,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        width: 1,
                        color: selectedIndex == 0
                            ? Colors.red
                            : Colors.black,
                      ),
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.03),
                    ),
                    child: TextDesign(
                      text: "Male",
                      fontfamily: "Roboto",
                      fontWeight: FontWeight.bold,
                      colorName: selectedIndex == 0
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.white,
                  overlayColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.white),
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(
                      vertical:
                          MediaQuery.of(context).size.height * 0.01,
                      horizontal:
                          MediaQuery.of(context).size.width * 0.01,
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical:
                          MediaQuery.of(context).size.height * 0.01,
                      horizontal:
                          MediaQuery.of(context).size.width * 0.03,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        width: 1,
                        color: selectedIndex == 1
                            ? Colors.red
                            : Colors.black,
                      ),
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.03),
                    ),
                    child: TextDesign(
                      text: "Female",
                      fontfamily: "Roboto",
                      fontWeight: FontWeight.bold,
                      colorName: selectedIndex == 1
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            InkWell(
              onTap: () {
                provideData3().then((value) {
                  if(value.toString() == "true") {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ManagePatient()));
                  } else {
                    Fluttertoast.showToast(msg: "Failed");
                  }
                });
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                    vertical: MediaQuery.of(context).size.height * 0.02),
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                    vertical: MediaQuery.of(context).size.height * 0.02),
                decoration: BoxDecoration(
                  color: orangeColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "Save",
                  style: TextStyle(
                      color: whiteColor,
                      fontSize: unitHeight * 5,
                      fontFamily: "Roboto"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
