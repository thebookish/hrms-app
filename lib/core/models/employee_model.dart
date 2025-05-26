class EmployeeModel {
  final String name;
  final String email;
  final String phone;
  final String position;
  final String department;
  final String joinDate;
  final List<String> notifications;

  EmployeeModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.position,
    required this.department,
    required this.joinDate,
    required this.notifications,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      position: json['position'] ?? '',
      department: json['department'] ?? '',
      joinDate: json['joinDate'] ?? '',
      notifications: List<String>.from(json['notifications'] ?? []),
    );
  }
}
