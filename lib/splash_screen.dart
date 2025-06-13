import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/models/user_model.dart';
import 'package:hrms_app/core/services/auth_service.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/auth/screens/login_screen.dart';
import 'package:hrms_app/features/dashboard/screens/admin_dashboard.dart';
import 'package:hrms_app/features/dashboard/screens/employee_dashboard.dart';

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

    if (user != null) {
      ref.read(loggedInUserProvider.notifier).state = user;

      if (user.role.toLowerCase() == 'admin') {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminDashboard()));
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => EmployeeDashboard()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
