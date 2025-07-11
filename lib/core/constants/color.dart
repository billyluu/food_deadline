import 'package:flutter/material.dart';

const myColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2E7D32),
  // 深綠色主要顏色，健康、自然的感覺
  onPrimary: Colors.white,
  // 主要顏色上的文字顏色
  secondary: Color(0xFF66BB6A),
  // 淺綠色次要顏色，溫和的強調色
  onSecondary: Colors.white,
  // 次要顏色上的文字
  tertiary: Color(0xFFE8F5E8),
  // 淡綠色第三顏色，用於卡片背景
  onTertiary: Color(0xFF2E7D32),
  // 第三顏色上的文字
  error: Color(0xFFD32F2F),
  // 錯誤顏色，過期的食物
  onError: Colors.white,
  // 錯誤顏色上的文字顏色
  surface: Color(0xFFFAFAFA),
  // 表面顏色（例如卡片、Dialog 背景）
  onSurface: Color(0xFF212121),
  // 表面上的文字顏色
  background: Colors.white,
  // 背景顏色
  onBackground: Color(0xFF212121),
  // 背景上的文字顏色
);

const myDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF66BB6A),
  // 深色模式下的淺綠色主要顏色
  onPrimary: Colors.black,
  // 主要顏色上的文字顏色
  secondary: Color(0xFF4CAF50),
  // 標準綠色次要顏色
  onSecondary: Colors.black,
  // 次要顏色上的文字
  tertiary: Color(0xFF1B5E20),
  // 深綠色第三顏色，用於卡片背景
  onTertiary: Color(0xFF66BB6A),
  // 第三顏色上的文字
  error: Color(0xFFEF5350),
  // 深色模式錯誤顏色
  onError: Colors.white,
  // 錯誤顏色上的文字顏色
  surface: Color(0xFF121212),
  // 深色表面顏色
  onSurface: Color(0xFFE0E0E0),
  // 表面上的文字顏色
  background: Colors.black,
  // 深色背景顏色
  onBackground: Color(0xFFE0E0E0),
  // 背景上的文字顏色
);
