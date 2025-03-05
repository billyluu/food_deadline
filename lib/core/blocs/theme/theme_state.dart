part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {}

final class Theme extends ThemeState {
  Theme({
    required this.theme,
  });

  final AppThemeMode theme;
}
