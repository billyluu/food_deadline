import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_deadline/core/constants/app_string.s.dart';
import 'package:food_deadline/core/di/service_locator.dart';
import 'package:food_deadline/core/utils/date_time_helper.dart';
import 'package:food_deadline/core/utils/notification_service.dart';
import 'package:food_deadline/core/utils/task_manager.dart';

class DebugNotificationsScreen extends StatefulWidget {
  const DebugNotificationsScreen({super.key});

  @override
  State<DebugNotificationsScreen> createState() =>
      _DebugNotificationsScreenState();
}

class _DebugNotificationsScreenState extends State<DebugNotificationsScreen> {
  List<PendingNotificationRequest> _pendingNotifications = [];
  bool _isLoading = true;
  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _loadPendingNotifications();
  }

  Future<void> _loadPendingNotifications() async {
    setState(() => _isLoading = true);

    try {
      final notificationService = getIt<NotificationService>();
      final notifications = await notificationService.getPendingNotifications();

      setState(() {
        _pendingNotifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('載入通知失敗: $e')),
        );
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _sendTestNotification() async {
    setState(() => _isBusy = true);
    try {
      final service = getIt<NotificationService>();
      await service.showNow(
        id: 888888,
        title: AppString.notificationExpiredTitle.getI18n(context),
        body: AppString.notificationExpiredBody.getI18n(context, ['測試物品']),
      );
      _showMessage('已發送「已過期」測試通知，請檢查通知列');
    } catch (e) {
      _showMessage('發送失敗: $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _resyncNow() async {
    setState(() => _isBusy = true);
    try {
      final count = await TaskManager.resyncScheduledNotifications();
      await _loadPendingNotifications();
      if (count < 0) {
        _showMessage('通知已關閉，已清除所有排程');
      } else {
        _showMessage('已重排 $count 項物品的精確通知');
      }
    } catch (e) {
      _showMessage('重排失敗: $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _runBackgroundOneOff() async {
    setState(() => _isBusy = true);
    try {
      await TaskManager.registerOneOffResync();
      _showMessage('已註冊背景補掃，約 5 秒後觸發（可將 App 切到背景）');
    } catch (e) {
      _showMessage('註冊失敗: $e');
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('通知測試'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isBusy ? null : _loadPendingNotifications,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  onPressed: _isBusy ? null : _sendTestNotification,
                  icon: const Icon(Icons.notifications_active),
                  label: const Text('發送測試通知'),
                ),
                const SizedBox(height: 8),
                FilledButton.tonalIcon(
                  onPressed: _isBusy ? null : _resyncNow,
                  icon: const Icon(Icons.sync),
                  label: const Text('立即補掃／重排通知'),
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _isBusy ? null : _runBackgroundOneOff,
                  icon: const Icon(Icons.schedule),
                  label: const Text('5 秒後背景補掃／重排'),
                ),
                if (_isBusy) ...[
                  const SizedBox(height: 12),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _pendingNotifications.isEmpty
                    ? const Center(
                        child: Text(
                          '目前沒有排程的通知\n（新增未過期物品後會以 zonedSchedule 排到 09:00）',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _pendingNotifications.length,
                        itemBuilder: (context, index) {
                          final notification = _pendingNotifications[index];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'ID: ${notification.id}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    notification.title ?? '無標題',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notification.body ?? '無內容',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '排程時間: ${_formatDateTime(notification.payload)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String? payload) {
    try {
      if (payload == null || payload.isEmpty) {
        return '無時間資訊';
      }

      final timestamp = int.tryParse(payload);
      if (timestamp == null) {
        return '無時間資訊';
      }

      return DateTimeHelper.formatSecondsToDateTime(timestamp);
    } catch (e) {
      return '無時間資訊';
    }
  }
}
