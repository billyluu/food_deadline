import 'package:flutter/widgets.dart';
import 'package:food_deadline/core/constants/enums/app_task.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/core/realm/realm_helper.dart';
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
      await TaskManager.resyncScheduledNotifications();
    }
    return true;
  });
}

class TaskManager {
  static Future<void> init() {
    return Workmanager().initialize(callbackDispatcher);
  }

  /// 從資料庫補掃並重排所有 zonedSchedule 通知。
  /// 回傳排程物品數；通知關閉時回傳 -1。
  static Future<int> resyncScheduledNotifications() async {
    WidgetsFlutterBinding.ensureInitialized();

    final realmHelper = RealmHelper();
    try {
      final items = realmHelper.getAllItems().data ?? const <ExpirableItem>[];
      final service = NotificationService();
      await service.init();
      return await service.scheduleAllItemNotifications(items);
    } finally {
      realmHelper.dispose();
    }
  }

  /// 註冊每日背景補掃（備援）：重排精確通知，不直接 show。
  static Future<void> registerDailyResync() async {
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

  /// 註冊一次背景任務，用於測試 Workmanager 補掃路徑（約數秒後觸發）。
  static Future<void> registerOneOffResync() async {
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
