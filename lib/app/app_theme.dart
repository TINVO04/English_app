import 'package:flutter/material.dart';

import '../core/config/constants/services/colors.dart'; // đúng vị trí AppColors  :contentReference[oaicite:9]{index=9}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
      scaffoldBackgroundColor: AppColors.scaffold,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.text,
        elevation: 0,
        centerTitle: true,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.border),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          minimumSize: const Size.fromHeight(44),
        ),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w700, color: AppColors.text),
        titleMedium: TextStyle(fontWeight: FontWeight.w700, color: AppColors.text),
        bodyMedium: TextStyle(color: AppColors.text),
        bodySmall: TextStyle(color: AppColors.textMuted),
      ),
    );
    return base;
  }
}
