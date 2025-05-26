import 'dart:convert';
import 'package:hrms_app/core/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../constants/api_endpoints.dart';
import '../models/employee_model.dart';

class EmployeeService {
  Future<EmployeeModel> getEmployeeByEmail(String email) async {
    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}/users/by-email?email=$email'),
    );

    if (response.statusCode == 200) {
      return EmployeeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load employee data');
    }
  }
  Future<EmployeeModel> updateEmployeeProfile({
    required String email,
    required Map<String, dynamic> updates,
  }) async {
    final token = await AuthService().getToken(); // ✅ Get token from storage

    final response = await http.put(
      Uri.parse('${ApiEndpoints.baseUrl}/users/update-profile?email=$email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // ✅ Attach Bearer token
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return EmployeeModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update profile');

    }
  }

}
