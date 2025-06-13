class LeaveModel {
  final String id;
  final String email;
  final String type;
  final String fromDate;
  final String toDate;
  final String status;
  final String reason;

  LeaveModel({
    required this.id,
    required this.email,
    required this.type,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.reason,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['_id'] ?? '',
      email: json['email']??'',
      type: json['type'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      status: json['status'] ?? 'Pending',
      reason: json['reason'] ?? '',
    );
  }
}
