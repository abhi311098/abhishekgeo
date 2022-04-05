import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/navigation/home.dart';
import 'package:geomedipath/screens/login/registration.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/button_design.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:geomedipath/widgets/textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import 'reset_password.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var _formkey = GlobalKey<FormState>();
  var userEmail = TextEditingController();
  var userPass = TextEditingController();
  var _passwordVisible = false;

  Future loginData() async {
    http.Response response;
    var url = Uri.parse("https://app.geomedipath.com/App/UserLogin/");
    response = await http.post(url, body: {
      "phone": userEmail.text,
      "password": userPass.text,
    });
    print("res ${response.body}");
    return jsonDecode(response.body);
  }

  Widget spaceSized(var num) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * num,
    );
  }


  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit an App'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    var unitheight = MediaQuery.of(context).size.height * 0.005;
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: ProgressHUD(
        child: Builder(
          builder: (context) => Scaffold(
            body: Form(
              key: _formkey,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/images/logo.png"),
                      TextfieldDesign(
                        controller: userEmail,
                        text: "Phone Number",
                        //hint: "Phone Number",
                        icon: Icons.person_outline,
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
                          errorStyle: TextStyle(
                              color: Colors.red.shade900
                          ),
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
                        decoration: BoxDecoration(
                          color: orangeColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: double.infinity,
                        // ignore: deprecated_member_use
                        child: ButtonDesign(
                          handler: () {
                            setState(() {
                              if (_formkey.currentState.validate()) {
                                final progress = ProgressHUD.of(context);
                                progress?.showWithText('');
                                loginData().then((value) async {
                                  print("value $value");
                                  if (value == false) {
                                    progress.dismiss();
                                    Fluttertoast.showToast(
                                        msg: "Invalid Phone Number or Password",
                                        backgroundColor: Colors.grey.shade200,
                                        fontSize: 18,
                                        gravity: ToastGravity.BOTTOM,
                                        textColor: Colors.black);
                                  } else {
                                    SharedPreferences ss =
                                        await SharedPreferences
                                        .getInstance();
                                    ss.setString(
                                        "logintoken", value.toString());
                                    Future.delayed(Duration(seconds: 3), () {
                                      progress?.dismiss();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => Home(),
                                        ),
                                      );
                                    });
                                  }
                                });
                              }
                            });
                          },
                          txt: "Log in",
                          align: TextAlign.center,
                          fontsize: unitheight * 5,
                          color: Colors.white,
                        ),
                      ),
                      spaceSized(0.01),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ResetPassword(),
                          ),
                        ),
                        child: TextDesign(
                            align: TextAlign.center,
                            colorName: Colors.black,
                            text: "Forgot Password?",
                            fontSize: unitheight * 5),
                      ),
                      spaceSized(0.01),
                      InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Registration(),
                          ),
                        ),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Didn't have an account?",
                                style: TextStyle(
                                  fontFamily: "NotoSans",
                                  fontSize: unitheight * 4.5,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: " Register Now",
                                style: TextStyle(
                                  fontFamily: "Roboto",
                                  fontSize: unitheight * 5,
                                  color: Colors.black,
                                ),
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
