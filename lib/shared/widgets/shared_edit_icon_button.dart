import 'package:flutter/material.dart';

class SharedEditIconButton extends StatelessWidget {
  const SharedEditIconButton({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.edit),
      onPressed: onPressed,
    );
  }
}
