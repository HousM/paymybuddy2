// SFD §10 — Charte "Soirée de tirage"

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const nuit = Color(0xFF0D1130);
  static const scene = Color(0xFF191E45);
  static const scene2 = Color(0xFF232A5C);
  static const or = Color(0xFFFFC64B);
  static const bleu = Color(0xFF4D7CFE);
  static const rouge = Color(0xFFFF5A64);
  static const craie = Color(0xFFF2F3FA);
  static const muted = Color(0xFF8A91C0);
}

class AppRadius {
  static const chip = 12.0;
  static const card = 14.0;
  static const hero = 20.0;
}

TextTheme _buildTextTheme() {
  final display = GoogleFonts.bricolageGrotesqueTextTheme();
  final body = GoogleFonts.outfitTextTheme();
  return TextTheme(
    displayLarge: display.displayLarge?.copyWith(color: AppColors.craie, fontWeight: FontWeight.w800),
    displayMedium: display.displayMedium?.copyWith(color: AppColors.craie, fontWeight: FontWeight.w800),
    headlineLarge: display.headlineLarge?.copyWith(color: AppColors.craie, fontWeight: FontWeight.w800),
    headlineMedium: display.headlineMedium?.copyWith(color: AppColors.craie, fontWeight: FontWeight.w800),
    titleLarge: display.titleLarge?.copyWith(color: AppColors.craie, fontWeight: FontWeight.w800, letterSpacing: 0.2),
    titleMedium: display.titleMedium?.copyWith(color: AppColors.craie, fontWeight: FontWeight.w700),
    bodyLarge: body.bodyLarge?.copyWith(color: AppColors.craie),
    bodyMedium: body.bodyMedium?.copyWith(color: AppColors.craie),
    bodySmall: body.bodySmall?.copyWith(color: AppColors.muted),
    labelLarge: body.labelLarge?.copyWith(color: AppColors.craie, fontWeight: FontWeight.w600),
  );
}

ThemeData buildAppTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.nuit,
    colorScheme: base.colorScheme.copyWith(
      primary: AppColors.bleu,
      secondary: AppColors.or,
      surface: AppColors.scene,
      onPrimary: Colors.white,
      onSecondary: const Color(0xFF3A2400),
      onSurface: AppColors.craie,
      error: AppColors.rouge,
    ),
    textTheme: _buildTextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.nuit,
      foregroundColor: AppColors.craie,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardTheme(
      color: AppColors.scene,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
      elevation: 0,
      margin: EdgeInsets.zero,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.nuit,
      selectedItemColor: AppColors.or,
      unselectedItemColor: AppColors.muted,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),
  );
}
