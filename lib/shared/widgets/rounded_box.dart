import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  final Widget child;
  final Color background;

  const RoundedBox({
    super.key,
    required this.child,
    required this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, 2),
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
