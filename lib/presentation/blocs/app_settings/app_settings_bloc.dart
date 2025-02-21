import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

class AppSettingsBloc extends Bloc<AppSettingsEvent, AppSettingsState> {
  AppSettingsBloc() : super(AppSettingsInitial()) {
    on<AppSettingsUpdateLocaleEvent>((event, emit) {
      emit(AppSettingsLocale(locale: event.locale));
    });
    on<AppSettingsUpdateThemeEvent>((event, emit) {
      emit(AppSettingsTheme(theme: event.theme));
    });
  }
}
