part of 'app_settings_bloc.dart';

class AppSettingsState {
  AppSettingsState({
    required this.appLocale,
    required this.theme,
    required this.notificationsEnabled,
    required this.notificationDaysBeforeExpiry,
  });

  final AppLocale appLocale;
  final ThemeMode theme;
  final bool notificationsEnabled;
  final int notificationDaysBeforeExpiry; // 過期前幾天發送通知

  AppSettingsState copyWith({
    AppLocale? appLocale,
    ThemeMode? theme,
    bool? notificationsEnabled,
    int? notificationDaysBeforeExpiry,
  }) {
    return AppSettingsState(
      appLocale: appLocale ?? this.appLocale,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      notificationDaysBeforeExpiry: notificationDaysBeforeExpiry ?? this.notificationDaysBeforeExpiry,
    );
  }
}
