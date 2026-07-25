import 'package:flutter/widgets.dart';
import 'package:food_deadline/core/constants/app_localizations.dart';
import 'package:food_deadline/core/constants/app_string.s.dart';
import 'package:food_deadline/core/constants/enums/app_task.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/core/realm/realm_helper.dart';
import 'package:food_deadline/core/utils/app_preference_helper.dart';
import 'package:food_deadline/core/utils/date_time_helper.dart';
import 'package:food_deadline/core/utils/notification_service.dart';
import 'package:food_deadline/core/utils/result.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // Android 傳 taskName；iOS BGTaskScheduler 傳 uniqueName
    if (task == AppTask.updateDeadline.name ||
        task == 'update_deadline_task' ||
        task == 'update_deadline_task_once') {
      await TaskManager.runDeadlineCheck();
    }
    return true;
  });
}

class TaskManager {
  static Future<void> init() {
    return Workmanager().initialize(callbackDispatcher);
  }

  /// 執行到期檢查邏輯（前景測試或背景排程皆可呼叫）。
  /// 回傳找到的即將過期／已過期物品數量；通知關閉時回傳 -1。
  static Future<int> runDeadlineCheck() async {
    WidgetsFlutterBinding.ensureInitialized();

    final enabled = await AppPreferenceHelper.getNotificationsEnabled();
    if (!enabled) return -1;

    final days = await AppPreferenceHelper.getNotificationDaysBeforeExpiry();

    final realmHelper = RealmHelper();
    try {
      final items = realmHelper.getAllItems().data ?? const <ExpirableItem>[];

      final expiredToday = <String>[];
      final expiringSoon = <({String name, int daysLeft})>[];

      for (final it in items) {
        final d = DateTimeHelper.daysUntilExpiry(it.expiryDate);
        if (d < 0 || d > days) continue;
        if (d == 0) {
          expiredToday.add(it.name);
        } else {
          expiringSoon.add((name: it.name, daysLeft: d));
        }
      }

      final total = expiredToday.length + expiringSoon.length;
      if (total == 0) return 0;

      final l10n = await AppLocalizations.loadFromPreference();
      final service = NotificationService();
      await service.init(l10n: l10n);

      // d == 0：今天到期（當日 23:59:59 前仍未過期）
      final separator = AppString.commonListSeparator.tr(l10n);

      if (expiredToday.isNotEmpty) {
        final body = expiredToday.length == 1
            ? AppString.notificationExpiredBody.tr(l10n, [expiredToday.first])
            : AppString.notificationExpiredBodyMultiple.tr(l10n, [
                expiredToday.length.toString(),
                expiredToday.join(separator),
              ]);
        await service.showNow(
          id: 999999,
          title: AppString.notificationExpiredTitle.tr(l10n),
          body: body,
        );
      }

      if (expiringSoon.isNotEmpty) {
        final body = expiringSoon.length == 1
            ? AppString.notificationExpiryReminderBody.tr(l10n, [
                expiringSoon.first.name,
                expiringSoon.first.daysLeft.toString(),
              ])
            : AppString.notificationExpiryReminderBodyMultiple.tr(l10n, [
                expiringSoon.length.toString(),
                expiringSoon.map((e) => e.name).join(separator),
              ]);
        await service.showNow(
          id: 999998,
          title: AppString.notificationExpiryReminderTitle.tr(l10n),
          body: body,
        );
      }

      return total;
    } finally {
      realmHelper.dispose();
    }
  }

  static Future<void> registerDailyNotification() async {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);

    await Workmanager().registerPeriodicTask(
      'update_deadline_task',
      AppTask.updateDeadline.name,
      frequency: const Duration(hours: 24),
      initialDelay: nextMidnight.difference(now),
      // 更新既有任務，讓先前非午夜起算的排程重新對齊 00:00。
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
      tag: 'deadline_tasks',
    );
  }

  /// 註冊一次背景任務，用於測試 Workmanager 路徑（約數秒後觸發）。
  static Future<void> registerOneOffDeadlineCheck() async {
    await Workmanager().registerOneOffTask(
      'update_deadline_task_once',
      AppTask.updateDeadline.name,
      initialDelay: const Duration(seconds: 5),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
      tag: 'deadline_tasks',
    );
  }

  static Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
  }
}
