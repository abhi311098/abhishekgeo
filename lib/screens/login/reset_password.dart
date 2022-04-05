import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/login/login.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;

import 'password.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var _formkey = GlobalKey<FormState>();
  var userNumber = TextEditingController();
  var userOTP = TextEditingController();
  bool ot = false;

  Future provideNumber() async {
    print(userNumber.text);
    http.Response response;
    var url = Uri.parse("https://app.geomedipath.com/App/UserRegister");
    response = await http.post(url, body: {
      "type": "forgot",
      "phone": userNumber.text,
    });
    return response.body;
  }

  Future provideOTP() async {
    print(userNumber.text);
    print(userOTP);
    http.Response response;
    var url = Uri.parse("https://app.geomedipath.com/App/ForgotPassword");
    response = await http.post(url, body: {
      "type": "otp",
      "phone": userNumber.text,
      "otp": userOTP.text,
    });
    return response.body;
  }

  DateTime timeBackPressed = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if(isExitWarning) {
          final msg = 'Press back again to exit';
          Fluttertoast.showToast(
              msg: msg,
              backgroundColor: Colors.lightBlue.shade100,
              fontSize: 18,
              gravity: ToastGravity.BOTTOM,
              textColor: Colors.black);
          return false;
        } else {
          return true;
        }
      },
      child: ProgressHUD(
        child: Builder(
          builder: (context) => Scaffold(
            body: Form(
              key: _formkey,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.85,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //ImageDesign(),
                            TextFormField(
                              readOnly: ot,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                              decoration: InputDecoration(
                                border: new OutlineInputBorder(
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                prefixText: "+91",
                                labelText: "Enter your number",
                                labelStyle: TextStyle(color: Colors.black87),
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.black87,
                                ),
                                hintStyle: TextStyle(color: Colors.black87),
                              ),
                              maxLength: 10,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Phone Number';
                                } else if (value.length != 10) {
                                  return 'Please Enter 10 Digits Number';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.phone,
                              controller: userNumber,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Visibility(
                              visible: ot,
                              child:
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
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              decoration: new BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(20),
                                color: indigoColor
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal:
                                  MediaQuery.of(context).size.width * 0.01),
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: FlatButton(
                                child: TextDesign(
                                  text: ot == false ? "Reset Password" : "Submit",
                                  fontSize: 20,
                                  colorName: Colors.white,
                                ),
                                onPressed: () async {
                                  if (_formkey.currentState.validate()) {
                                    final progress = ProgressHUD.of(context);
                                    progress?.showWithText('');
                                    if (ot == false) {
                                      provideNumber().then((value) {
                                        print(value);
                                        Future.delayed(Duration(seconds: 3),
                                                () {
                                              progress?.dismiss();
                                              if (value == "true") {
                                                setState(() {
                                                  ot = true;
                                                });
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: value.toString(),
                                                    backgroundColor: Colors.lightBlue.shade100,
                                                    fontSize: 18,
                                                    gravity: ToastGravity.BOTTOM,
                                                    textColor: Colors.black
                                                );
                                              }
                                            });
                                      });
                                    }
                                    if (ot == true) {
                                      print("hi");
                                      provideOTP().then((value) {
                                        Future.delayed(Duration(seconds: 3),
                                                () {
                                              progress?.dismiss();
                                              if (value == "true") {
                                                setState(() {
                                                  Navigator.of(context).pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Password(number: userNumber.text.toString()),
                                                    ),
                                                  );
                                                });
                                              } else {
                                                print(value);
                                              }
                                            });
                                      });
                                    }
                                  }
                                  else {
                                    return ;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: FittedBox(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: FittedBox(
                              child: RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                    text: "Already! ",
                                    style: TextStyle(
                                        fontFamily: "NotoSans",
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  TextSpan(
                                    text: "Have an account",
                                    style: TextStyle(
                                        fontFamily: "NotoSans",
                                        color: Colors.blue,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
