// core/services/task_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hrms_app/core/constants/api_endpoints.dart';
import 'package:hrms_app/features/job_info/model/task_model.dart';

class TaskService {

  Future<void> createTask(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('${ApiEndpoints.baseUrl}/tasks/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    print("ressssp:  "+response.statusCode.toString());
    if (response.statusCode != 201) {
      throw Exception('Failed to create task: ${response.body}');
    }
  }
  Future<List<TaskModel>> getUserTasks(String email) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}/tasks/user-tasks?email=$email');
    final resp = await http.get(uri);
    if (resp.statusCode == 200) {
      final List data = jsonDecode(resp.body);
      return data.map((e) => TaskModel.fromJson(e)).toList();
    }
    throw Exception('Failed to load tasks');
  }

  Future<void> toggleTaskCompletion(String id, String email) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}/tasks/toggle-completion');
    final resp = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'email': email}));
    if (resp.statusCode != 200) throw Exception('Toggle completion failed');
  }

  Future<void> updateTaskStatus(String id, String email, String status) async {
    final uri = Uri.parse('${ApiEndpoints.baseUrl}/tasks/update-status');
    final resp = await http.put(uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id': id, 'email': email, 'status': status}));
    if (resp.statusCode != 200) throw Exception('Update status failed');
  }
}
