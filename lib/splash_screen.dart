import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/models/user_model.dart';
import 'package:hrms_app/core/services/auth_service.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/auth/screens/login_screen.dart';
import 'package:hrms_app/features/dashboard/screens/admin_dashboard.dart';
import 'package:hrms_app/features/dashboard/screens/employee_dashboard.dart';

import 'core/constants/app_colors.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoggedIn();
  }

  Future<void> _checkLoggedIn() async {
    final authService = AuthService();
    UserModel? user = await authService.getLoggedInUser();
   // print("userrrr: "+ user!.role.toLowerCase());
    if (user != null) {
      ref.read(loggedInUserProvider.notifier).state = user;

      if (user.role.toLowerCase() == 'admin') {
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
          }
        });

      } else {
        Timer(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EmployeeDashboard()));
          }
        });
      }
    } else {
      // Wait for 3 seconds then navigate to LoginScreen
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or animation
            Icon(Icons.verified_user, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              "HRMS App",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            )
          ],
        ),
      ),
    );
  }
}
