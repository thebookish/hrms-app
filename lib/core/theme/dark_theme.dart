import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF121212),
  canvasColor: const Color(0xFF121212), // dark background for material surfaces
  cardColor: const Color(0xFF1E1E1E),
  primarySwatch: Colors.indigo,
  primaryColor: AppColors.primary,
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1F1F1F),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    bodySmall: TextStyle(fontSize: 12, color: Colors.white54),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF1E1E1E),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white60),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF1F1F1F),
    selectedItemColor: Colors.indigo,
    unselectedItemColor: Colors.grey,
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  dialogBackgroundColor: const Color(0xFF1E1E1E),
);
