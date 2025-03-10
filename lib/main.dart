import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_deadline/core/constants/enums/app_task.dart';
import 'package:food_deadline/core/constants/shared_preference_helper.dart';
import 'package:food_deadline/presentation/blocs/app_settings/app_settings_bloc.dart';
import 'package:food_deadline/presentation/screen/main/main_screen.dart';
import 'package:workmanager/workmanager.dart';

// 創建 FlutterLocalNotificationsPlugin 實例
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher'); // 設定通知圖標

  const InitializationSettings initializationSettings =
  InitializationSettings(android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}


void registerPeriodicTask() {
  print('#### register_periodic_task');
  Workmanager().registerPeriodicTask(
    '#### update_1',
    AppTask.updateDeadline.name,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      networkType: NetworkType.not_required,
      requiresCharging: false,
      requiresBatteryNotLow: true,
    ),
  );
}

Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'deadline_channel', // 通知頻道 ID
    'Deadline Notifications', // 頻道名稱
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // 通知 ID
    title,
    body,
    notificationDetails,
  );
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initNotifications();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    registerPeriodicTask();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppSettingsBloc>(create: (context) => AppSettingsBloc()),
      ],
      child: BlocConsumer<AppSettingsBloc, AppSettingsState>(
        listener: (context, state) {

        },
        builder: (context, state) {
          context.read<AppSettingsBloc>().add(AppSettingsLoadingEvent());
          return MaterialApp(
            locale: state.appLocale.getLocale(),
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.green, brightness: Brightness.light),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Colors.green, brightness: Brightness.dark),
              useMaterial3: true,
            ),
            themeMode: state.theme,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}