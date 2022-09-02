import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/login/otp.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/button_design.dart';
import 'package:geomedipath/widgets/textfield.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {

  var _formkey = GlobalKey<FormState>();
  var userName = TextEditingController();
  var userEmail = TextEditingController();
  var userMob = TextEditingController();
  var userPass = TextEditingController();
  var _passwordVisible = false;

  Widget spaceSized(var num) {
    
    return SizedBox(
      height: MediaQuery.of(context).size.height * num,
    );
  }

  var unitHeight;

  var selectValue;
  String _chosenValue;

  Future loginData() async {
    http.Response response;
    var url = Uri.parse("https://app.geomedipath.com/App/UserRegister");
    print(      "name" + "${userName.text}" +
        "email" + "${userEmail.text}" +
        "phone" + "${userMob.text}" +
        "password" + "${userPass.text}");
    response = await http.post(url, body: {
      "name": "${userName.text}",
      "email": "${userEmail.text}",
      "phone": "${userMob.text}",
      "password": "${userPass.text}",
    });
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    unitHeight = MediaQuery.of(context).size.height * 0.005;
    return ProgressHUD(
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: whiteColor,
          body: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextfieldDesign(
                        controller: userName,
                        text: "Full Name",
                        //hint: "Designing World",
                        icon: Icons.person_outline,
                      ),
                      spaceSized(0.01),
                      TextfieldDesign(
                        controller: userEmail,
                        text: "Email",
                        //hint: "info@example.com",
                        icon: Icons.email_outlined,
                      ),
                      spaceSized(0.01),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black87,
                          fontFamily: "OpenSans",
                          fontSize: unitHeight * 4.2,
                        ),
                        decoration: InputDecoration(
                          prefixText: "+91",
                          labelText: "Enter your number",
                          errorStyle: TextStyle(color: Colors.red.shade900),
                          labelStyle: TextStyle(
                            color: bigTextColor,
                            fontFamily: "Roboto",
                            fontSize: unitHeight * 4,
                          ),
                          prefixIcon: Icon(
                            Icons.phone,
                          ),
                          hintStyle: TextStyle(
                          color: Colors.black87,
                          fontSize: unitHeight * 4,
                          fontFamily: "Lato",
                        ),
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
                        controller: userMob,
                      ),
                      spaceSized(0.01),
                      TextFormField(
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter Your Password";
                          }
                          return null;
                        },
                        obscureText: !_passwordVisible,
                        controller: userPass,
                        decoration: InputDecoration(
                          labelText: "Password",
                          errorStyle: TextStyle(color: Colors.red.shade900),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.black54,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          labelStyle: TextStyle(color: Colors.black87),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      spaceSized(0.01),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade800,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        // ignore: deprecated_member_use
                        child: ButtonDesign(
                            txt: "Sign Up",
                            fontsize: unitHeight * 5,
                            align: TextAlign.center,
                            color: Colors.white,
                            handler: () {
                              print("_chosenValue $_chosenValue");
                              setState(() {
                                if (_formkey.currentState.validate()) {
                                    final progress = ProgressHUD.of(context);
                                    progress?.showWithText('');
                                    loginData().then((value) async {
                                      print("value $value");
                                      if (value['status']) {
                                        Future.delayed(Duration(seconds: 3),
                                            () {
                                          progress?.dismiss();
                                          Navigator.of(context)
                                              .pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => Otp(mobileNumber: userMob.text,),
                                            ),
                                          );
                                          Fluttertoast.showToast(
                                              msg: value['msg'],
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              fontSize: 18,
                                              gravity: ToastGravity.BOTTOM,
                                              textColor: Colors.black);
                                        });
                                      } else {
                                        progress?.dismiss();
                                        Fluttertoast.showToast(
                                            msg: value['msg'],
                                            backgroundColor:
                                            Colors.grey.shade200,
                                            fontSize: 18,
                                            gravity: ToastGravity.BOTTOM,
                                            textColor: Colors.black);
                                      }
                                    });

                                }
                              });
                            }),
                      ),
                      spaceSized(0.01),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Already have an account?",
                                style: TextStyle(
                                  fontFamily: "NotoSans",
                                  fontSize: unitHeight * 4.5,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: " Sign In",
                                style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontSize: unitHeight * 5,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
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
