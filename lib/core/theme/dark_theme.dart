import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0D1117), // Dark base
  canvasColor: const Color(0xFF0E1D36), // BrandColor on material elements
  cardColor: const Color(0xFF1C1C2E), // Slightly lighter card for depth
  primaryColor: AppColors.brandColor,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.brandColor,
    secondary: Colors.tealAccent,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.brandColor,
    foregroundColor: Colors.white,
    elevation: 1,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
    titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white70),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    bodySmall: TextStyle(fontSize: 12, color: Colors.white54),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1F2A40),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white54),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.brandColor),
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.brandColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF0E1D36),
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    selectedIconTheme: IconThemeData(color: Colors.white),
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  dialogBackgroundColor: const Color(0xFF1E1E2E),
  dividerColor: Colors.white12,
);
