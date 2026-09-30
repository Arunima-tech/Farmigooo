import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const mossGreen = Color(0xFF3F6B4F);
  static const mossGreenDark = Color(0xFF2C4D38);
  static const harvestGold = Color(0xFFD9A441);
  static const linen = Color(0xFFFAF6EE);
  static const cardSurface = Color(0xFFFFFDF8);
  static const soilText = Color(0xFF2A2620);
  static const soilTextMuted = Color(0xFF6B6355);
  static const rust = Color(0xFFB3492F);

  // Per-module accent colors, used for icons/tags
  static const landAccent = Color(0xFF3F6B4F); // moss green
  static const machineryAccent = Color(0xFFB3492F); // rust
  static const workerAccent = Color(0xFFD9A441); // harvest gold
}

class AppTheme {
  static ThemeData get theme {
    final base = ThemeData(
      useMaterial3: true,
      splashFactory: InkRipple.splashFactory,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.mossGreen,
        primary: AppColors.mossGreen,
        secondary: AppColors.harvestGold,
        surface: AppColors.cardSurface,
        error: AppColors.rust,
      ),
      scaffoldBackgroundColor: AppColors.linen,
    );

    final headingFont = GoogleFonts.fraunces();
    final bodyFont = GoogleFonts.workSans();

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineMedium: headingFont.copyWith(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: AppColors.soilText,
        ),
        titleLarge: headingFont.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.soilText,
        ),
        titleMedium: bodyFont.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.soilText,
        ),
        bodyLarge: bodyFont.copyWith(fontSize: 15, color: AppColors.soilText),
        bodyMedium: bodyFont.copyWith(fontSize: 14, color: AppColors.soilTextMuted),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.linen,
        foregroundColor: AppColors.soilText,
        elevation: 0,
        titleTextStyle: headingFont.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.soilText,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardSurface,
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColors.mossGreen.withValues(alpha: 0.08)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.mossGreen.withValues(alpha: 0.15)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mossGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: bodyFont.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
