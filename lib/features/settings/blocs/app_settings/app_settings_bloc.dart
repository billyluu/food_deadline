import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/enums/app_locale.dart';
import 'package:food_deadline/core/constants/shared_preference_helper.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc()
      : super(
          AppSettingsState(appLocale: AppLocale.zhTW, theme: ThemeMode.system, notificationsEnabled: true),
        ) {
    on<AppSettingsLoadingEvent>((event, emit) => _loadAppSettings(event, emit));
    on<AppSettingsUpdateLocaleEvent>((event, emit) => _updateLocale(event, emit));
    on<AppSettingsUpdateThemeEvent>((event, emit) => _updateTheme(event, emit));
    on<AppSettingsUpdateNotificationsEvent>((event, emit) => _updateNotifications(event, emit));
  }

  Future<void> _loadAppSettings(AppSettingsLoadingEvent event,
      Emitter<AppSettingsState> emit) async {
    final locale = await SharedPreferenceHelper.getLocale();
    final theme = await SharedPreferenceHelper.getThemeMode();
    final notificationsEnabled = await SharedPreferenceHelper.getNotificationsEnabled();
    emit(state.copyWith(appLocale: locale, theme: theme, notificationsEnabled: notificationsEnabled));
  }

  Future<void> _updateLocale(AppSettingsUpdateLocaleEvent event,
      Emitter<AppSettingsState> emit) async {
    SharedPreferenceHelper.setLocale(event.appLocale.name);
    emit(state.copyWith(appLocale: event.appLocale));
  }

  Future<void> _updateTheme(AppSettingsUpdateThemeEvent event,
      Emitter<AppSettingsState> emit) async {
    SharedPreferenceHelper.setThemeMode(event.theme);
    emit(state.copyWith(theme: event.theme));
  }

  Future<void> _updateNotifications(AppSettingsUpdateNotificationsEvent event,
      Emitter<AppSettingsState> emit) async {
    SharedPreferenceHelper.setNotificationsEnabled(event.notificationsEnabled);
    emit(state.copyWith(notificationsEnabled: event.notificationsEnabled));
  }
}
