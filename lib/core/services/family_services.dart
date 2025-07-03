// core/services/family_service.dart

import 'dart:convert';
import 'package:hrms_app/core/models/family_members_model.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/core/constants/api_endpoints.dart';

class FamilyService {
  final String baseUrl = ApiEndpoints.baseUrl;

  Future<List<FamilyMember>> getFamilyMembers(String email) async {
    final response = await http.get(Uri.parse('$baseUrl/family/get?email=$email'));
    if (response.statusCode == 200) {
      print(response.body);
      final List data = jsonDecode(response.body);
      return data.map((e) => FamilyMember.fromJson(e)).toList();

    } else {
      print(response.statusCode.toString());
      throw Exception('Failed to fetch family members');
    }
  }

  Future<void> addFamilyMember(FamilyMember member) async {
    final response = await http.post(
      Uri.parse('$baseUrl/family/add'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(member.toJson()),
    );
    if (response.statusCode != 201) {
      print(response.statusCode.toString());
      throw Exception('Failed to add family member');
    }
  }

  Future<void> deleteFamilyMember(String email) async {
    final response = await http.delete(Uri.parse('$baseUrl/family/delete/$email'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete family member');
    }
  }
}
