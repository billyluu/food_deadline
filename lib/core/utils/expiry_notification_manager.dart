import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/app_string.dart';
import 'package:food_deadline/core/constants/shared_preference_helper.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/core/utils/notification_service.dart';

class ExpiryNotificationManager {
  final NotificationService notificationService;

  ExpiryNotificationManager({required this.notificationService});

  Future<void> scheduleExpiryNotifications(ExpirableItem item, BuildContext context) async {
    final notificationDays = await SharedPreferenceHelper.getNotificationDaysBeforeExpiry();
    final notificationsEnabled = await SharedPreferenceHelper.getNotificationsEnabled();
    
    if (!notificationsEnabled) return;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(item.expiryDate);
    final now = DateTime.now();
    
    // 排程提前通知（X天前）
    final reminderDate = expiryDate.subtract(Duration(days: notificationDays));
    if (reminderDate.isAfter(now)) {
      await notificationService.scheduleNotification(
        id: item.id.hashCode,
        title: AppString.notificationExpiryReminderTitle.getI18n(context),
        body: AppString.notificationExpiryReminderBody.getI18n(context, [item.name, notificationDays.toString()]),
        scheduledTime: DateTime(
          reminderDate.year,
          reminderDate.month,
          reminderDate.day,
          9, // 早上9點提醒
          0,
        ),
      );
    }
    
    // 排程過期當天通知
    if (expiryDate.isAfter(now)) {
      await notificationService.scheduleNotification(
        id: item.id.hashCode + 1000000,
        title: AppString.notificationExpiredTitle.getI18n(context),
        body: AppString.notificationExpiredBody.getI18n(context, [item.name]),
        scheduledTime: DateTime(
          expiryDate.year,
          expiryDate.month,
          expiryDate.day,
          9, // 早上9點通知
          0,
        ),
      );
    }
  }

  Future<void> cancelExpiryNotifications(ExpirableItem item) async {
    await notificationService.cancelNotification(id: item.id.hashCode);
    await notificationService.cancelNotification(id: item.id.hashCode + 1000000);
  }
}