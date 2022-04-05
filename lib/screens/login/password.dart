import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/screens/login/login.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Password extends StatefulWidget {
  var number;
  Password({this.number});

  @override
  _PasswordState createState() => _PasswordState();
}

class _PasswordState extends State<Password> {
  var number;

  var _formkey = GlobalKey<FormState>();

  var userConfirmPassword = TextEditingController();
  var userPassword = TextEditingController();

  Future providePassword() async {
    http.Response response;
    var url = Uri.parse("https://app.geomedipath.com/App/ForgotPassword");
    response = await http.post(url, body: {
      "type": "password",
      "phone": widget.number,
      "password": userPassword.text,
    });
    return response.body;
  }

  var _passwordVisible = false;
  var _passwordVisible1 = false;

  @override
  Widget build(BuildContext context) {
    number = widget.number;
    return ProgressHUD(
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
                            controller: userPassword,
                            decoration: InputDecoration(
                              labelText: "Password",
                              errorStyle: TextStyle(
                                  color: Colors.red.shade100
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black87,
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
                                color: Colors.black87,
                              ),
                              hintStyle: TextStyle(color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          TextFormField(
                            style: TextStyle(
                              color: Colors.black87,
                            ),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please Enter Your Confirm Password";
                              }
                              return null;
                            },
                            obscureText: !_passwordVisible1,
                            controller: userConfirmPassword,
                            decoration: InputDecoration(
                              labelText: "Confirm Password",
                              errorStyle: TextStyle(
                                  color: Colors.red.shade100
                              ),
                              border: new OutlineInputBorder(
                                borderRadius: const BorderRadius.all(
                                  const Radius.circular(10.0),
                                ),),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  _passwordVisible1
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.black87,
                                ),
                                onPressed: () {
                                  // Update the state i.e. toogle the state of passwordVisible variable
                                  setState(() {
                                    _passwordVisible1 = !_passwordVisible1;
                                  });
                                },
                              ),
                              labelStyle: TextStyle(color: Colors.black87),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: Colors.black87,
                              ),
                              hintStyle: TextStyle(color: Colors.black87),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20),
                              color: indigoColor,
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal:
                                MediaQuery.of(context).size.width * 0.01),
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.06,
                            child: FlatButton(
                              child: TextDesign(
                                text: "Login",
                                fontSize: 19,
                                colorName: Colors.white,
                              ),
                              onPressed: () async {
                                setState(
                                      () {
                                    if (_formkey.currentState.validate()) {
                                      if(userConfirmPassword.text.toString() == userPassword.text.toString()) {
                                        final progress = ProgressHUD.of(context);
                                        progress?.showWithText('');
                                        providePassword().then(
                                              (value) async {
                                            print(value);
                                            if (value != "false") {
                                              SharedPreferences ss =
                                              await SharedPreferences
                                                  .getInstance();
                                              ss.setString(
                                                  "logintoken", value.toString());
                                              print(value);
                                              Future.delayed(
                                                Duration(seconds: 3),
                                                    () {
                                                  progress?.dismiss();
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (BuildContext
                                                      context) =>
                                                          Login(),
                                                    ),
                                                  );
                                                },
                                              );
                                            } else {
                                              Future.delayed(Duration(seconds: 3),
                                                      () {
                                                    progress?.dismiss();
                                                    Fluttertoast.showToast(
                                                        msg: "Try Again",
                                                        backgroundColor: Colors.lightBlue.shade100,
                                                        fontSize: 18,
                                                        gravity: ToastGravity.BOTTOM,
                                                        textColor: Colors.black);
                                                  });
                                            }
                                          },
                                        );
                                      }
                                      else {

                                        Fluttertoast.showToast(
                                            msg: "Password not match",
                                            backgroundColor: Colors.lightBlue.shade100,
                                            fontSize: 18,
                                            gravity: ToastGravity.BOTTOM,
                                            textColor: Colors.black);
                                      }
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
