import 'package:flutter/material.dart';

class SharedCloseIconButton extends StatelessWidget {
  const SharedCloseIconButton({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.close),
      onPressed: onPressed,
    );
  }
}