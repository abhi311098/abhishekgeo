import 'package:flutter/material.dart';
import 'package:geomedipath/widgets/all_colors.dart';

// ignore: must_be_immutable
class TextfieldDesign extends StatelessWidget {
  String text, hint;
  IconData icon;
  TextEditingController controller;

  TextfieldDesign({this.controller, this.text, this.hint, this.icon});

  @override
  Widget build(BuildContext context) {
    var unitHeight = MediaQuery.of(context).size.height * 0.005;
    return TextFormField(
      style: TextStyle(
        color: Colors.black87,
        fontFamily: "OpenSans",
        fontSize: unitHeight * 4.2,
      ),
      maxLength: text == "Phone Number" ? 10 : null,
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter Your $text";
        } else if (text == "Mobile Number") {
          print(value.length);
          if (value.length < 9) {
            return "$text is less than 10";
          }
        }
        return null;
      },
      controller: controller,
      decoration: InputDecoration(
        labelText: text,
        errorStyle: TextStyle(color: Colors.red.shade900),
        labelStyle: TextStyle(
            color: bigTextColor,
            fontFamily: "Roboto",
            fontSize: unitHeight * 4,
           ),
        prefixIcon: Icon(
          icon,
          color: Colors.black54,
        ),
        hintText: hint,
        hintStyle: TextStyle(
            color: Colors.black87,
            fontSize: unitHeight * 4,
            fontFamily: "Lato",
        ),
      ),
    );
  }
}
