import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/constants/api_endpoints.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();


  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  Future<void> saveChannelList(List<String> channels) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('channels', channels);
  }
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  Future<List<String>> getChannels() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('channels') ?? [];
  }
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  Future<UserModel?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(ApiEndpoints.login),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      await saveToken(token); // ✅ Save the token

      return UserModel.fromJson(data['user']);
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
  Future<UserModel?> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': 'employee', // hardcoded role
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data['user']);
    } else {
      throw Exception('Signup failed: ${response.body}');
    }
  }
  Future<void> sendResetOtp(String email) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to send OTP');
    }
  }

  Future<void> resetPasswordWithOtp({
    required String email,
    required String otp,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to reset password');
    }
  }

  Future<UserModel?> getLoggedInUser() async {
    final email = await _storage.read(key: 'userEmail');
    final role = await _storage.read(key: 'userRole');
    final name = await _storage.read(key: 'userName');

    if (email != null && role != null && name != null) {
      return UserModel(email: email, role: role, name: name, id: '');
    }
    return null;
  }
}


