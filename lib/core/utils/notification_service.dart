import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_deadline/core/constants/app_localizations.dart';
import 'package:food_deadline/core/constants/app_string.s.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationDetails? _androidDetails;
  DarwinNotificationDetails? _iosDetails;

  Future<void> init({AppLocalizations? l10n}) async {
    // 背景 isolate 需要顯式註冊外掛
    DartPluginRegistrant.ensureInitialized();

    final localizations = l10n ?? await AppLocalizations.loadFromPreference();
    _androidDetails = AndroidNotificationDetails(
      'food_channel',
      AppString.notificationChannelName.tr(localizations),
      channelDescription:
          AppString.notificationChannelDescription.tr(localizations),
      importance: Importance.max,
      priority: Priority.high,
    );
    _iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 權限改由 Permission.notification 統一請求，避免啟動時重複彈窗
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // Android 13+ / iOS 皆需明確請求通知權限
    await Permission.notification.request();
  }

  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    final androidDetails = _androidDetails ??
        const AndroidNotificationDetails(
          'food_channel',
          'Food Notifications',
          channelDescription: 'Notifications for food expiry reminders',
          importance: Importance.max,
          priority: Priority.high,
        );
    final iosDetails = _iosDetails ??
        const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        );

    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      ),
    );
  }

  Future<void> cancelNotification({required int id}) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
