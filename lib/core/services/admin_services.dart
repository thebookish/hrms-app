import 'dart:convert';
import 'package:hrms_app/core/constants/api_endpoints.dart';
import 'package:hrms_app/core/models/employee_model_new.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/employee_model.dart';
import '../models/salary_model.dart';

class AdminService {
  Future<List<EmployeeModel>> getEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}/employees/approved'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => EmployeeModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }
  Future<List<EmployeeModelNew>> getPendingEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}/employees/pending'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => EmployeeModelNew.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }
  Future<List<EmployeeModelNew>> getApprovedEmployees() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}/employees/approved'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.map((e) => EmployeeModelNew.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }
  // Future<List<SalaryPoint>> getSalaryStats() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final token = prefs.getString('auth_token');
  //
  //   final response = await http.get(
  //     Uri.parse('${ApiEndpoints.baseUrl}/admin/salary-statistics'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final List data = json.decode(response.body);
  //     return data.map((e) => SalaryPoint.fromJson(e)).toList();
  //   } else {
  //     throw Exception('Failed to load salary statistics');
  //   }
  // }
}
