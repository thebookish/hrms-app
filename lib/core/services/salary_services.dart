import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hrms_app/core/constants/api_endpoints.dart';

class SalaryService {
  final baseUrl = ApiEndpoints.baseUrl;

  /// Add or update salary info for an employee
  Future<void> addSalaryInfo(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/salary-info/add-salary');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Failed to add salary info: ${response.body}');
    }
  }

  /// Fetch salary info for a specific employee by email
  Future<Map<String, dynamic>> getSalaryInfo(String email) async {
    final url = Uri.parse('$baseUrl/salary-info/get-salary?email=$email');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch salary info');
    }
  }

  /// Delete salary info for an employee (optional)
  Future<void> deleteSalaryInfo(String email) async {
    final url = Uri.parse('$baseUrl/salary-info/delete-salary?email=$email');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to delete salary info');
    }
  }
}
