import 'package:flutter/material.dart';

enum AppLocale {
  en_US(languageCode: 'en', countryCode: 'US'),
  zh_TW(languageCode: 'zh', countryCode: 'TW'),
  ;

  const AppLocale({
    required this.languageCode,
    required this.countryCode,
  });

  final String languageCode;
  final String countryCode;

  Locale getLocale() {
    return Locale(languageCode, countryCode);
  }
}
