import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_deadline/core/constants/app_string.s.dart';
import 'package:food_deadline/shared/widgets/shared_text.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// 請求通知權限
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// 請求精確鬧鐘權限
  static Future<bool> requestExactAlarmPermission() async {
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      final bool? granted =
          await androidImplementation.requestExactAlarmsPermission();
      return granted ?? false;
    }
    return false;
  }

  /// 檢查通知權限狀態
  static Future<bool> checkNotificationPermission() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  /// 顯示權限請求對話框
  static Future<bool> showPermissionDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title:
                  const SharedText.i18n(AppString.permissionNotificationTitle),
              content: const SharedText.i18n(
                  AppString.permissionNotificationDescription),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const SharedText.i18n(AppString.permissionLaterButton),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const SharedText.i18n(AppString.permissionGrantButton),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// 顯示精確鬧鐘權限對話框
  static Future<bool> showExactAlarmPermissionDialog(
      BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(AppString.permissionExactAlarmTitle.getI18n(context)),
              content: Text(
                  AppString.permissionExactAlarmDescription.getI18n(context)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(
                      AppString.permissionNormalModeButton.getI18n(context)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(AppString.permissionGrantButton.getI18n(context)),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  /// 完整的權限請求流程
  static Future<void> requestAllPermissions(BuildContext context) async {
    // 檢查通知權限
    final hasNotificationPermission = await checkNotificationPermission();

    if (!hasNotificationPermission) {
      // 直接請求通知權限，會顯示原生彈窗
      await requestNotificationPermission();
    }

    // 請求精確鬧鐘權限
    await requestExactAlarmPermission();
  }
}
