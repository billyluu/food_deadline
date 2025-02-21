part of 'app_settings_bloc.dart';

@immutable
sealed class AppSettingsState {}

final class AppSettingsInitial extends AppSettingsState {}

final class AppSettingsLocale extends AppSettingsState {
  AppSettingsLocale({
    required this.locale,
  });

  final Locale locale;
}

final class AppSettingsTheme extends AppSettingsState {
  AppSettingsTheme({
    required this.theme,
  });

  final ThemeData theme;
}
