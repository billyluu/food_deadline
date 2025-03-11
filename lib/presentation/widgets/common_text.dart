import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  const CommonText({
    required this.text,
    this.style,
    this.textAlign,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: style,
    );
  }
}

class CommonTextStyle {
  static TextStyle textStyle({Color? color}) => TextStyle(
        color: color,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  static TextStyle textStyleLarge({Color? color}) => TextStyle(
        color: color,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle textStyleSmall({Color? color}) => TextStyle(
        color: color,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      );
}
