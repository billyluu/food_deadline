part of '../settings_screen.dart';

class _DebugNotificationsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SharedRoundedBox(
      background: Theme.of(context).colorScheme.secondary,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DebugNotificationsScreen(),
            ),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SharedText.basic(
              '查看排程通知',
              style: CommonTextStyle.textStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}