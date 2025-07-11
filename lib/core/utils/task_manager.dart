import 'package:food_deadline/core/constants/enums/app_task.dart';
import 'package:workmanager/workmanager.dart';

typedef TaskSpec = ({
  String uniqueName,
  String taskName,
  Duration? frequency,
  String? tag,
  ExistingWorkPolicy? existingWorkPolicy,
  Duration initialDelay,
  Constraints? constraints,
  BackoffPolicy? backoffPolicy,
  Duration backoffPolicyDelay,
  OutOfQuotaPolicy? outOfQuotaPolicy,
  Map<String, dynamic>? inputData,
});

class TaskManager {
  static void init(Function(String appTaskName) callbackDispatcher) {
    Workmanager().initialize(() {
      Workmanager().executeTask((task, inputData) async {
        callbackDispatcher(task);
        return Future.value(true);
      });
    }, isInDebugMode: true);
  }

  static Future<void> registerDailyNotification() async {
    await Workmanager().registerPeriodicTask(
      'update_deadline_task',
      AppTask.updateDeadline.name,
      frequency: const Duration(hours: 24),
      constraints: Constraints(
        networkType: NetworkType.not_required,
        requiresBatteryNotLow: true,
      ),
      tag: 'deadline_tasks',
    );
  }

  static Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();
  }
}
