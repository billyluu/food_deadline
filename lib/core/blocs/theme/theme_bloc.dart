import 'package:bloc/bloc.dart';
import 'package:food_deadline/core/constants/enums/app_theme_mode.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(Theme(theme: AppThemeMode.system)) {
    on<ThemeUpdateEvent>((event, emit) => emit(Theme(theme: event.theme)));
  }
}
