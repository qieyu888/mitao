import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.cream50,
      colorScheme: const ColorScheme.light(
        primary: AppColors.peach500,
        secondary: AppColors.peach400,
        surface: AppColors.cream50,
        onPrimary: Colors.white,
        onSurface: AppColors.mocha700,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.cream50,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: AppColors.peach500,
          letterSpacing: 0.5,
        ),
        titleLarge: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
          color: AppColors.mocha800,
        ),
        titleMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.mocha800,
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.mocha700,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontSize: 13,
          color: AppColors.mocha500,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColors.mocha400,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintStyle: const TextStyle(
          color: AppColors.mocha400,
          fontSize: 14,
        ),
      ),
    );
  }
}

/// 粉色调弥散阴影
class KawaiiShadow {
  KawaiiShadow._();

  static List<BoxShadow> get sm => [
        BoxShadow(
          color: AppColors.peach500.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> get md => [
        BoxShadow(
          color: AppColors.peach500.withValues(alpha: 0.12),
          blurRadius: 28,
          offset: const Offset(0, 12),
        ),
      ];
}
