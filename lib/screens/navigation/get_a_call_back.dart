import 'dart:convert';
import 'dart:io';
//import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;
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
  var city = TextEditingController();

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
        city.text = map['city'];
      });
    } else {}
    //return jsonDecode(response.body);
  }
  var resData;
  Future provideData() async {

    print("test_id: ${widget.id}");
    print("phone: ${phone.text}");
    print("city: ${city.text}");
    print("name: ${name.text}");
    print("file: ${_fileUpload}");
    var url = Uri.parse("https://app.geomedipath.com/App/GetCall");
    try {
      Map<String, String> bodyData = {

      };
      print("resData 3 $bodyData");
      var request = new http.MultipartRequest('POST', url);
      print("resData 4 $request");
      request.fields.addAll({
        "id": widget.id,
        "phone": phone.text,
        "city": city.text,
        "name": name.text,
      });
      request.files.add(
        await http.MultipartFile.fromPath('file', _fileUpload),
      );
      print("resData 5 $request");
      var res = await request.send();
      print("resData 2 $res");
      await res.stream.transform(utf8.decoder).listen((event) {
        setState(() {
          print("resData 1 $event");
          resData = event;

        });
      });
    } catch (e) {
      print(e);
    }
    print("resData $resData");
    return resData;
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextDesign(
                            align: TextAlign.left,
                            text: "City",
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
                              controller: city,
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

                    // ElevatedButton(onPressed: () async {
                    //   final result = await
                    //   FilePicker.platform.pickFiles();
                    //          if(result == null) return;
                    //   final file = result.files.single.path;
                    //   setState(() {
                    //     _fileUpload = file;
                    //   });
                    //   print("Abhishek ${file}");
                    //   //openFile(file);
                    // }, child: Text("Upload Prescription",
                    // style: TextStyle(
                    //   fontSize: unitHeight * 3
                    // ),)),
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
                              if(_fileUpload == null) {
                                Fluttertoast.showToast(
                                    msg: "Upload Prescription",
                                    backgroundColor: Colors.grey.shade200,
                                    fontSize: unitHeight * 5,
                                    gravity: ToastGravity.BOTTOM,
                                    textColor: Colors.black);
                              } else {
                                final progress = ProgressHUD.of(context);
                                progress?.showWithText('');
                                provideData().then((value) async {
                                  print("value $value");
                                  if (value.toString() == "true") {
                                    Future.delayed(Duration(seconds: 3), () {
                                      progress?.dismiss();
                                      Fluttertoast.showToast(
                                          msg: "Successfully Done",
                                          backgroundColor: Colors.grey.shade200,
                                          fontSize: unitHeight * 5,
                                          gravity: ToastGravity.BOTTOM,
                                          textColor: Colors.black);
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
