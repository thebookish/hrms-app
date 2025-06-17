import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool pushEnabled = true;
  int selectedTabIndex = 0;

  final List<NotificationItem> notifications = [
    NotificationItem(
      title: 'Anything',
      message:
      'Empowering employees with seamless access to personal details, job updates, and streamlined HR processes.',
      isRead: false,
    ),
    NotificationItem(
      title: 'Anything',
      message:
      'Empowering employees with seamless access to personal details, job updates, and streamlined HR processes.',
      isRead: false,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (var n in notifications) {
        n.isRead = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabs = ['All', 'Unread', 'Read'];

    List<NotificationItem> filteredNotifications = switch (selectedTabIndex) {
      0 => notifications,
      1 => notifications.where((n) => !n.isRead).toList(),
      2 => notifications.where((n) => n.isRead).toList(),
      _ => notifications,
    };

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Notifications'),
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   foregroundColor: Colors.black,
      //   elevation: 0.5,
      //   // leading: const BackButton(),
      // ),
      body: Column(
        children: [
          // Push toggle
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text(
                  "Push notifications",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Switch(
                  value: pushEnabled,
                  onChanged: (val) => setState(() => pushEnabled = val),
                  activeColor: AppColors.brandColor,
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: List.generate(
                tabs.length,
                    (index) => Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTabIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selectedTabIndex == index
                            ? Colors.white
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        tabs[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: selectedTabIndex == index
                              ? AppColors.brandColor
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotifications.length,
              itemBuilder: (_, index) {
                final n = filteredNotifications[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.brandColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.circle,
                      size: 10,
                      color: n.isRead ? Colors.transparent : Colors.blue,
                    ),
                    title: Text(n.title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(n.message),
                    ),
                  ),
                );
              },
            ),
          ),
          if (notifications.any((n) => !n.isRead))
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ElevatedButton(
                onPressed: _markAllRead,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(color: AppColors.brandColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Mark all read",
                  style: TextStyle(color: AppColors.brandColor),
                ),
              ),
            )
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String message;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    this.isRead = false,
  });
}
