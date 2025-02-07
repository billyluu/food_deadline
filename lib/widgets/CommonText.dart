import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  const CommonText({
    required this.text,
    super.key,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text);
  }
}

class CommonTextStyle {
  static TextStyle textStyle({bool? disabled}) => TextStyle(
        color: disabled ?? false ? Colors.grey : Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  static TextStyle textStyleLarge({bool? disabled}) => TextStyle(
        color: disabled ?? false ? Colors.grey : Colors.black,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      );

  static TextStyle textStyleSmall({bool? disabled}) => TextStyle(
        color: disabled ?? false ? Colors.grey : Colors.black,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      );
}
