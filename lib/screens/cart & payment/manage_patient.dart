import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/cart%20&%20payment/edit_patient.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'cart.dart';

class ManagePatient extends StatefulWidget {
  var id;

  ManagePatient({Key key, this.id}) : super(key: key);

  @override
  _ManagePatientState createState() => _ManagePatientState();
}

class _ManagePatientState extends State<ManagePatient> {
  bool load = false;
  Stream _stream;
  StreamController _streamController;
  bool net = true;

  bool checkValue = false;

  List _selecteCategorys = [];

  Future fetchData() async {
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    var url = Uri.parse(
      "https://app.geomedipath.com/App/patient?user_id=$logintoken&cart_id=${widget.id}&pt_id=",
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
        _streamController.add(jsonDecode(response.body));
        List map = jsonDecode(response.body);
        map.forEach((element) {
          _selecteCategorys.add(element['selected']);
        });
        print(_selecteCategorys);
      });
    } else {
      _streamController.add("false");
    }
    //return jsonDecode(response.body);
  }

  Future provideData(var id) async {
    setState(() {
      load = true;
    });
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/AddPatient",
    );
    print(url);
    response = await http.post(url, body: {
      "cart_id": widget.id,
      "patient_ids": id.toString(),
    }).timeout(
        Duration(
          seconds: 30,
        ), onTimeout: () {
      return http.Response('Error', 500);
    });
    if (response.statusCode == 200) {
      setState(() {
        load = false;
      });
    } else {
      setState(() {
        fetchData();
        load = false;
      });
    }
    return jsonDecode(response.body);
  }

  Future provideDelete(var id) async {
    setState(() {
      load = true;
    });
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Patient/$id",
    );
    print(url);
    response = await http
        .delete(
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
        fetchData();
        load = false;
      });
    } else {
      setState(() {
        fetchData();
        load = false;
      });
    }
    return jsonDecode(response.body);
  }

  bool aa = false;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSizer = MediaQuery.of(context).size;
    var unitHeight = MediaQuery.of(context).size.height * 0.005;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        automaticallyImplyLeading: true,
        title: TextDesign(
          text: "Patient Detail",
          colorName: Colors.white,
          fontSize: unitHeight * 5,
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
                      fetchData();
                    });
                  },
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting ||
                load == true) {
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
            List list = snapshot.data;

            return SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditPatient(
                                apiType: "new",
                              )));
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(
                        horizontal: screenSizer.width * 0.02,
                        vertical: screenSizer.height * 0.01,
                      ),
                      elevation: 2,
                      child: Container(
                        width: screenSizer.width * 1,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenSizer.width * 0.02,
                          vertical: screenSizer.height * 0.02,
                        ),
                        child: TextDesign(
                          text: "+ Add A New Patient",
                          colorName: Colors.black87,
                          fontSize: unitHeight * 6,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: screenSizer.width * 1,
                    padding: EdgeInsets.symmetric(
                      vertical: screenSizer.height * 0.02,
                      horizontal: screenSizer.width * 0.03,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: screenSizer.height * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "1. Please select all the patients for whom you want to book the test.",
                          style: TextStyle(
                              fontSize: unitHeight * 4, fontFamily: "Roboto"),
                        ),
                        Text(
                          "2. All selected patients should have the same address.",
                          style: TextStyle(
                              fontSize: unitHeight * 4, fontFamily: "Roboto"),
                        ),
                      ],
                    ),
                    color: Colors.grey.shade100,
                  ),
                  SizedBox(
                    height: screenSizer.height * 0.01,
                  ),
                  ListView.builder(
                      itemCount: list.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.symmetric(
                            horizontal: screenSizer.width * 0.02,
                            vertical: screenSizer.height * 0.01,
                          ),
                          elevation: 2,
                          child: Column(
                            children: [
                              ListTile(
                                leading: Checkbox(
                                  onChanged: (bool value) {
                                    setState(() {
                                      _selecteCategorys[index] = value;
                                    });
                                  },
                                  value: _selecteCategorys[index],
                                ),
                                title: Text(
                                  list[index]['name'],
                                  style: TextStyle(
                                      fontSize: unitHeight * 4,
                                      fontFamily: "Roboto"),
                                ),
                                subtitle: Text(
                                  "${list[index]['age']}, ${list[index]['gender']}",
                                  style: TextStyle(
                                      fontSize: unitHeight * 3.5,
                                      fontFamily: "Lato"),
                                ),
                                contentPadding: EdgeInsets.zero,
                                horizontalTitleGap: 0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      provideDelete(list[index]['id']);
                                    },
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(
                                          fontSize: unitHeight * 4.5,
                                          fontFamily: "Roboto"),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      vertical: screenSizer.height * 0.01,
                                      horizontal: screenSizer.width * 0.04,
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (context) => EditPatient(
                                              apiType: "",
                                              cartId: widget.id,
                                              patientId: list[index]['id'],
                                            )));
                                      },
                                      child: Text(
                                        "Edit",
                                        style: TextStyle(
                                            color: orangeColor,
                                            fontSize: unitHeight * 4.5,
                                            fontFamily: "Roboto"),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                  InkWell(
                    onTap: () {
                      List p_id = [];
                      for (int i = 0; i < list.length; i++) {
                        if (_selecteCategorys[i]) {
                          p_id.add(list[i]['id']);
                          print(p_id);
                        }
                      }
                      if (p_id.length == 0) {
                        return Fluttertoast.showToast(
                            msg: "Select Patient",
                            backgroundColor: Colors.grey.shade300,
                            textColor: Colors.black87);
                      } else {
                        provideData(p_id).then((value) {
                          if (value.toString() == "true") {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Cart(),
                              ),
                            );
                          }
                        });
                      }
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
                        "Select Patient ",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: unitHeight * 5,
                            fontFamily: "Roboto"),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
