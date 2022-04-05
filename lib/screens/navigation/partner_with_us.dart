import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/button_design.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:geomedipath/widgets/textfield.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PartnerWithUs extends StatefulWidget {
  PartnerWithUs({Key key}) : super(key: key);

  @override
  State<PartnerWithUs> createState() => _PartnerWithUsState();
}

class _PartnerWithUsState extends State<PartnerWithUs> {
  var _formkey = GlobalKey<FormState>();
  var userName = TextEditingController();
  var userEmail = TextEditingController();
  var userMob = TextEditingController();
  var userPass = TextEditingController();

  Widget spaceSized(var num) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * num,
    );
  }

  Future loginData() async {
    http.Response response;
    var url = Uri.parse("https://app.geomedipath.com/App//PartnerWithUs/");
    print(
      "name" +
          "${userName.text}" +
          "email" +
          "${userEmail.text}" +
          "phone" +
          "${userMob.text}" +
          "password" +
          "${userPass.text}" +
          "city" +
          _chosenValue.toLowerCase(),
    );
    response = await http.post(url, body: {
      "company_name": "${userName.text}",
      "city": "${userEmail.text}",
      "contact_no": "${userMob.text}",
      "address": "${userPass.text}",
      "service": _chosenValue.toLowerCase(),
    });
    return jsonDecode(response.body);
  }

  _launchURL() async {
    var url = 'documents/government-scheme/LR1nGexYbrWQi5pGj3eSvYJ41iXlGJJmbX3Pk43m.pdf';
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  var unitHeight;
  var selectValue;
  String _chosenValue;

  @override
  Widget build(BuildContext context) {
    unitHeight = MediaQuery.of(context).size.height * 0.005;
    return ProgressHUD(
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            title: TextDesign(
              text: "Edit Address",
              fontSize: 18,
              colorName: Colors.black87,
            ),
          ),
          backgroundColor: background,
          body: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextfieldDesign(
                      controller: userName,
                      text: "Company Name",
                      //hint: "Designing World",
                      icon: CupertinoIcons.building_2_fill,
                    ),
                    spaceSized(0.01),
                    TextfieldDesign(
                      controller: userEmail,
                      text: "City",
                      //hint: "info@example.com",
                      icon: Icons.power_input,
                    ),
                    spaceSized(0.01),
                    TextfieldDesign(
                      controller: userMob,
                      text: "Mobile Number",
                      //hint: "0987654321",
                      icon: CupertinoIcons.phone,
                    ),
                    spaceSized(0.01),
                    TextfieldDesign(
                      controller: userPass,
                      text: "Address",
                      //hint: "0987654321",
                      icon: CupertinoIcons.pencil_ellipsis_rectangle,
                    ),
                    // TextFormField(
                    //   style: TextStyle(
                    //     color: Colors.black87,
                    //   ),
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return "Please Enter Your Password";
                    //     }
                    //     return null;
                    //   },
                    //   obscureText: !_passwordVisible,
                    //   controller: userPass,
                    //   decoration: InputDecoration(
                    //     labelText: "Password",
                    //     errorStyle: TextStyle(color: Colors.red.shade900),
                    //     suffixIcon: IconButton(
                    //       icon: Icon(
                    //         // Based on passwordVisible state choose the icon
                    //         _passwordVisible
                    //             ? Icons.visibility
                    //             : Icons.visibility_off,
                    //         color: Colors.black54,
                    //       ),
                    //       onPressed: () {
                    //         // Update the state i.e. toogle the state of passwordVisible variable
                    //         setState(() {
                    //           _passwordVisible = !_passwordVisible;
                    //         });
                    //       },
                    //     ),
                    //     labelStyle: TextStyle(color: Colors.black87),
                    //     prefixIcon: Icon(
                    //       Icons.lock,
                    //       color: Colors.black54,
                    //     ),
                    //   ),
                    // ),
                    spaceSized(0.01),
                    Container(
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _chosenValue,
                        //elevation: 5,
                        isExpanded: true,
                        style: TextStyle(color: Colors.black),
                        items: <String>[
                          "Pathology",
                          "Phlebotomist",
                          "Radiology"
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text(
                          "Select Your Service",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 4.5 * unitHeight,
                              fontFamily: "Roboto",
                              fontWeight: FontWeight.w600),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
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
                          setState(
                            () {
                              _launchURL();
                              // if (_formkey.currentState.validate()) {
                              //   if (_chosenValue == null) {
                              //     Fluttertoast.showToast(
                              //         msg: "Select Your City",
                              //         backgroundColor: Colors.grey.shade200,
                              //         fontSize: 18,
                              //         gravity: ToastGravity.BOTTOM,
                              //         textColor: Colors.black);
                              //   } else {
                              //     final progress = ProgressHUD.of(context);
                              //     progress?.showWithText('');
                              //     loginData().then((value) {
                              //       if (value) {
                              //         Fluttertoast.showToast(
                              //             msg: "Form Submitted",
                              //             backgroundColor:
                              //                 Colors.lightBlue.shade100,
                              //             fontSize: 18,
                              //             gravity: ToastGravity.BOTTOM,
                              //             textColor: Colors.black);
                              //         userPass.text = "";
                              //         userMob.text = "";
                              //         userName.text = "";
                              //         userEmail.text = "";
                              //         _chosenValue = "";
                              //         progress.dismiss();
                              //       } else {
                              //         Fluttertoast.showToast(
                              //             msg: "Form Submitted",
                              //             backgroundColor:
                              //                 Colors.lightBlue.shade100,
                              //             fontSize: 18,
                              //             gravity: ToastGravity.BOTTOM,
                              //             textColor: Colors.black);
                              //         progress.dismiss();
                              //       }
                              //     });
                              //   }
                              // }
                            },
                          );
                        },
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
