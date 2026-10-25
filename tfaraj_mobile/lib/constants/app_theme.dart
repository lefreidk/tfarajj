import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF09090D);
  static const Color accentColor = Color(0xFF4ECDC4);
  static const Color textColor = Colors.white;
  static const Color subtitleColor = Colors.white70;

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: primaryColor,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.dark,
      surface: primaryColor,
    ),
    fontFamily: 'Tajawal',
  );
}
