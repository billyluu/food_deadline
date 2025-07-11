import 'package:food_deadline/core/constants/enums/app_notification_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String title,
    required String body,
    required AppNotificationType type,
    String? data,
  }) = _NotificationModel;
}