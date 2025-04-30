part of 'app_settings_bloc.dart';

class AppSettingsState {
  AppSettingsState({
    required this.appLocale,
    required this.theme,
    required this.notificationsEnabled,
  });

  final AppLocale appLocale;
  final ThemeMode theme;
  final bool notificationsEnabled;

  AppSettingsState copyWith({
    AppLocale? appLocale,
    ThemeMode? theme,
    bool? notificationsEnabled,
  }) {
    return AppSettingsState(
      appLocale: appLocale ?? this.appLocale,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
