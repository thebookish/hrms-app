import 'dart:convert';
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
    // 1. Send to in-app backend
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

    // // 2. Get OneSignal Player ID of receiver from backend
    // final playerIdRes = await http.get(Uri.parse('${ApiEndpoints.baseUrl}/users/player-id?email=$receiverEmail'));
    //
    // if (playerIdRes.statusCode == 200) {
    //   final playerId = jsonDecode(playerIdRes.body)['playerId'];
    //   if (playerId != null) {
    //     await _sendPushNotification(playerId, title, message);
    //   }
    // } else {
    //   print('Failed to fetch player ID: ${playerIdRes.body}');
    // }
  }

  // /// OneSignal Push Notification
  // Future<void> _sendPushNotification(String playerId, String title, String message) async {
  //   final pushUrl = Uri.parse('https://onesignal.com/api/v1/notifications');
  //
  //   final res = await http.post(
  //     pushUrl,
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Basic $_oneSignalRestKey',
  //     },
  //     body: jsonEncode({
  //       'app_id': _oneSignalAppId,
  //       'include_player_ids': [playerId],
  //       'headings': {'en': title},
  //       'contents': {'en': message},
  //     }),
  //   );
  //
  //   if (res.statusCode != 200 && res.statusCode != 201) {
  //     throw Exception('Failed to send push notification: ${res.body}');
  //   }
  // }

  Future<void> markAllAsRead(String email) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}/notifications/mark-all-read?email=$email');
    final response = await http.put(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to mark notifications as read');
    }
  }
}
