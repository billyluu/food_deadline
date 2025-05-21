import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/app_string.dart';

class SharedSendButton extends StatelessWidget {
  const SharedSendButton({
    this.onPressed,
    super.key,
  });

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(AppString.commonSend.getL10n(context)),
    );
  }
}