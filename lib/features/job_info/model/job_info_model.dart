class JobInfoModel {
  final String title;
  final String department;
  final String supervisor;
  final List<String> history;

  JobInfoModel({
    required this.title,
    required this.department,
    required this.supervisor,
    required this.history,
  });

  factory JobInfoModel.fromJson(Map<String, dynamic> json) {
    return JobInfoModel(
      title: json['title'] ?? '',
      department: json['department'] ?? '',
      supervisor: json['supervisor'] ?? '',
      history: List<String>.from(json['history'] ?? []),
    );
  }
}
