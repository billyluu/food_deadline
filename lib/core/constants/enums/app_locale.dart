import 'package:flutter/material.dart';
import 'package:food_deadline/core/constants/app_string.s.dart';

enum AppLocale {
  enUs(
    languageCode: 'en',
    countryCode: 'US',
    appString: AppString.localeEnUs,
  ),
  zhTW(
    languageCode: 'zh',
    countryCode: 'TW',
    appString: AppString.localeZhTW,
  ),
  ;

  const AppLocale({
    required this.languageCode,
    required this.countryCode,
    required this.appString,
  });

  final String languageCode;
  final String countryCode;
  final AppString appString;

  Locale getLocale() {
    return Locale(languageCode, countryCode);
  }
}
