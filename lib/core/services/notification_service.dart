import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/core/constants/api_endpoints.dart';
import 'package:hrms_app/features/notifications/model/notification_model.dart';

class NotificationService {
  // final _oneSignalAppId = 'YOUR_ONESIGNAL_APP_ID';
  // final _oneSignalRestKey = 'YOUR_ONESIGNAL_REST_API_KEY';

  /// In-app notifications
  Future<List<NotificationItem>> fetchNotifications() async {
    final response = await http.get(Uri.parse('${ApiEndpoints.baseUrl}/notifications'));
    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((e) => NotificationItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<List<NotificationItem>> fetchRawNotifications(String email) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/notifications?email=$email');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((e) => NotificationItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch notifications');
    }
  }

  /// HR triggers a notification (also triggers push)
  Future<void> sendNotification({
    required String title,
    required String message,
    required String receiverEmail,
  }) async {
    // 1. Send to backend for in-app storage
    final url = Uri.parse('${ApiEndpoints.baseUrl}/notifications/send');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': title,
        'message': message,
        'email': receiverEmail,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to send in-app notification');
    }


  }

  Future<void> markAllAsRead(String email) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/notifications/mark-all-read?email=$email');
    final response = await http.put(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notifications as read');
    }
  }
}
