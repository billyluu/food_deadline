part of '../settings_screen.dart';

class _SettingNotifyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FdCard(
      background: Theme.of(context).colorScheme.tertiary,
      child: Row(
        children: [
          const CommonText(text: '通知開關: '),
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
