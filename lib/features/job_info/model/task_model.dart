class TaskModel {
  final String id;
  final String title;
  final String deadline;
  final bool isCompleted;
  final String priority; // "High", "Medium", "Low"
  final String status; // "In Progress", "Completed", "Pending", etc.

  TaskModel({
    required this.id,
    required this.title,
    required this.deadline,
    required this.isCompleted,
    required this.priority,
    required this.status,
  });
}
