import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/auth_service.dart';
import 'package:hrms_app/features/auth/screens/login_screen.dart';
import 'package:hrms_app/features/settings/screens/change_pass_screen.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.brandColor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('App Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ListTile(
            title: const Text('Light Mode'),
            trailing: Switch(
              value: themeMode == ThemeMode.light,
              onChanged: (val) async {
                final newMode = val ? ThemeMode.light : ThemeMode.dark;
                ref.read(themeModeProvider.notifier).state = newMode;
                await saveThemeMode(newMode); // Persist user selection
              },
            ),
          ),
          const Divider(height: 32),
          const Text('Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout'),
            onTap: () async {
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
