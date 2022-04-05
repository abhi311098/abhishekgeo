import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetACallBack extends StatefulWidget {
  var id;
  GetACallBack({this.id});

  @override
  _GetACallBackState createState() => _GetACallBackState();
}

class _GetACallBackState extends State<GetACallBack> {
  var unitHeight;
  var _formkey = GlobalKey<FormState>();

  var _fileUpload;
  var phone = TextEditingController();
  var name = TextEditingController();
  var _chosenValue;

  Future fetchData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString("logintoken");

    print("logintoken $id");

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
        Map map = jsonDecode(response.body);
        name.text = map['name'];
        phone.text = map['phone'];
        _chosenValue = map['city'];
      });
    } else {}
    //return jsonDecode(response.body);
  }

  Future provideData() async {
    var resData;
    print("test_id: ${widget.id}");
    print("phone: ${phone.text}");
    print("city: ${_chosenValue}");
    print("name: ${name.text}");
    print("file: ${_fileUpload}");
    var url = Uri.parse("https://app.geomedipath.com/App/GetCall");
    try {
      Map<String, String> bodyData = {
        "id": widget.id,
        "phone": phone.text,
        "city": _chosenValue,
        "name": name.text,
      };
      var request = http.MultipartRequest('POST', url);
      request.fields.addAll(bodyData);
      request.files.add(
        await http.MultipartFile.fromPath('file', _fileUpload),
      );

      var res = await request.send();
      res.stream.transform(utf8.decoder).listen((event) {
        setState(() {
          resData = event;
        });
      });
    } catch (e) {
      print(e);
    }
    print("resData");
    return resData;
    //print(jsonDecode(response.body));
    //return jsonDecode(response.body);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }


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

          ),
          backgroundColor: background,
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.03,
                    vertical: MediaQuery.of(context).size.height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      width: double.infinity,
                      child: DropdownButton<String>(
                        value: _chosenValue,
                        isExpanded: true,
                        style: TextStyle(color: Colors.black),
                        items: <String>["DELHI", "GURUGRAM", "NOIDA"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text(
                          "Select Your City",
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
                    ElevatedButton(onPressed: () async {
                      final result = await FilePicker.platform.pickFiles();
                             if(result == null) return;
                      final file = result.files.single.path;
                      setState(() {
                        _fileUpload = file;
                      });
                      print("Abhishek ${file}");
                      //openFile(file);
                    }, child: Text("Upload Prescription",
                    style: TextStyle(
                      fontSize: unitHeight * 3
                    ),)),
                    _fileUpload == null ? Container() : Text(_fileUpload.toString().replaceAll("/data/user/0/com.geomedipath.geomedipath/cache/file_picker/", ""),
                      style: TextStyle(
                          fontSize: unitHeight * 4
                      ),),
                    InkWell(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.02),
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.005,
                            vertical: MediaQuery.of(context).size.height * 0.02),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.green.shade700,
                                Colors.green.shade800,
                                Colors.green.shade700
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextDesign(
                          text: "Get A Call Back",
                          colorName: whiteColor,
                          fontSize: 5 * unitHeight,
                          fontfamily: "Roboto",
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          if (_formkey.currentState.validate()) {
                            if (_chosenValue == null) {
                              Fluttertoast.showToast(
                                  msg: "Something is missing",
                                  backgroundColor: Colors.grey.shade200,
                                  fontSize: unitHeight * 5,
                                  gravity: ToastGravity.BOTTOM,
                                  textColor: Colors.black);
                            } else {
                              final progress = ProgressHUD.of(context);
                              progress?.showWithText('');
                              provideData().then((value) async {
                                print("value $value");
                                if (value == true) {
                                  Future.delayed(Duration(seconds: 3), () {
                                    progress?.dismiss();
                                    // Navigator.of(context)
                                    //     .pushReplacement(
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         Profile(),
                                    //   ),
                                    // );
                                  });
                                } else {
                                  Future.delayed(
                                    Duration(seconds: 3),
                                    () {
                                      progress?.dismiss();
                                      Fluttertoast.showToast(
                                        msg: "Try Again",
                                        backgroundColor: Colors.grey.shade200,
                                        fontSize: unitHeight * 5,
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
            ),
          ),
        ),
      ),
    );
  }
}
