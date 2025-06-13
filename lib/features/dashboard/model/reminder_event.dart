class ReminderEvent {
  final String title;
  final String time;
  final int colorValue;

  ReminderEvent({required this.title, required this.time, required this.colorValue});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'time': time,
      'color': colorValue,
    };
  }

  factory ReminderEvent.fromMap(Map<String, dynamic> map) {
    return ReminderEvent(
      title: map['title'],
      time: map['time'],
      colorValue: map['color'],
    );
  }
}
