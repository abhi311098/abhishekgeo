import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:geomedipath/screens/account/address.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:http/http.dart' as http;

class TimeSlot extends StatefulWidget {
  const TimeSlot({Key key});

  @override
  _TimeSlotState createState() => _TimeSlotState();
}

class _TimeSlotState extends State<TimeSlot> {
  Stream _stream;
  StreamController _streamController;

  bool loader = false;

  String dateSelect(int num) {
    var aa = formatDate(
        DateTime.now().add(Duration(days: num)), [dd, '-', mm, '-', yyyy]);
    print(aa);
    return aa.toString();
    
  }

  int forward = 1;

  Future fetchData({var aa1}) async {
    setState(() {
      loader = true;
    });
    var aa = aa1 == null ? dateSelect(1) : aa1;
    http.Response response;
    var url = Uri.parse(
      "https://app.geomedipath.com/App/Slots/$aa",
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
        _streamController.add(jsonDecode(response.body));
        loader = false;
      });
    } else {
      setState(() {
        _streamController.add(false);
        loader = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _stream = _streamController.stream;
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    var unitHeight = MediaQuery.of(context).size.height * 0.005;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: orangeColor,
        automaticallyImplyLeading: true,
        title: TextDesign(
          text: "Slot",
          colorName: whiteColor,
          fontSize: unitHeight * 5,
        ),
      ),
      backgroundColor: background,
      body: StreamBuilder<Object>(
          stream: _stream,
          builder: (context, snapshot) {
            if (loader) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data == false) {
              return Center(
                child: Text(
                  "No Data Found",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              );
            }
            List list = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            loader = true;
                            if (forward == 1) {
                              print("if $forward");
                            } else {
                              forward = forward - 1;
                              fetchData(aa1: forward);
                              print("else $forward");
                            }
                            dateSelect(forward);
                          });
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.black,)),
                    Text(dateSelect(forward)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            loader = true;
                            if (forward == 5) {
                              forward = 1;
                              fetchData(aa1: forward);
                              print("if $forward");
                            } else {
                              forward = forward + 1;
                              fetchData(aa1: forward);
                              print("else $forward");
                            }
                            dateSelect(forward);
                          });
                        },
                        icon: Icon(Icons.arrow_forward,color: Colors.black,)),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: list.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        print(dateSelect(forward));
                        print(list[index]['slot']);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Address(
                              date: dateSelect(forward),
                              buttonShow: true,
                              time: list[index]['slot'].toString(),
                              routeFromTimeslot: true,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              list[index]['slot'],
                            ),
                            list[index]['book'] == 0
                                ? Container()
                                : Text("No Slot Available"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
