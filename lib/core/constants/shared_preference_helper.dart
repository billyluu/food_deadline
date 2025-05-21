import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/enums/app_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static const String _themeModeKey = 'theme_mode';
  static const String _notificationsEnabledKey = 'notifications_enabled';
  static const String _localeKey = 'locale';

  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final appThemeMode = ThemeMode.values.firstWhere((element) {
      return element.name == (prefs.getString(_themeModeKey) ?? ThemeMode.system.name);
    });
    return appThemeMode;
  }

  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  static Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale);
  }

  static Future<AppLocale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final appLocale = AppLocale.values.where((element) {
          return element.name == (prefs.getString(_localeKey) ?? AppLocale.zhTW.name);
        }).firstOrNull ??
        AppLocale.zhTW;
    return appLocale;
  }
}
