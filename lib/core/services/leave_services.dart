import 'dart:convert';
import 'package:hrms_app/core/constants/api_endpoints.dart';
import 'package:hrms_app/features/leave_management/models/leave_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LeaveService {
  Future<List<LeaveModel>> fetchLeaves( {required String email}) async {
    print('statttttus:  ');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('${ApiEndpoints.baseUrl}/leaves/my-leaves?email=$email'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
print('statttttus:  '+response.statusCode.toString());
    if (response.statusCode == 200) {
      final List decoded = json.decode(response.body);
      return decoded.map((e) => LeaveModel.fromJson(e)).toList();
    } else {
      print('statttttus:  '+response.statusCode.toString());
      throw Exception('Failed to fetch leaves');
    }
  }

  Future<void> applyLeave(String email, Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/leaves/request'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({...data, 'email': email}),
    );

    if (response.statusCode != 201) {
      print('statussss: '+response.statusCode.toString());
      throw Exception('Leave application failed');
    }
  }
}
