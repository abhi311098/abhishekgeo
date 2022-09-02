import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/cart%20&%20payment/time_slot.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/button_design.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:geomedipath/widgets/textfield2.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'address.dart';

class EditAddress extends StatefulWidget {
  String newAddress;
  String addressId;
  bool routeFromTimeslot;

  EditAddress(
      {Key key, this.newAddress, this.addressId, this.routeFromTimeslot});

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  String newAddress;

  bool load = false;
  String _site = "Home";
  var _formkey = GlobalKey<FormState>();
  var address = TextEditingController();
  var pin = TextEditingController();
  var name = TextEditingController();
  var phone = TextEditingController();
  Stream _stream;
  StreamController _streamController;

  bool net = true;

  Future provideData3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");

    http.Response response;
    print(name.text);
    var url = Uri.parse(
      newAddress == "new"
          ? "https://app.geomedipath.com/App/Address/"
          : "https://app.geomedipath.com/App/Address/${widget.addressId}/${pin.text}",
    );
    print(newAddress);
    print(widget.addressId);
    print(
      "user_id" +
          "1" +
          "name" +
          name.text +
          "phone" +
          phone.text +
          "address" +
          address.text +
          "pin" +
          pin.text +
          "type" +
          _site,
    );
    print("url $url");
    response = newAddress == "new"
        ? await http.post(url, body: {
            "user_id": logintoken,
            "name": name.text,
            "phone": phone.text,
            "address": address.text,
            "pin": pin.text,
            "type": _site,
          })
        : await http.put(url, body: {
            "user_id": logintoken,
            "name": name.text,
            "phone": phone.text,
            "address": address.text,
            "pin": pin.text,
            "type": _site,
          });
    return jsonDecode(response.body);
  }

  Future fetchdata() async {
    print("Address_id ${widget.addressId}");
    http.Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String logintoken = prefs.getString("logintoken");
    var url = Uri.parse(
        "https://app.geomedipath.com/App/Address/${newAddress == "new" ? "$logintoken" : "$logintoken/${widget.addressId}"}");
    print("edit Address $url");
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
            List ll = jsonDecode(response.body);
            name.text = newAddress == "new" ? "" : ll[0]["type"];
            pin.text = newAddress == "new" ? "" : ll[0]["pin"];
            phone.text = newAddress == "new" ? "" : ll[0]["phone"];
            address.text = newAddress == "new" ? "" : ll[0]["address"];
            _site = newAddress == "new" ? "Home" : ll[0]["type"];
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

  @override
  void initState() {
    super.initState();
    newAddress = widget.newAddress;
    _streamController = StreamController();
    _stream = _streamController.stream;
    fetchdata();
  }

  @override
  Widget build(BuildContext context) {
    print("Edit Address => ${widget.routeFromTimeslot}");
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: orangeColor,
        title: TextDesign(
          text: "Edit Address",
          fontSize: 18,
          colorName: Colors.white,
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
            print(list.length);
            int len = list.length;
            print(len);
            return Form(
              key: _formkey,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.02,
                    vertical: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        style: TextStyle(
                          color: blackColor,
                        ),
                        controller: name,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Your name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Name",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: blackColor,
                        ),
                        controller: phone,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Your Phone Number";
                          } else if (value.length != 10) {
                            return "Please Enter Your 10 digit Phone Number";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: blackColor,
                        ),
                        controller: address,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Your Address";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Address",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      TextFormField(
                        style: TextStyle(
                          color: blackColor,
                        ),
                        controller: pin,
                        keyboardType: TextInputType.phone,
                        maxLength: 6,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Your Pincode";
                          } else if (value.length != 6) {
                            return "Please Enter Your 6 digit Pincode";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Pincode",
                          labelStyle: TextStyle(
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.26,
                            child: ListTile(
                              minVerticalPadding: 0,
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.zero,
                              title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: const Text('Home')),
                              leading: Radio(
                                value: 'Home',
                                groupValue: _site,
                                onChanged: (value) {
                                  setState(() {
                                    _site = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: ListTile(
                              minVerticalPadding: 0,
                              minLeadingWidth: 0,
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.zero,
                              title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: const Text('Office')),
                              leading: Radio(
                                value: 'Office',
                                groupValue: _site,
                                onChanged: (value) {
                                  setState(() {
                                    _site = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: ListTile(
                              minVerticalPadding: 0,
                              minLeadingWidth: 0,
                              horizontalTitleGap: 0,
                              contentPadding: EdgeInsets.zero,
                              title: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: const Text('Other')),
                              leading: Radio(
                                value: 'other',
                                groupValue: _site,
                                onChanged: (value) {
                                  setState(() {
                                    _site = value;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        child: ButtonDesign(
                          handler: () {
                            if (_formkey.currentState.validate()) {
                              setState(() {
                                load = true;
                              });
                              provideData3().then((value) {
                                print(value);
                                print(value.runtimeType);
                                print(value['status']);

                                if ("true" == value["status"].toString() &&
                                    "true" == value["pincode_err"].toString() &&
                                    value['msg'][0].toString() ==
                                        "Address Added Successfully.") {
                                  Future.delayed(Duration(seconds: 3), () {
                                    widget.routeFromTimeslot
                                        ? Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => TimeSlot(),
                                            ),
                                          )
                                        : Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => Address(),
                                            ),
                                          );
                                  });
                                } else if ("false" ==
                                        value["status"].toString() ||
                                    "false" ==
                                        value["pincode_err"].toString()) {
                                  setState(() {
                                    load = false;
                                  });
                                  Future.delayed(Duration(seconds: 0), () {
                                    Fluttertoast.showToast(
                                        msg: value['msg'][0].toString(),
                                        backgroundColor:
                                            Colors.lightBlue.shade100,
                                        fontSize: 18,
                                        gravity: ToastGravity.BOTTOM,
                                        textColor: Colors.black);
                                  });
                                  widget.routeFromTimeslot
                                      ? Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => TimeSlot(),
                                    ),
                                  )
                                      : Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => Address(),
                                    ),
                                  );
                                } else if (value['msg'][0].toString() ==
                                    "Address Added Successfully.") {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => Address()));
                                } else {
                                  setState(() {
                                    load = false;
                                  });
                                  Future.delayed(Duration(seconds: 3), () {
                                    Fluttertoast.showToast(
                                        msg: "Try Again",
                                        backgroundColor:
                                            Colors.lightBlue.shade100,
                                        fontSize: 18,
                                        gravity: ToastGravity.BOTTOM,
                                        textColor: Colors.black);
                                  });
                                }
                              });
                            }
                          },
                          txt: "ADD",
                          fontsize: 18,
                          align: TextAlign.center,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
