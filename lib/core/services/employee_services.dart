import 'dart:convert';
import 'dart:io';
import 'package:hrms_app/core/models/employee_model_new.dart';
import 'package:hrms_app/core/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<EmployeeModelNew> getEmployeeDataByEmail(String email) async {

    final token = await AuthService().getToken();
    final response = await http.get(

      Uri.parse('${ApiEndpoints.baseUrl}/employees/emp-data/?email=$email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },

    );
    if (response.statusCode == 200) {
      return EmployeeModelNew.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("User not found");
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
  Future<void> uploadProfilePic(File imageFile, String token, {required String email}) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('${ApiEndpoints.baseUrl}/users/update-profile-pic?email=$email'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files.add(await http.MultipartFile.fromPath('profilePic', imageFile.path));

    var response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to upload profile picture');
    }
  }

  Future<void> approveEmployee(String email) async {
    // print("emaiilll: "+email);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.put(
      Uri.parse('${ApiEndpoints.baseUrl}/employees/verify/?email=$email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      print("status: ${response.statusCode}");
      throw Exception('Failed to approve employee');
    }
  }

  Future<void> declineEmployee(String email) async {
    // print("emaiilll: "+email);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.put(
      Uri.parse('${ApiEndpoints.baseUrl}/employees/decline/?email=$email'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      print("status: ${response.statusCode}");
      throw Exception('Failed to approve employee');
    }
  }

  Future<void> updateEmployee(EmployeeModelNew employee) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.put(
      Uri.parse('${ApiEndpoints.baseUrl}/employees/edit/?email=${employee.email}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(employee.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update employee');
    }
  }


}
