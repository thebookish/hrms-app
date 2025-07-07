import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/auth_service.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String name;
  final String email;
  final String password;

  const VerifyOtpScreen({
    super.key,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  bool _isVerifying = false;

  Future<void> _verifyOtpAndSignup() async {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter 6-digit OTP")));
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final success = await AuthService().verifyOtp(
        email: widget.email,
        otp: _otpController.text.trim(),
      );

      if (!success) throw 'OTP verification failed';

      // ✅ Call signup only after successful verification
      final user = await AuthService().signup(
        name: widget.name,
        email: widget.email,
        password: widget.password,
      );

      if (user != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        Navigator.popUntil(context, (route) => route.isFirst); // Go to login
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something Went Wrong!')));
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: AppColors.brandColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Enter the 6-digit OTP sent to your email."),
            const SizedBox(height: 12),
            TextField(
              controller: _otpController,
              maxLength: 6,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'OTP',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.verified),
              onPressed: _isVerifying ? null : _verifyOtpAndSignup,
              label: Text(_isVerifying ? 'Verifying...' : 'Verify & Register'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandColor,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
