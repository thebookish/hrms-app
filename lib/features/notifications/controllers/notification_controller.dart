import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hrms_app/core/constants/api_endpoints.dart';

class FirebaseNotificationController {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Initializes Firebase Messaging and listens for foreground messages.
  static Future<void> initialize(String email) async {
    await _messaging.requestPermission();

    final token = await _messaging.getToken();
    print("FCM Token: $token");

    if (token != null) {
      await _saveTokenToServer(token, email);
    }
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
            channelKey: 'basic_channel',
            title: message.notification!.title,
            body: message.notification!.body,
          ),
        );
      }
    });

  }

  /// Sends the FCM token to the backend using the logged-in user's email.
  static Future<void> _saveTokenToServer(String token, String email) async {

    try {
      final response = await http.put(
        Uri.parse('${ApiEndpoints.baseUrl}/users/update-fcm-token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'fcmToken': token}),
      );

      if (response.statusCode != 200) {
        print("Failed to save FCM token: ${response.body}");
      }
    } catch (e) {
      print("Error saving FCM token: $e");
    }
  }
}
