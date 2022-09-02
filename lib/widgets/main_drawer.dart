import 'package:flutter/material.dart';
import 'package:geomedipath/screens/login/login.dart';
import 'package:geomedipath/screens/navigation/about_us.dart';
import 'package:geomedipath/screens/navigation/account.dart';
import 'package:geomedipath/screens/navigation/blood_test.dart';
import 'package:geomedipath/screens/navigation/home.dart';
import 'package:geomedipath/screens/navigation/license.dart';
import 'package:geomedipath/screens/navigation/partner_with_us.dart';
import 'package:geomedipath/screens/navigation/review_videos_pics.dart';
import 'package:geomedipath/screens/navigation/tech.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key key});

  Widget textStyle(String text, Function tapHandler) {
    return Column(
      children: [
        InkWell(
          onTap: tapHandler,
          child: Container(
            decoration: BoxDecoration(
                shape: BoxShape.rectangle, color: Colors.grey.shade200),
            padding: const EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            child: Text(
              text,
              style: TextStyle(
                fontFamily: "NotoSans",
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: Colors.black,
        ),
      ],
    );
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.width * 0.4,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black12,
                image: new DecorationImage(
                  image: AssetImage("assets/images/logo.png"),
                ),
              ),
            ),
            textStyle(
              "Home",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                );
              },
            ),
           textStyle(
              "My Account",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Account(),
                  ),
                );
              },
            ),
            textStyle(
              "Licenses/Registrations/Accreditations",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => License(),
                  ),
                );
              },
            ),
            textStyle(
              "Technology, equipment and partner labs",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Tech(),
                  ),
                );
              },
            ),
            textStyle(
              "Review/videos and pics",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Reviewvideospics(),
                  ),
                );
              },
            ),
            textStyle(
              "Partner with us",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PartnerWithUs(),
                  ),
                );
              },
            ),
            textStyle(
              "About Us",
              () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AboutUs(),
                  ),
                );
              },
            ),
            textStyle(
              "Facebook Page",
              () {
                _launchURL("https://www.facebook.com/people/Geomedipath/100063840258114/");
              },
            ),textStyle(
              "Instagram Page",
              () {
               _launchURL("https://www.instagram.com/geomedipath_official/");
              },
            ),
            textStyle(
              "Sign Out",
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
    );
  }
}
