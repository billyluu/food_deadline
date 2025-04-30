import 'package:flutter/material.dart';
import 'package:food_deadline/app.dart';
import 'package:food_deadline/core/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();
  runApp(const App());
}
