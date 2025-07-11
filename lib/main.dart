import 'package:flutter/material.dart';
import 'package:food_deadline/app.dart';
import 'package:food_deadline/core/di/service_locator.dart';
import 'package:food_deadline/core/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化依賴注入
  await setupServiceLocator();
  
  // 初始化通知服務
  final notificationService = getIt<NotificationService>();
  await notificationService.init();
  
  runApp(const App());
}
