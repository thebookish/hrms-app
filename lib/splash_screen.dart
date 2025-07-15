import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/models/user_model.dart';
import 'package:hrms_app/core/services/auth_service.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/auth/screens/login_screen.dart';
import 'package:hrms_app/features/dashboard/screens/admin_dashboard.dart';
import 'package:hrms_app/features/dashboard/screens/employee_dashboard.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _startFlow();
  }

  Future<void> _startFlow() async {
    final authService = AuthService();
    UserModel? user = await authService.getLoggedInUser();

    if (user != null) {
      // Try biometric auth
      bool verified = false;
      try {
        final canCheck = await _localAuth.canCheckBiometrics;
        final isDeviceSupported = await _localAuth.isDeviceSupported();
        if (canCheck || isDeviceSupported) {
          verified = await _localAuth.authenticate(
            localizedReason: 'Unlock to continue',
            options: const AuthenticationOptions(
              biometricOnly: false,
              stickyAuth: true,
              useErrorDialogs: true,
            ),
          );
        } else {
          verified = true; // no biometrics available
        }
      } catch (e) {
        verified = true; // fallback if something fails
      }

      if (!verified) {
        // If user cancels or fails, exit app or stay on splash
        return;
      }

      ref.read(loggedInUserProvider.notifier).state = user;
      Timer(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => user.role.toLowerCase() == 'admin'
                  ? AdminDashboard()
                  : const EmployeeDashboard(),
            ),
          );
        }
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.brandColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified_user, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "HRMS App",
              style: TextStyle(
                  fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 12),
            CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          ],
        ),
      ),
    );
  }
}
