import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geomedipath/screens/account/address.dart';
import 'package:geomedipath/screens/account/edit_address.dart';
import 'package:geomedipath/screens/account/order_detail.dart';
import 'package:geomedipath/screens/cart%20&%20payment/billing_information.dart';
import 'package:geomedipath/screens/cart%20&%20payment/edit_patient.dart';
import 'package:geomedipath/screens/cart%20&%20payment/time_slot.dart';
import 'package:geomedipath/widgets/grid_design_screen.dart';
import 'package:geomedipath/screens/navigation/partner_with_us.dart';
import 'package:geomedipath/screens/navigation/review_videos_pics.dart';
import 'package:geomedipath/screens/offer_design.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'screens/cart & payment/manage_patient.dart';
import 'screens/login/login.dart';
import 'screens/navigation/home.dart';
import 'widgets/video_player_demo.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String logintoken = prefs.getString("logintoken");
  runApp(
    MaterialApp(
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            side: BorderSide(color: Colors.red, width: 2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                wordSpacing: 2,
                letterSpacing: 2),
          ),
        ),
        primaryIconTheme: IconThemeData(
          color: Colors.white,
        ),
        indicatorColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      debugShowCheckedModeBanner: false,
      //home: OrderDetail(),
      home: logintoken == null ? Login() : Home(),
    ),
  );
}
//  keytool -genkey -v -keystore "E:\raj sir\geomedipath\upload-keystore.jks" -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload