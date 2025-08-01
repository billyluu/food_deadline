import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_deadline/core/constants/app_constants.dart';
import 'package:food_deadline/core/constants/app_string.s.dart';
import 'package:food_deadline/core/constants/enums/app_locale.dart';
import 'package:food_deadline/features/debug/debug_notifications_screen.dart';
import 'package:food_deadline/features/settings/blocs/app_settings/app_settings_bloc.dart';
import 'package:food_deadline/shared/widgets/shared_rounded_box.dart';
import 'package:food_deadline/shared/widgets/shared_text.dart';

part 'widgets/setting_language_widget.dart';
part 'widgets/setting_notify_widget.dart';
part 'widgets/setting_notification_days_widget.dart';
part 'widgets/setting_theme_widget.dart';
part 'widgets/debug_notifications_widget.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _SettingThemeWidget(),
          const SizedBox(height: 12.0),
          _SettingNotifyWidget(),
          const SizedBox(height: 12.0),
          _SettingNotificationDaysWidget(),
          const SizedBox(height: 12.0),
          _SettingLanguageWidget(),
          // 只在Debug模式下顯示通知除錯功能
          if (kDebugMode) ...[
            const SizedBox(height: 12.0),
            _DebugNotificationsWidget(),
          ],
        ],
      ),
    );
  }
}
