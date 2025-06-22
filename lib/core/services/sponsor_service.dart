import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hrms_app/core/constants/api_endpoints.dart';
import 'package:hrms_app/features/sponsor/model/sponsor_model.dart';

class SponsorService {
  final String baseUrl = ApiEndpoints.baseUrl;

  /// Add a new sponsor
  Future<void> addSponsor(SponsorModel sponsor) async {
    final url = Uri.parse('$baseUrl/sponsors/add-sponsor');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sponsor.toJson()),
    );

    if (response.statusCode != 201) {
      print('resp: '+response.statusCode.toString());
      throw Exception('Failed to add sponsor');
    }
  }

  /// Fetch sponsor by email
  Future<SponsorModel> fetchSponsor(String email) async {
    final url = Uri.parse('$baseUrl/sponsors/?email=$email');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return SponsorModel.fromJson(json);
    } else {
      throw Exception('Failed to fetch sponsor: ${response.body}');
    }
  }

  /// Update sponsor info by email
  Future<void> updateSponsor(String email, SponsorModel sponsor) async {
    final url = Uri.parse('$baseUrl/sponsors/$email');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(sponsor.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sponsor: ${response.body}');
    }
  }
}
