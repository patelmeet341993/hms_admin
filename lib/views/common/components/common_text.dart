import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? textOverFlow;
  final TextDecoration? textDecoration;

  const CommonText({
    required this.text,
    this.fontSize = 15,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.textDecoration,
    this.textOverFlow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverFlow,
      style: TextStyle(
        decoration: textDecoration,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

class CommonBoldText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? textOverFlow;
  final TextDecoration? textDecoration;

  const CommonBoldText({
    Key? key,
    required this.text,
    this.fontSize = 15,
    this.fontWeight = FontWeight.bold,
    this.color,
    this.textAlign,
    this.maxLines,
    this.textDecoration,
    this.textOverFlow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverFlow,
      style: TextStyle(
        letterSpacing: 0.4,
        decoration: textDecoration,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}