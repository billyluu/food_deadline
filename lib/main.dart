import 'package:flutter/material.dart';
import 'package:food_deadline/app.dart';
import 'package:food_deadline/core/di/service_locator.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/core/realm/realm_helper.dart';
import 'package:food_deadline/core/utils/notification_service.dart';
import 'package:food_deadline/core/utils/result.dart';
import 'package:food_deadline/core/utils/task_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化依賴注入
  await setupServiceLocator();

  // 初始化通知服務，並依資料庫為每個物品排精確通知
  final notificationService = getIt<NotificationService>();
  await notificationService.init();
  final items =
      getIt<RealmHelper>().getAllItems().data ?? const <ExpirableItem>[];
  await notificationService.scheduleAllItemNotifications(items);

  // WorkManager 僅作每日補掃／重排備援
  await TaskManager.init();
  await TaskManager.registerDailyResync();

  runApp(const App());
}
