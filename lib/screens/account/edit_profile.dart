import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/account/profile.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/button_design.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  Stream _stream;
  StreamController _streamController;

  DateTime selectedDate = DateTime.now();
  bool net;

  var unitHeight;

  Widget textform(
    BuildContext context,
    String txt,
    var controller,
    var data,
  ) {
    controller.text = data;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextDesign(
            align: TextAlign.left,
            text: txt,
            fontSize: 4.5 * unitHeight,
            fontfamily: "Roboto",
            fontWeight: FontWeight.bold,
            colorName: bigTextColor,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 1,
            //height: MediaQuery.of(context).size.height * 0.05,
            child: TextFormField(
              minLines: 1,
              maxLines: 3,
              controller: controller,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 4.5 * unitHeight,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Lato"),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
        ],
      ),
    );
  }

  var name = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var address = TextEditingController();
  var gender = TextEditingController();

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
        Map map = jsonDecode(response.body);
        name.text = map['name'];
        phone.text = map['phone'];
        email.text = map['email'];
        address.text = map['address'];
        selectValue = map['gender'];
        selectedDate = map['dob'].toString() == "" ? DateTime.now() : DateTime.tryParse(map['dob']);
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

  Future providedata() async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String login = prefs.getString("logintoken");
    var url = Uri.parse("https://app.geomedipath.com/App/Profile");
    setState(() {
      net = true;
    });
    try {
      response = await http.post(url, body: {
        "id": login,
        "name": name.text,
        "phone": phone.text.toString(),
        "email": email.text,
        "address": address.text,
        "gender": selectValue,
        "dob": selectedDate.toIso8601String(),
      });
      if (response.statusCode == 200) {
        setState(
          () {
            var data = jsonDecode(response.body);
            print("data $data");
            return data;
          },
        );
      } else {
        setState(() {});
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
    return jsonDecode(response.body);
  }

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  var selectValue;
  var _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    setState(() {
      unitHeight = MediaQuery.of(context).size.height * 0.005;
    });
    return ProgressHUD(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            backgroundColor: orangeColor,
            automaticallyImplyLeading: true,
            title: TextDesign(
              text: "Edit Profile",
              colorName: Colors.white,
              fontSize: unitHeight * 5,
            ),
          ),
          backgroundColor: background,
          body: Form(
              key: _formkey,
              child: StreamBuilder<Object>(
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
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.02,
                            vertical:
                                MediaQuery.of(context).size.height * 0.01),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextDesign(
                                    align: TextAlign.left,
                                    text: "Full Name",
                                    fontSize: 4.5 * unitHeight,
                                    fontfamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                    colorName: bigTextColor,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 1,
                                    //height: MediaQuery.of(context).size.height * 0.05,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1,
                                      controller: name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 4.5 * unitHeight,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Lato"),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextDesign(
                                    align: TextAlign.left,
                                    text: "Email Address",
                                    fontSize: 4.5 * unitHeight,
                                    fontfamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                    colorName: bigTextColor,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 1,
                                    //height: MediaQuery.of(context).size.height * 0.05,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1,
                                      controller: email,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 4.5 * unitHeight,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Lato",
                                      ),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextDesign(
                                    align: TextAlign.left,
                                    text: "Phone Number",
                                    fontSize: 4.5 * unitHeight,
                                    fontfamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                    colorName: bigTextColor,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 1,
                                    //height: MediaQuery.of(context).size.height * 0.05,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1,
                                      maxLength: 10,
                                      controller: phone,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 4.5 * unitHeight,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Lato"),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextDesign(
                                    align: TextAlign.left,
                                    text: "Address",
                                    fontSize: 4.5 * unitHeight,
                                    fontfamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                    colorName: bigTextColor,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width * 1,
                                    //height: MediaQuery.of(context).size.height * 0.05,
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 1,
                                      controller: address,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 4.5 * unitHeight,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Lato"),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.01,
                                  ),
                                ],
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
                                  style: TextStyle(
                                      fontSize: unitHeight * 5,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 20.0,
                                ),
                                RaisedButton(
                                  onPressed: () => _selectDate(context),
                                  // Refer step 3
                                  child: Text(
                                    'Date Of Birth',
                                    style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  color: orangeColor,
                                ),
                              ],
                            ),
                            TextDesign(
                              text: "Gender",
                              align: TextAlign.left,
                              fontSize: 4.5 * unitHeight,
                              colorName: bigTextColor,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new Radio(
                                  value: "Male",
                                  groupValue: selectValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectValue = value;
                                      print(selectValue);
                                      print(value);
                                    });
                                  },
                                ),
                                new TextDesign(
                                  text: 'Male',
                                  fontfamily: "Roboto",
                                  fontSize: 4.5 * unitHeight,
                                ),
                                new Radio(
                                  value: "Female",
                                  groupValue: selectValue,
                                  onChanged: (value) {
                                    setState(() {
                                      selectValue = value;
                                      print(selectValue);
                                      print(value);
                                    });
                                  },
                                ),
                                new TextDesign(
                                  text: 'Female',
                                  fontfamily: "Roboto",
                                  fontSize: 4.5 * unitHeight,
                                ),
                              ],
                            ),
                            InkWell(
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width * 0.005,
                                    vertical: MediaQuery.of(context).size.height *
                                        0.02),
                                decoration: BoxDecoration(
                                color: orangeColor,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: TextDesign(
                                  text: "Save Profile",
                                  colorName: whiteColor,
                                  fontSize: 5 * unitHeight,
                                  fontfamily: "Roboto",
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  if (_formkey.currentState.validate()) {
                                    if (selectValue == null) {
                                      Fluttertoast.showToast(
                                          msg: "Something is missing",
                                          backgroundColor:
                                          Colors.grey.shade200,
                                          fontSize: 18,
                                          gravity: ToastGravity.BOTTOM,
                                          textColor: Colors.black);
                                    } else {
                                      final progress =
                                      ProgressHUD.of(context);
                                      progress?.showWithText('');
                                      providedata().then((value) async {
                                        print("value $value");
                                        if (value == true) {
                                          Future.delayed(Duration(seconds: 3),
                                                  () {
                                                progress?.dismiss();
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Profile(),
                                                  ),
                                                );
                                              });
                                        } else {
                                          Future.delayed(Duration(seconds: 3),
                                                  () {
                                                progress?.dismiss();
                                                Fluttertoast.showToast(
                                                    msg:
                                                    "You are already Registered",
                                                    backgroundColor:
                                                    Colors.grey.shade200,
                                                    fontSize: 18,
                                                    gravity: ToastGravity.BOTTOM,
                                                    textColor: Colors.black,
                                                );
                                              },
                                          );
                                        }
                                      });
                                    }
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  })),
        ),
      ),
    );
  }
}
