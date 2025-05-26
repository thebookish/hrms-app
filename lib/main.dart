import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/theme/dark_theme.dart';
import 'package:hrms_app/core/theme/light_theme.dart';
import 'package:hrms_app/features/settings/providers/theme_provider.dart';
import 'features/auth/screens/login_screen.dart';
// import 'features/dashboard/screens/admin_dashboard.dart';
// import 'features/dashboard/screens/employee_dashboard.dart';

void main() {
  runApp(const ProviderScope(child: HRMSApp()));
}

/// Root of the application using Riverpod for state management
class HRMSApp extends ConsumerWidget {
  const HRMSApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'HRMS App',
      debugShowCheckedModeBanner: false,
      // themeMode: themeMode,
      theme: lightTheme,
      // darkTheme: darkTheme,
      // Set the initial screen here (Login for now)
      home: const LoginScreen(),
    );
  }
}
