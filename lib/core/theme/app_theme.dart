import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: Colors.white, // Pure white as per Figma
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.googleBlue,
        tertiary: AppColors.success,
        surface: Colors.white,
        error: AppColors.error,
        onSurface: AppColors.textPrimary,
        onPrimary: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600, // Reduced from 700
          fontSize: 32,
          letterSpacing: -0.5,
        ),
        displayMedium: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
          fontSize: 28,
          letterSpacing: -0.5,
        ),
        headlineLarge: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500, // Reduced from 600
          fontSize: 24,
        ),
        headlineMedium: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 20,
          letterSpacing: -0.2,
        ),
        titleLarge: const TextStyle(
          // Section Headers
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
        titleMedium: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        bodyLarge: const TextStyle(
          // Main Body
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w400, // Regular weight
          fontSize: 16,
        ),
        bodyMedium: const TextStyle(
          // Secondary Text
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: 0.1,
        ),
        bodySmall: const TextStyle(
          // Small labels / captions
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          letterSpacing: 0.2,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.divider, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Slightly tighter radius
        ),
        color: Colors.white, // Card background typically white
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}
