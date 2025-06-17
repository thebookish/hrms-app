class NotificationItem {
  final String title;
  final String message;
  final bool isRead;
  final DateTime date;

  NotificationItem({
    required this.title,
    required this.message,
    required this.isRead,
    required this.date,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      title: json['title'] ?? 'No Title',
      message: json['message'] ?? '',
      isRead: json['isRead'] ?? false,
      date: DateTime.parse(json['date']),
    );
  }
}
