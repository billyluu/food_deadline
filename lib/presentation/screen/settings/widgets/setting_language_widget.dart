part of '../settings_screen.dart';

class _SettingLanguageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final languages = AppLocale.values
        .map((element) => DropdownMenuItem<AppLocale>(
            value: element, child: Text(element.name)))
        .toList();

    return FdCard(
      background: Theme.of(context).colorScheme.tertiary,
      child: Row(
        children: [
          const CommonText(text: '語系: '),
          const SizedBox(width: 24.0),
          BlocBuilder<AppSettingsBloc, AppSettingsState>(
            builder: (context, state) => DropdownButton<AppLocale>(
              value: state.appLocale,
              items: languages,
              onChanged: (appLocale) {
                if (appLocale != null) {
                  context
                      .read<AppSettingsBloc>()
                      .add(AppSettingsUpdateLocaleEvent(appLocale: appLocale));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
