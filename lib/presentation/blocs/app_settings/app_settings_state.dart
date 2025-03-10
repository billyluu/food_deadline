part of 'app_settings_bloc.dart';

class AppSettingsState {
  AppSettingsState({
    required this.locale,
    required this.theme,
    required this.notificationsEnabled,
  });

  final Locale locale;
  final ThemeMode theme;
  final bool notificationsEnabled;

  AppSettingsState copyWith({
    Locale? locale,
    ThemeMode? theme,
    bool? notificationsEnabled,
  }) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }
}
