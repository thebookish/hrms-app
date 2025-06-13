import 'package:flutter/material.dart';

class AppColors {
  static const Color brandColor = Color(0xFF0E1D36);
  static const primary = Colors.indigo;
  static const secondary = Colors.deepPurple;
  static const accent = Colors.amber;
  static const background = Color(0xFFF5F5F5);
  static const white = Colors.white;
  static const grey = Colors.grey;
  static const textDark = Color(0xFF333333);
  static const error = Colors.redAccent;


  static const MaterialColor brandBase = MaterialColor(
    0xFF0E1D36,
    <int, Color>{
      50: Color(0xFFE3F2FD),
      100: Color(0xFFBBDEFB),
      200: Color(0xFF90CAF9),
      300: Color(0xFF64B5F6),
      400: Color(0xFF42A5F5),
      500: Color(0xFF2196F3),
      600: Color(0xFF1E88E5),
      700: Color(0xFF1976D2),
      800: Color(0xFF1565C0),
      900: Color(0xFF0D47A1),
    },
  );
}
