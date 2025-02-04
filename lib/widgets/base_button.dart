
import 'package:flutter/material.dart';

class BaseButton extends StatelessWidget {
  const BaseButton({
    required this.child, 
    required this.onPressed,
    super.key,
  });

  final Widget child;
  final Function() onPressed;


  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: child,
    );
  }

}