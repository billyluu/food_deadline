import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/shared_preference_helper.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc()
      : super(
          AppSettingsState(locale: const Locale('en'), theme: ThemeMode.system),
        ) {
    on<AppSettingsLoadingEvent>((event, emit) => _loadAppSettings(event, emit));
    on<AppSettingsUpdateLocaleEvent>((event, emit) => _updateLocale(event, emit));
    on<AppSettingsUpdateThemeEvent>((event, emit) => _updateTheme(event, emit));
  }

  Future<void> _loadAppSettings(AppSettingsLoadingEvent event,
      Emitter<AppSettingsState> emit) async {
    final locale = await SharedPreferenceHelper.getLocale();
    final theme = await SharedPreferenceHelper.getThemeMode();
    emit(state.copyWith(locale: locale, theme: theme));
  }

  Future<void> _updateLocale(AppSettingsUpdateLocaleEvent event,
      Emitter<AppSettingsState> emit) async {
    emit(state.copyWith(locale: event.locale));
  }

  Future<void> _updateTheme(AppSettingsUpdateThemeEvent event,
      Emitter<AppSettingsState> emit) async {
    SharedPreferenceHelper.setThemeMode(event.theme);
    emit(state.copyWith(theme: event.theme));
  }
}
