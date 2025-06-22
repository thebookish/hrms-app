import 'dart:convert';
import 'package:hrms_app/core/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:hrms_app/features/notifications/model/notification_model.dart';

class NotificationService {
  // final String fcmServerKey = 'YOUR_FCM_SERVER_KEY';
  //
  // Future<void> sendPushNotification({
  //   required String title,
  //   required String message,
  //   required String fcmToken,
  // }) async {
  //   const fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  //
  //   final body = {
  //     'to': fcmToken,
  //     'notification': {
  //       'title': title,
  //       'body': message,
  //     },
  //     'priority': 'high',
  //   };
  //
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'key=$fcmServerKey',
  //   };
  //
  //   final response = await http.post(
  //     Uri.parse(fcmUrl),
  //     headers: headers,
  //     body: jsonEncode(body),
  //   );
  //
  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to send FCM push: ${response.body}');
  //   }
  // }
  Future<List<NotificationItem>> fetchNotifications() async {
    final response = await http.get(Uri.parse('${ApiEndpoints.baseUrl}/notifications'));

    if (response.statusCode == 200) {
      final List decoded = jsonDecode(response.body);
      return decoded.map((e) => NotificationItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
  /// Fetch notifications for current user
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

  /// Send a new notification (HR use case)
  Future<void> sendNotification({
    required String title,
    required String message,
    required String receiverEmail,
  }) async {
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
      throw Exception('Failed to send notification');
    }
  }

  /// Mark all as read
  Future<void> markAllAsRead(String email) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/notifications/mark-all-read?email=$email');
    final response = await http.put(url);
   print("response: "+response.statusCode.toString());
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notifications as read');
    }
  }
}
