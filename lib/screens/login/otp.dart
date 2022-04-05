import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/navigation/home.dart';
import 'package:geomedipath/widgets/button_design.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Otp extends StatefulWidget {
  var mobileNumber;

  Otp({Key key, this.mobileNumber}) : super(key: key);

  @override
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  var userOTP = TextEditingController();
  var _formkey = GlobalKey<FormState>();

  Future generateOTP() async {
    http.Response response;
    var url = Uri.parse(
        "https://app.geomedipath.com/App/UserRegister/${widget.mobileNumber}");
    response = await http.put(url, body: {
      "otp": userOTP.text,
    });
    print("1111111111111111 ${jsonDecode(response.body)}");
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: Builder(
        builder: (context) => Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    style: TextStyle(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                      labelText: "Enter your OTP",
                      labelStyle: TextStyle(color: Colors.black87),
                      prefixIcon: Icon(
                        Icons.input,
                        color: Colors.black87,
                      ),
                      hintStyle: TextStyle(color: Colors.black87),
                    ),
                    maxLength: 6,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please Enter OTP Number';
                      } else if (value.length != 6) {
                        return 'Please Enter 6 Digits Number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    controller: userOTP,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.orange.shade800,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // ignore: deprecated_member_use
                    child: ButtonDesign(
                        txt: "Sign Up",
                        fontsize:
                            MediaQuery.of(context).size.height * 0.005 * 5,
                        align: TextAlign.center,
                        color: Colors.white,
                        handler: () {
                          setState(() {
                            if (_formkey.currentState.validate()) {
                              final progress = ProgressHUD.of(context);
                              progress?.showWithText('');
                              generateOTP().then((value) async {
                                print(value.runtimeType);
                                if(value.runtimeType == int) {
                                  SharedPreferences ss =
                                  await SharedPreferences
                                      .getInstance();
                                  ss.setString(
                                      "logintoken", value.toString());
                                  Future.delayed(Duration(seconds: 3), () {
                                    progress?.dismiss();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Home(),
                                      ),
                                    );
                                  });
                                }
                                else {
                                  Future.delayed(Duration(seconds: 3),
                                          () {
                                        progress?.dismiss();
                                        Fluttertoast.showToast(
                                            msg: value,
                                            backgroundColor:
                                            Colors.grey.shade200,
                                            fontSize: 18,
                                            gravity: ToastGravity.BOTTOM,
                                            textColor: Colors.black);
                                      });
                                }
                              });
                            }
                          });
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
