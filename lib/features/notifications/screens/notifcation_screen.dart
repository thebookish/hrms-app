import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/services/notification_service.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/notifications/controllers/notification_provider.dart';
import 'package:hrms_app/features/settings/providers/theme_provider.dart';
import 'package:intl/intl.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/notifications/model/notification_model.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  bool pushEnabled = true;
  String filter = 'All';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loggedInUserProvider);
    final notificationsAsync = ref.watch(notificationsProvider);
    final themeMode = ref.watch(themeModeProvider); // ✅ Make reactive

    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      body: Column(
        children: [
          _buildTabBar(isDark),
          Expanded(
            child: notificationsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Something Went Wrong!')),
              data: (notifications) {
                final filtered = filter == 'All'
                    ? notifications
                    : notifications
                    .where((n) => filter == 'Unread' ? !n.isRead : n.isRead)
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No notifications.'));
                }

                return ListView.builder(
                  itemCount: filtered.length,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  itemBuilder: (_, index) =>
                      _buildNotificationCard(filtered[index], isDark),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () async {
              if (user == null) return;

              await NotificationService().markAllAsRead(user.email);
              ref.invalidate(notificationsProvider);
            },

            style: TextButton.styleFrom(
              foregroundColor: isDark ? Colors.white : AppColors.brandColor,
              side: BorderSide(
                  color: isDark ? Colors.white : AppColors.brandColor),
              padding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Mark all read"),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    final tabs = ['All', 'Unread', 'Read'];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: tabs.map((tab) {
          final selected = filter == tab;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => filter = tab),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected
                      ? (isDark ? Colors.white12 : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  tab,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? (isDark ? Colors.white : Colors.black)
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item, bool isDark) {
    return Card(
      color: isDark ? Colors.white12 : AppColors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: AppColors.brandColor.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.circle,
                size: 10,
                color: item.isRead ? Colors.transparent : Colors.blue),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white : Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.yMMMd().add_jm().format(item.date),
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
