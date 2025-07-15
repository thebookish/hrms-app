import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/theme/dark_theme.dart';
import 'package:hrms_app/core/theme/light_theme.dart';
import 'package:hrms_app/features/settings/providers/theme_provider.dart';
import 'package:hrms_app/splash_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDrVAQxb3I9MrGMGt2CMwwW1iajnSK8f6Y",
      appId: "1:753255455615:android:aeb4ab75e8544f3bdc184a",
      messagingSenderId: "753255455615",
      projectId: "hrms-eaea9",
      storageBucket: "hrms-eaea9.firebasestorage.app",
    ),
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Colors.teal,
        ledColor: Colors.white,
      ),
    ],
    debug: true,
  );
  final container = ProviderContainer();

  // ✅ Pass container as ref to the controller


  await loadSavedThemeMode(container);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const HRMSApp(),
    ),
  );
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
      themeMode: themeMode,
      theme: lightTheme,
      darkTheme: darkTheme,
      // Set the initial screen here (Login for now)
      home: SplashScreen(),
    );
  }
}
