part of '../settings_screen.dart';

class _SettingThemeWidget extends StatelessWidget {
  AppString _themeLabel(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.system => AppString.themeModeSystem,
      ThemeMode.light => AppString.themeModeLight,
      ThemeMode.dark => AppString.themeModeDark,
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeItems = ThemeMode.values
        .map((element) => DropdownMenuItem<ThemeMode>(
            value: element,
            child: SharedText.i18n(
              _themeLabel(element),
              style: CommonTextStyle.textStyle(color: Theme.of(context).colorScheme.onTertiary),
            )))
        .toList();

    return SharedRoundedBox(
      background: Theme.of(context).colorScheme.tertiary,
      child: Row(
        children: [
          Expanded(
            child: SharedText.i18n(
              AppString.settingScreenThemeMode,
              style: CommonTextStyle.textStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
          const SizedBox(width: 24.0),
          BlocBuilder<AppSettingsBloc, AppSettingsState>(
            builder: (context, state) => DropdownButton<ThemeMode>(
              dropdownColor: Theme.of(context).colorScheme.tertiary,
              value: state.theme,
              items: themeItems,
              onChanged: (themeMode) {
                if (themeMode != null) {
                  context.read<AppSettingsBloc>().add(AppSettingsUpdateThemeEvent(theme: themeMode));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
