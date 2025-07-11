import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_deadline/core/constants/shared_preference_helper.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/core/utils/date_time_helper.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tzData.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'food_channel',
            'Food Notifications',
            channelDescription: '提醒食物到期的通知',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
        payload: DateTimeHelper.toSeconds(scheduledTime).toString(),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    } catch (e) {
      // 如果精確鬧鐘權限被拒絕，嘗試使用非精確模式
      if (e.toString().contains('exact_alarms_not_permitted')) {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(scheduledTime, tz.local),
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'food_channel',
              'Food Notifications',
              channelDescription: '提醒食物到期的通知',
              importance: Importance.max,
              priority: Priority.high,
            ),
          ),
          payload: DateTimeHelper.toSeconds(scheduledTime).toString(),
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dateAndTime,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
        );
      } else {
        rethrow;
      }
    }
  }

  Future<void> cancelNotification({required int id}) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> scheduleAllItemNotifications(List<ExpirableItem> items) async {
    // 先取消所有現有通知
    await _flutterLocalNotificationsPlugin.cancelAll();
    
    // 為每個未過期的食物排程通知
    for (final item in items) {
      if (!DateTimeHelper.isExpired(item.expiryDate)) {
        await scheduleExpiryNotifications(item);
      }
    }
  }

  Future<void> scheduleExpiryNotifications(ExpirableItem item) async {
    final notificationDays = await SharedPreferenceHelper.getNotificationDaysBeforeExpiry();
    final notificationsEnabled = await SharedPreferenceHelper.getNotificationsEnabled();
    
    if (!notificationsEnabled) return;

    final expiryDate = DateTimeHelper.fromMilliseconds(item.expiryDate);
    final now = DateTimeHelper.now;
    
    // 使用簡單的ID生成策略，確保在32位整數範圍內
    final baseId = (item.id.hashCode % 1000000).abs();
    
    // 排程提前通知（X天前）
    final reminderDate = expiryDate.subtract(Duration(days: notificationDays));
    if (reminderDate.isAfter(now)) {
      await scheduleNotification(
        id: baseId,
        title: '食物即將過期提醒',
        body: '${item.name} 將在 $notificationDays 天後過期',
        scheduledTime: DateTimeHelper.createNotificationTime(reminderDate),
      );
    }
    
    // 排程過期當天通知
    if (expiryDate.isAfter(now)) {
      await scheduleNotification(
        id: baseId + 100000,
        title: '食物已過期',
        body: '${item.name} 今天已過期，請儘快處理',
        scheduledTime: DateTimeHelper.createNotificationTime(expiryDate),
      );
    }
  }

  Future<void> cancelExpiryNotifications(ExpirableItem item) async {
    final baseId = (item.id.hashCode % 1000000).abs();
    await cancelNotification(id: baseId);
    await cancelNotification(id: baseId + 100000);
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }
}
