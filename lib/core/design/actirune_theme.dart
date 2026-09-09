import 'package:flutter/material.dart';

abstract final class ActiRuneColors {
  static const navy950 = Color(0xFF03101F);
  static const navy900 = Color(0xFF061729);
  static const navy800 = Color(0xFF0A2138);
  static const cyan = Color(0xFF20CFFF);
  static const cyanStrong = Color(0xFF009BFF);
  static const gold = Color(0xFFFFC857);
  static const goldDeep = Color(0xFFD99720);
  static const surface = Color(0xE60A1C30);
  static const textPrimary = Color(0xFFF5F8FC);
  static const textSecondary = Color(0xFFB8C5D3);
  static const success = Color(0xFF4DDC93);
  static const danger = Color(0xFFFF6A68);
}

ThemeData buildActiRuneTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: ActiRuneColors.cyan,
    brightness: Brightness.dark,
    surface: ActiRuneColors.navy900,
  );
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: scheme,
    scaffoldBackgroundColor: ActiRuneColors.navy950,
    useMaterial3: true,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w800,
        color: ActiRuneColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontWeight: FontWeight.w800,
        color: ActiRuneColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontWeight: FontWeight.w700,
        color: ActiRuneColors.textPrimary,
      ),
      bodyLarge: TextStyle(color: ActiRuneColors.textPrimary),
      bodyMedium: TextStyle(color: ActiRuneColors.textSecondary),
    ),
  );
}
