part of 'app_settings_bloc.dart';

@immutable
sealed class AppSettingsEvent {}

final class AppSettingsLoadingEvent extends AppSettingsEvent {}

final class AppSettingsUpdateLocaleEvent extends AppSettingsEvent {
  AppSettingsUpdateLocaleEvent({
    required this.locale,
  });

  final Locale locale;
}

final class AppSettingsUpdateThemeEvent extends AppSettingsEvent {
  AppSettingsUpdateThemeEvent({
    required this.theme,
  });

  final ThemeMode theme;
}
