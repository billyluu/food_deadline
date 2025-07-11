import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:food_deadline/core/di/service_locator.dart';
import 'package:food_deadline/core/utils/notification_service.dart';
import 'package:food_deadline/core/utils/date_time_helper.dart';
import 'package:intl/intl.dart';

class DebugNotificationsScreen extends StatefulWidget {
  const DebugNotificationsScreen({super.key});

  @override
  State<DebugNotificationsScreen> createState() =>
      _DebugNotificationsScreenState();
}

class _DebugNotificationsScreenState extends State<DebugNotificationsScreen> {
  List<PendingNotificationRequest> _pendingNotifications = [];
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('排程通知列表'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPendingNotifications,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pendingNotifications.isEmpty
              ? const Center(
                  child: Text(
                    '目前沒有排程的通知',
                    style: TextStyle(fontSize: 16),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'ID: ${notification.id}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getNotificationTypeColor(
                                        notification.id),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    _getNotificationType(notification.id),
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _loadPendingNotifications();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }

  String _getNotificationType(int id) {
    if (id >= 100000) {
      return '過期通知';
    } else {
      return '提醒通知';
    }
  }

  Color _getNotificationTypeColor(int id) {
    if (id >= 100000) {
      return Colors.red;
    } else {
      return Colors.orange;
    }
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

      // payload 儲存的是秒級時間戳
      return DateTimeHelper.formatSecondsToDateTime(timestamp);
    } catch (e) {
      return '無時間資訊';
    }
  }
}
