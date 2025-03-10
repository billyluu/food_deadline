import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/enums/app_locale.dart';
import 'package:food_deadline/core/constants/enums/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  // 定義鍵名
  static const String _themeModeKey = 'theme_mode';            // 主題模式
  static const String _notificationsEnabledKey = 'notifications_enabled'; // 通知開關
  static const String _localeKey = 'locale';                   // 語系

  // 主題模式：設置 'light' 或 'dark'
  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
  }

  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final appThemeMode = ThemeMode.values.firstWhere((element) {
      return element.name == (prefs.getString(_themeModeKey) ?? ThemeMode.system.name);
    });
    return appThemeMode; // 預設為亮色模式
  }

  // 通知開關：設置 true 或 false
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_notificationsEnabledKey) ?? true; // 預設為開啟
  }

  // 語系：設置語言代碼，例如 'en'、'zh'
  static Future<void> setLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale);
  }

  static Future<AppLocale> getLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final appLocale = AppLocale.values.where((element) {
      return element.name == (prefs.getString(_localeKey) ?? AppLocale.zh_TW.name);
    }).firstOrNull ?? AppLocale.zh_TW;
    return appLocale;
  }
}