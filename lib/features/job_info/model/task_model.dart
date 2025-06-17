class TaskModel {
  final String id;
  final String title;
  final String deadline;
  final bool isCompleted;
  final String priority;
  final String status;

  TaskModel({
    required this.id,
    required this.title,
    required this.deadline,
    required this.isCompleted,
    required this.priority,
    required this.status,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      deadline: json['deadline'],
      isCompleted: json['isCompleted'] as bool,
      priority: json['priority'],
      status: json['status'],
    );
  }
}
