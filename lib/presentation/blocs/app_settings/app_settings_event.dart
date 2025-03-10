part of 'app_settings_bloc.dart';

@immutable
sealed class AppSettingsEvent {}

final class AppSettingsLoadingEvent extends AppSettingsEvent {}

final class AppSettingsUpdateLocaleEvent extends AppSettingsEvent {
  AppSettingsUpdateLocaleEvent({
    required this.appLocale,
  });

  final AppLocale appLocale;
}

final class AppSettingsUpdateThemeEvent extends AppSettingsEvent {
  AppSettingsUpdateThemeEvent({
    required this.theme,
  });

  final ThemeMode theme;
}

final class AppSettingsUpdateNotificationsEvent extends AppSettingsEvent {
  AppSettingsUpdateNotificationsEvent({
    required this.notificationsEnabled,
  });

  final bool notificationsEnabled;
}
