part of '../settings_screen.dart';

class _SettingLanguageWidget extends StatelessWidget {
  AppString _localeLabel(AppLocale locale) {
    return switch (locale) {
      AppLocale.enUs => AppString.localeEnUs,
      AppLocale.zhTW => AppString.localeZhTW,
    };
  }

  @override
  Widget build(BuildContext context) {
    final languages = AppLocale.values
        .map((element) => DropdownMenuItem<AppLocale>(
            value: element,
            child: SharedText.i18n(
              _localeLabel(element),
              style: CommonTextStyle.textStyle(color: Theme.of(context).colorScheme.onTertiary),
            )))
        .toList();

    return SharedRoundedBox(
      background: Theme.of(context).colorScheme.tertiary,
      child: Row(
        children: [
          Expanded(
            child: SharedText.i18n(
              AppString.settingScreenLanguage,
              style: CommonTextStyle.textStyle(color: Theme.of(context).colorScheme.onTertiary),
            ),
          ),
          const SizedBox(width: 24.0),
          BlocBuilder<AppSettingsBloc, AppSettingsState>(
            builder: (context, state) => DropdownButton<AppLocale>(
              dropdownColor: Theme.of(context).colorScheme.tertiary,
              value: state.appLocale,
              items: languages,
              onChanged: (appLocale) {
                if (appLocale != null) {
                  context.read<AppSettingsBloc>().add(AppSettingsUpdateLocaleEvent(appLocale: appLocale));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
