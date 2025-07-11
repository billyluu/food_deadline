// GENERATED CODE - DO NOT MODIFY BY HAND
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
  settingScreenLanguage(key: 'settingScreen_language'),
  editExpirableItemScreenAdd(key: 'editExpirableItemScreen_add'),
  editExpirableItemScreenName(key: 'editExpirableItemScreen_name'),
  editExpirableItemScreenInputPlaceHolder(key: 'editExpirableItemScreen_input_placeHolder'),
  ;

  const AppString({ required this.key });
  final String key;

  String getL10n(BuildContext context, [List<String>? args]) {
    return AppLocalizations.of(context).translate(key, args);
  }
}
