import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

Future<void> loadSavedThemeMode(ProviderContainer container) async {
  final prefs = await SharedPreferences.getInstance();
  final isLight = prefs.getBool('isLightTheme') ?? true;
  container.read(themeModeProvider.notifier).state =
  isLight ? ThemeMode.light : ThemeMode.dark;
}

Future<void> saveThemeMode(ThemeMode mode) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLightTheme', mode == ThemeMode.light);
}
