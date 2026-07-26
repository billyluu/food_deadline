import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:food_deadline/core/constants/app_localizations.dart';
import 'package:food_deadline/core/constants/app_string.s.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/core/utils/app_preference_helper.dart';
import 'package:food_deadline/core/utils/date_time_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  AndroidNotificationDetails? _androidDetails;
  DarwinNotificationDetails? _iosDetails;
  bool _initialized = false;

  Future<void> init({AppLocalizations? l10n}) async {
    // 背景 isolate 需要顯式註冊外掛
    DartPluginRegistrant.ensureInitialized();

    await _configureLocalTimeZone();

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
    _initialized = true;
  }

  Future<void> _configureLocalTimeZone() async {
    tz_data.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  NotificationDetails get _details {
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
    return NotificationDetails(android: androidDetails, iOS: iosDetails);
  }

  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    await _flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _details,
    );
  }

  /// 以 zonedSchedule 排一次精確通知（不循環）。
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    final scheduledDate = tz.TZDateTime.from(scheduledTime, tz.local);
    final payload = DateTimeHelper.toSeconds(scheduledTime).toString();

    Future<void> schedule(AndroidScheduleMode mode) {
      return _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        _details,
        payload: payload,
        androidScheduleMode: mode,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }

    try {
      await schedule(AndroidScheduleMode.exactAllowWhileIdle);
    } catch (e) {
      // 精確鬧鐘權限被拒時退回非精確模式
      if (e.toString().contains('exact_alarms_not_permitted')) {
        await schedule(AndroidScheduleMode.inexactAllowWhileIdle);
      } else {
        rethrow;
      }
    }
  }

  Future<void> cancelNotification({required int id}) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  int _reminderId(ExpirableItem item) =>
      (item.id.hashCode & 0x3FFFFFFF);

  int _expiredId(ExpirableItem item) => _reminderId(item) + 0x10000000;

  /// 為單一物品排程：提早 N 天 09:00，以及到期當天 09:00。
  Future<void> scheduleExpiryNotifications(
    ExpirableItem item, {
    AppLocalizations? l10n,
  }) async {
    final notificationsEnabled =
        await AppPreferenceHelper.getNotificationsEnabled();
    if (!notificationsEnabled) return;
    if (DateTimeHelper.isExpired(item.expiryDate)) return;

    final days = await AppPreferenceHelper.getNotificationDaysBeforeExpiry();
    final localizations = l10n ?? await AppLocalizations.loadFromPreference();
    final expiryDay =
        DateTimeHelper.startOfDay(DateTimeHelper.fromMilliseconds(item.expiryDate));
    final now = DateTimeHelper.now;

    // 提早 N 天早上 9:00
    final reminderAt = DateTimeHelper.createNotificationTime(
      expiryDay.subtract(Duration(days: days)),
    );
    if (reminderAt.isAfter(now)) {
      await scheduleNotification(
        id: _reminderId(item),
        title: AppString.notificationExpiryReminderTitle.tr(localizations),
        body: AppString.notificationExpiryReminderBody.tr(localizations, [
          item.name,
          days.toString(),
        ]),
        scheduledTime: reminderAt,
      );
    }

    // 到期當天早上 9:00
    final expiredAt = DateTimeHelper.createNotificationTime(expiryDay);
    if (expiredAt.isAfter(now)) {
      await scheduleNotification(
        id: _expiredId(item),
        title: AppString.notificationExpiredTitle.tr(localizations),
        body: AppString.notificationExpiredBody.tr(localizations, [item.name]),
        scheduledTime: expiredAt,
      );
    }
  }

  Future<void> cancelExpiryNotifications(ExpirableItem item) async {
    await cancelNotification(id: _reminderId(item));
    await cancelNotification(id: _expiredId(item));
  }

  /// 取消全部後依目前設定重新排程（啟動／設定變更／每日補掃用）。
  Future<int> scheduleAllItemNotifications(List<ExpirableItem> items) async {
    await cancelAll();

    final notificationsEnabled =
        await AppPreferenceHelper.getNotificationsEnabled();
    if (!notificationsEnabled) return -1;

    final l10n = await AppLocalizations.loadFromPreference();
    var scheduled = 0;
    for (final item in items) {
      if (DateTimeHelper.isExpired(item.expiryDate)) continue;
      await scheduleExpiryNotifications(item, l10n: l10n);
      scheduled++;
    }
    return scheduled;
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  bool get isInitialized => _initialized;
}
