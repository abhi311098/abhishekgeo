import 'package:flutter/material.dart';
import 'package:geomedipath/screens/account/profile.dart';
import 'package:geomedipath/screens/account/address.dart';
import 'package:geomedipath/screens/login/login.dart';
import 'package:geomedipath/screens/account/order_screen.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatelessWidget {
  Widget textDesign(String txt, BuildContext context, Function handler) {
    return InkWell(
      onTap: handler,
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.03,
          vertical: MediaQuery.of(context).size.height * 0.02,
        ),
        child: TextDesign(
          text: txt,
          colorName: blackColor,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: TextDesign(
          align: TextAlign.center,
          text: "Account",
          fontSize: 18,
          colorName: Colors.white,
        ),
        backgroundColor: orangeColor,
      ),
      backgroundColor: background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.01,
              vertical: MediaQuery.of(context).size.height * 0.005,
            ),
            child: Column(
              children: [
                textDesign(
                  "Profile",
                  context,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Profile(),
                      ),
                    );
                  },
                ),
                textDesign(
                  "My Order",
                  context,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => OrderScreen(),
                      ),
                    );
                  },
                ),
                textDesign(
                  "My Address",
                  context,
                  () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Address(buttonShow: false,),
                      ),
                    );
                  },
                ),
                textDesign(
                  "Sign Out",
                  context,
                  () async {
                    SharedPreferences preferences = await SharedPreferences.getInstance();
                    preferences.remove("logintoken");
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => Login(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
