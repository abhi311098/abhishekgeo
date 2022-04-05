import 'package:flutter/material.dart';

import 'all_colors.dart';

class Textfield2 extends StatelessWidget {
  String text, hint, value;
  TextEditingController controller;

  Textfield2({this.text, this.hint, this.controller, this.value});

  @override
  Widget build(BuildContext context) {
    controller.text = value;
    return TextFormField(
      style: TextStyle(
        color: blackColor,
      ),
      controller: controller,
      validator: (value) {
        if (value.isEmpty) {
          return "Please Enter Your $hint";
        }
        else if(hint == "Phone") {
          print(value.length);
          if(value.length < 9) {
            return "$hint is less than 10";
          }
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
        labelText: text,
        labelStyle: TextStyle(
          color: Colors.black87,
        ),
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.black54,
        ),
      ),
    );
  }
}
//
