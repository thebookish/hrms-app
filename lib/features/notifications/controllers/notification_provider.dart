import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/services/notification_service.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/notifications/model/notification_model.dart';

final notificationsProvider = FutureProvider<List<NotificationItem>>((ref) async {
  final user = ref.watch(loggedInUserProvider);
  return NotificationService().fetchRawNotifications(user!.email);
});
