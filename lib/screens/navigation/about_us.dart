import 'package:flutter/material.dart';
import 'package:geomedipath/widgets/all_colors.dart';
import 'package:geomedipath/widgets/text_design.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: TextDesign(
          align: TextAlign.center,
          text: "About Us",
          fontSize: 18,
          colorName: whiteColor,
        ),
        backgroundColor: orangeColor,
      ),
      backgroundColor: background,
      body: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Geomedipath is a collaborative concept of providing most medical services under one umbrella, we take immense pride and honor in serving every need of individuals, corporate`s, and companies by providing Blood tests, Radiology services at their door step.\nThis is one such of its kind of a concept that promises to deliver quality with max affordability, we have tie ups with quality labs, Doctors, and medical centers that manages with maintained international standards and has all required accreditations to run any medical service in india.',
              style: TextStyle(
                fontFamily: "Roboto",
                color: smallTextColor,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextDesign(
                    fontfamily: "Roboto",
                    text: "Contact Us",
                    fontSize: 24,
                    colorName: bigTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: orangeColor,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
              SelectableText(
              "info@geomedipath.com",
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: "Lato",
                  color: orangeColor
              ),
            ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        size: 20,
                        color: orangeColor,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      SelectableText(
                      "+91-88510 54064",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Lato",
                          color: orangeColor
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
