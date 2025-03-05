
import 'package:flutter/material.dart';

class FdCard extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double radius;
  final Color background;
  final Widget child;

  const FdCard({
    Key? key,
    this.padding,
    this.radius = 12.0,
    this.background = Colors.white,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}