
import 'package:flutter/material.dart';

const myColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Colors.green,      // 主要顏色，健康、自然的感覺
  onPrimary: Colors.white,    // 主要顏色上的文字顏色
  secondary: Colors.orange,   // 次要顏色，強調即將過期的提醒
  onSecondary: Colors.white,  // 次要顏色上的文字
  error: Colors.redAccent,    // 錯誤顏色，過期的食物
  onError: Colors.white, // 背景上的文字顏色
  surface: Colors.white,      // 表面顏色（例如卡片、Dialog 背景）
  onSurface: Colors.black,    // 表面上的文字顏色
);


const myDarkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Colors.teal,       // 深色模式下的主要顏色
  onPrimary: Colors.white,
  secondary: Colors.orangeAccent,
  onSecondary: Colors.black,
  error: Colors.red,
  onError: Colors.white,
  surface: Colors.grey,
  onSurface: Colors.white,
);