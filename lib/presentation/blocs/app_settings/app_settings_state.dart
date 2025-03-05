part of 'app_settings_bloc.dart';

class AppSettingsState {
  AppSettingsState({
    required this.locale,
    required this.theme,
  });

  final Locale locale;
  final ThemeMode theme;

  AppSettingsState copyWith({
    Locale? locale,
    ThemeMode? theme,
  }) {
    return AppSettingsState(
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
    );
  }
}
