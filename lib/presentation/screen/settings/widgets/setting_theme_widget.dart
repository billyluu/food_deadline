part of '../settings_screen.dart';

class _SettingThemeWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final themeItems = ThemeMode.values
        .map((e) => DropdownMenuItem<ThemeMode>(value: e, child: Text(e.name)))
        .toList();

    return FdCard(
      background: Theme.of(context).colorScheme.tertiary,
      child: Row(
        children: [
          const CommonText(text: '主題模式: '),
          const SizedBox(width: 24.0),
          BlocBuilder<AppSettingsBloc, AppSettingsState>(
            builder: (context, state) => DropdownButton<ThemeMode>(
              value: state.theme,
              items: themeItems,
              onChanged: (themeMode) {
                if (themeMode != null) {
                  context
                      .read<AppSettingsBloc>()
                      .add(AppSettingsUpdateThemeEvent(theme: themeMode));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}