import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/app_string.s.dart';
import 'package:food_deadline/shared/widgets/shared_text.dart';

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
      child: const SharedText.i18n(
        AppString.commonSend,
      ),
    );
  }
}
