import UIKit
import Flutter
import flutter_local_notifications
import workmanager_apple

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // 背景通知 action isolate 需要註冊 Flutter plugins
    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
      GeneratedPluginRegistrant.register(with: registry)
    }

    // 前景顯示本地通知必須設定 UNUserNotificationCenter delegate
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    // 對應 Info.plist BGTaskSchedulerPermittedIdentifiers
    WorkmanagerPlugin.registerPeriodicTask(
      withIdentifier: "update_deadline_task",
      frequency: NSNumber(value: 24 * 60 * 60)
    )
    WorkmanagerPlugin.registerBGProcessingTask(
      withIdentifier: "update_deadline_task_once"
    )

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
