import 'package:flutter/material.dart';

enum AppLocale {
  enUs(languageCode: 'en', countryCode: 'US'),
  zhTW(languageCode: 'zh', countryCode: 'TW'),
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
