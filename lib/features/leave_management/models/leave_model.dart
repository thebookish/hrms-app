class LeaveModel {
  final String id;
  final String name;
  final String email;
  final String type;
  final String fromDate;
  final String toDate;
  final String status;
  final String reason;

  // New fields
  final int noOfDays;
  final String whatsapp;
  final String emergencyContact;
  final String substituteName;
  final String substituteContact;
  final String signature;
  final String designation;
  final String wing;

  LeaveModel({
    required this.id,
    required this.name,
    required this.email,
    required this.type,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.reason,
    required this.noOfDays,
    required this.whatsapp,
    required this.emergencyContact,
    required this.substituteName,
    required this.substituteContact,
    required this.signature,
    required this.designation,
    required this.wing,
  });

  factory LeaveModel.fromJson(Map<String, dynamic> json) {
    return LeaveModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      type: json['type'] ?? '',
      fromDate: json['fromDate'] ?? '',
      toDate: json['toDate'] ?? '',
      status: json['status'] ?? 'Pending',
      reason: json['reason'] ?? '',
      noOfDays: json['noOfDays'] ?? 0,
      whatsapp: json['whatsapp'] ?? '',
      emergencyContact: json['emergencyContact'] ?? '',
      substituteName: json['substituteName'] ?? '',
      substituteContact: json['substituteContact'] ?? '',
      signature: json['signature'] ?? '',
      designation: json['designation'] ?? '',
      wing: json['wing'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'type': type,
      'fromDate': fromDate,
      'toDate': toDate,
      'status': status,
      'reason': reason,
      'noOfDays': noOfDays,
      'whatsapp': whatsapp,
      'emergencyContact': emergencyContact,
      'substituteName': substituteName,
      'substituteContact': substituteContact,
      'signature': signature,
      'designation': designation,
      'wing': wing,
    };
  }
}
