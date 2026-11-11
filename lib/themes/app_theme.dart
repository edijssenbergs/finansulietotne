import 'package:flutter/material.dart';

// Krāsas no Figma dizaina
class AppColors {
  static const primary = Color(0xFF1F3864);
  static const accent = Color(0xFF4AA1E8);
  static const background = Color(0xFFFFFFFF);
  static const surface = Color(0xFFF2F2F2);
  static const border = Color(0xFFE5E7EB);
  static const textMain = Color(0xFF1A1A1A);
  static const textSecondary = Color(0xFF6B7280);
  static const success = Color(0xFF2E7D32);
  static const warning = Color(0xFFC77700);
  static const error = Color(0xFFC62828);
}

// Atstarpes (8 px bāzes solis)
class AppSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 16;
  static const double l = 24;
  static const double xl = 32;
  static const double xxl = 48;
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        // H1: ekrānu virsraksti
        headlineMedium: const TextStyle(
          fontSize: 24,
          height: 32 / 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textMain,
        ),
        // H2: sadaļu virsraksti
        titleLarge: const TextStyle(
          fontSize: 20,
          height: 28 / 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textMain,
        ),
        // Pamatteksts
        bodyLarge: const TextStyle(
          fontSize: 16,
          height: 24 / 16,
          color: AppColors.textMain,
        ),
        // Palīgteksts
        bodySmall: const TextStyle(
          fontSize: 13,
          height: 18 / 13,
          color: AppColors.textSecondary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}