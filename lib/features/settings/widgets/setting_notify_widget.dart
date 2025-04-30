part of '../settings_screen.dart';

class _SettingNotifyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FdCard(
      background: Theme.of(context).colorScheme.tertiary,
      child: Row(
        children: [
          CommonText(
            text: AppString.settingScreenNotificationSwitch.getL10n(context),
            style: CommonTextStyle.textStyle(
                color: Theme.of(context).colorScheme.onTertiary),
          ),
          const SizedBox(width: 24.0),
          BlocBuilder<AppSettingsBloc, AppSettingsState>(
            builder: (context, state) => Switch(
                value: state.notificationsEnabled,
                onChanged: (value) {
                  context.read<AppSettingsBloc>().add(
                      AppSettingsUpdateNotificationsEvent(
                          notificationsEnabled: value));
                }),
          ),
        ],
      ),
    );
  }
}
