import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/app_constants.dart';
import 'package:food_deadline/core/constants/enums/app_locale.dart';
import 'package:food_deadline/core/di/service_locator.dart';
import 'package:food_deadline/core/realm/models/expirable_item.dart';
import 'package:food_deadline/core/realm/realm_helper.dart';
import 'package:food_deadline/core/utils/app_preference_helper.dart';
import 'package:food_deadline/core/utils/notification_service.dart';
import 'package:food_deadline/core/utils/result.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc()
      : super(
          AppSettingsState(
            appLocale: AppLocale.zhTW, 
            theme: ThemeMode.system, 
            notificationsEnabled: true,
            notificationDaysBeforeExpiry: AppConstants.defaultNotificationDays,
          ),
        ) {
    on<AppSettingsLoadingEvent>((event, emit) => _loadAppSettings(event, emit));
    on<AppSettingsUpdateLocaleEvent>((event, emit) => _updateLocale(event, emit));
    on<AppSettingsUpdateThemeEvent>((event, emit) => _updateTheme(event, emit));
    on<AppSettingsUpdateNotificationsEvent>((event, emit) => _updateNotifications(event, emit));
    on<AppSettingsUpdateNotificationDaysEvent>((event, emit) => _updateNotificationDays(event, emit));
    
    // 在建構時自動載入設定
    add(AppSettingsLoadingEvent());
  }

  Future<void> _resyncNotifications() async {
    final items =
        getIt<RealmHelper>().getAllItems().data ?? const <ExpirableItem>[];
    await getIt<NotificationService>().scheduleAllItemNotifications(items);
  }

  Future<void> _loadAppSettings(AppSettingsLoadingEvent event, Emitter<AppSettingsState> emit) async {
    final locale = await AppPreferenceHelper.getLocale();
    final theme = await AppPreferenceHelper.getThemeMode();
    final notificationsEnabled = await AppPreferenceHelper.getNotificationsEnabled();
    final notificationDays = await AppPreferenceHelper.getNotificationDaysBeforeExpiry();
    emit(state.copyWith(
      appLocale: locale, 
      theme: theme, 
      notificationsEnabled: notificationsEnabled,
      notificationDaysBeforeExpiry: notificationDays,
    ));
  }

  Future<void> _updateLocale(AppSettingsUpdateLocaleEvent event, Emitter<AppSettingsState> emit) async {
    AppPreferenceHelper.setLocale(event.appLocale.name);
    emit(state.copyWith(appLocale: event.appLocale));
    // 語系變更後重排，讓已排程通知文案跟著更新
    await _resyncNotifications();
  }

  Future<void> _updateTheme(AppSettingsUpdateThemeEvent event, Emitter<AppSettingsState> emit) async {
    AppPreferenceHelper.setThemeMode(event.theme);
    emit(state.copyWith(theme: event.theme));
  }

  Future<void> _updateNotifications(AppSettingsUpdateNotificationsEvent event, Emitter<AppSettingsState> emit) async {
    await AppPreferenceHelper.setNotificationsEnabled(event.notificationsEnabled);
    emit(state.copyWith(notificationsEnabled: event.notificationsEnabled));
    await _resyncNotifications();
  }

  Future<void> _updateNotificationDays(AppSettingsUpdateNotificationDaysEvent event, Emitter<AppSettingsState> emit) async {
    await AppPreferenceHelper.setNotificationDaysBeforeExpiry(event.notificationDaysBeforeExpiry);
    emit(state.copyWith(notificationDaysBeforeExpiry: event.notificationDaysBeforeExpiry));
    await _resyncNotifications();
  }
}
