part of '../settings_screen.dart';

class _SettingLanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languages = AppLocale.values
        .map((element) => DropdownMenuItem<AppLocale>(
            value: element,
            child: SharedCommonText(
              text: element.name,
              style: CommonTextStyle.textStyle(color: Theme.of(context).colorScheme.onTertiary),
            )))
        .toList();

    return RoundedBox(
      background: Theme.of(context).colorScheme.tertiary,
      child: Row(
        children: [
          SharedCommonText(
            text: AppString.settingScreenLanguage.getI18n(context),
            style: CommonTextStyle.textStyle(color: Theme.of(context).colorScheme.onTertiary),
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
