part of '../settings_screen.dart';

class _SettingNotificationDaysWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        return SharedRoundedBox(
          background: Theme.of(context).colorScheme.tertiary,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SharedText.i18n(
                AppString.settingScreenNotificationDays,
                style: CommonTextStyle.textStyle(
                  color: Theme.of(context).colorScheme.onTertiary,
                ),
              ),
              const SizedBox(width: 24.0),
              DropdownButton<int>(
                value: state.notificationDaysBeforeExpiry,
                items: AppConstants.notificationDaysOptions.map((int days) {
                  return DropdownMenuItem<int>(
                    value: days,
                    child: Text(
                      AppString.settingScreenDaysBeforeExpiry.getI18n(context, [days.toString()]),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onTertiary,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: state.notificationsEnabled ? (int? newValue) {
                  if (newValue != null) {
                    context.read<AppSettingsBloc>().add(
                      AppSettingsUpdateNotificationDaysEvent(
                        notificationDaysBeforeExpiry: newValue,
                      ),
                    );
                  }
                } : null, // 如果通知關閉，則禁用下拉選單
                underline: Container(), // 移除下劃線
                dropdownColor: Theme.of(context).colorScheme.tertiary,
              ),
            ],
          ),
        );
      },
    );
  }
}