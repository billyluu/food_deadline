part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

final class ThemeUpdateEvent extends ThemeEvent {
  ThemeUpdateEvent({
    required this.theme,
  });

  final AppThemeMode theme;
}
