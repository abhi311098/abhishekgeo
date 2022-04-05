import 'package:flutter/material.dart';

import 'text_design.dart';

class ButtonDesign extends StatelessWidget {
  Function handler;
  String txt;
  double fontsize;
  TextAlign align;
  Color color;
  String fontfamily;
  FontWeight fontWeight;

  ButtonDesign({this.handler, this.fontfamily, this.fontWeight, this.txt, this.fontsize, this.align, this.color});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: TextDesign(
          align: align,
          text: txt,
          fontfamily: "Roboto",
          fontSize: fontsize,
          colorName: color,
          fontWeight: fontWeight,
        ),
        onPressed: handler);
  }
}
