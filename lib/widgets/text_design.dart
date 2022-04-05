import 'package:flutter/material.dart';

class TextDesign extends StatelessWidget {
  String text;
  Color colorName;
  String fontfamily;
  int lines = 1;
  TextAlign align;
  double fontSize;
  FontWeight fontWeight;

  TextDesign({
    this.align,
    this.text,
    this.lines,
    this.fontSize,
    this.fontfamily,
    this.fontWeight,
    this.colorName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        text,
        maxLines: lines,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        textAlign: align,
        textScaleFactor: 0.85,
        style: TextStyle(
          color: colorName,
          fontFamily: fontfamily,
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }
}
