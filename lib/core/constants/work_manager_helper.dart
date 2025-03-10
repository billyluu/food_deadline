
import 'package:food_deadline/core/constants/enums/app_task.dart';
import 'package:food_deadline/core/constants/shared_preference_helper.dart';
import 'package:workmanager/workmanager.dart';

class WorkManagerHelper {

  static init() {
    Workmanager().initialize(_callbackDispatcher, isInDebugMode: true);
  }

  static void _callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      print('#### callback_dispatcher: $task');
      if (task == AppTask.updateDeadline.name) {
        final notifyEnable = await SharedPreferenceHelper.getNotificationsEnabled();
        if (notifyEnable) {
          print('#### 發送通知');
          // await showNotification("食物即將到期", "檢查你的食物庫存，避免浪費！");
        }
      }
      return Future.value(true);
    });
  }

  static void taskCallback(Function(String task) callback) {

  }
}