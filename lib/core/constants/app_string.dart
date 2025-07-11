import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/app_localizations.dart';

enum AppString {
  appName(key: 'app_name'),
  commonDelete(key: 'common_delete'),
  commonSend(key: 'common_send'),
  commonClose(key: 'common_close'),
  commonConfirm(key: 'common_confirm'),
  commonCancel(key: 'common_cancel'),
  bottomNavBarHome(key: 'bottomNavBar_home'),
  bottomNavBarSetting(key: 'bottomNavBar_setting'),
  homeScreenTotal(key: 'homeScreen_total'),
  homeScreenExpired(key: 'homeScreen_expired'),
  settingScreenThemeMode(key: 'settingScreen_themeMode'),
  settingScreenNotificationSwitch(key: 'settingScreen_notificationSwitch'),
  settingScreenNotificationDays(key: 'settingScreen_notificationDays'),
  settingScreenDaysBeforeExpiry(key: 'settingScreen_daysBeforeExpiry'),
  settingScreenLanguage(key: 'settingScreen_language'),
  editExpirableItemScreenAdd(key: 'editExpirableItemScreen_add'),
  editExpirableItemScreenName(key: 'editExpirableItemScreen_name'),
  editExpirableItemScreenInputPlaceHolder(key: 'editExpirableItemScreen_input_placeHolder'),
  notificationExpiryReminderTitle(key: 'notification_expiry_reminder_title'),
  notificationExpiryReminderBody(key: 'notification_expiry_reminder_body'),
  notificationExpiredTitle(key: 'notification_expired_title'),
  notificationExpiredBody(key: 'notification_expired_body'),
  permissionNotificationTitle(key: 'permission_notification_title'),
  permissionNotificationDescription(key: 'permission_notification_description'),
  permissionExactAlarmTitle(key: 'permission_exact_alarm_title'),
  permissionExactAlarmDescription(key: 'permission_exact_alarm_description'),
  permissionLaterButton(key: 'permission_later_button'),
  permissionGrantButton(key: 'permission_grant_button'),
  permissionNormalModeButton(key: 'permission_normal_mode_button'),
  permissionWelcomeTitle(key: 'permission_welcome_title'),
  permissionWelcomeDescription(key: 'permission_welcome_description'),
  permissionFeatureTimely(key: 'permission_feature_timely'),
  permissionFeatureTimelyDesc(key: 'permission_feature_timely_desc'),
  permissionFeatureWarning(key: 'permission_feature_warning'),
  permissionFeatureWarningDesc(key: 'permission_feature_warning_desc'),
  permissionFeatureCustom(key: 'permission_feature_custom'),
  permissionFeatureCustomDesc(key: 'permission_feature_custom_desc'),
  splashSubtitle(key: 'splash_subtitle'),
  ;

  const AppString({
    required this.key,
  });

  final String key;

  String getI18n(BuildContext context, [List<String>? args]) {
    return AppLocalizations.of(context).translate(key, args);
  }
}
