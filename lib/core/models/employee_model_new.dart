class EmployeeModelNew {
  final String? fullName;
  final String? phone;
  final String? email;
  final String? dob;
  final String? family;
  final String? emergency;
  final String? nationality;
  final String? gender;
  final String? passport;
  final String? id;
  final String? sponsor;
  final String? endDate;
  final String? jobType;
  final String? bank;
  final String? salary;
  final int? sickLeave;
  final int? casualLeave;
  final int? paidLeave;
  final String? status;


  EmployeeModelNew( {
    this.fullName,
    this.phone,
    this.email,
    this.dob,
    this.family,
    this.emergency,
    this.nationality,
    this.gender,
    this.passport,
    this.id,
    this.sponsor,
    this.endDate,
    this.jobType,
    this.bank,
    this.salary,
    this.sickLeave,
    this.casualLeave,
    this.paidLeave,
    this.status,
  });
  EmployeeModelNew copyWith({
    String? fullName,
    String? phone,
    String? email,
    String? dob,
    String? family,
    String? emergency,
    String? nationality,
    String? gender,
    String? passport,
    String? id,
    String? sponsor,
    String? joinDate,
    String? endDate,
    String? jobType,
    String? bank,
    String? salary,
    int? sickLeave,
    int? casualLeave,
    int? paidLeave,
    String? status,
  }) {
    return EmployeeModelNew(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      family: family ?? this.family,
      emergency: emergency ?? this.emergency,
      nationality: nationality ?? this.nationality,
      gender: gender ?? this.gender,
      passport: passport ?? this.passport,
      id: id ?? this.id,
      sponsor: sponsor ?? this.sponsor,
      // joinDate: joinDate ?? this.joinDate,
      endDate: endDate ?? this.endDate,
      jobType: jobType ?? this.jobType,
      bank: bank ?? this.bank,
      salary: salary ?? this.salary,
      sickLeave: sickLeave?? this.sickLeave,
      casualLeave: casualLeave??this.casualLeave,
      paidLeave: paidLeave??this.paidLeave,
      status: status ?? this.status,
    );
  }
  factory EmployeeModelNew.fromJson(Map<String, dynamic> json) {
    return EmployeeModelNew(
      fullName: json['fullName'],
      phone: json['phone'],
      email: json['email'],
      dob: json['dob'],
      family: json['family'],
      emergency: json['emergency'],
      nationality: json['nationality'],
      gender: json['gender'],
      passport: json['passport'],
      id: json['id'],
      sponsor: json['sponsor'],
      endDate: json['endDate'],
      jobType: json['jobType'],
      bank: json['bank'],
      salary: json['salary'],
      sickLeave: json['sickLeave'],
      casualLeave: json['casualLeave'],
      paidLeave:  json['paidLeave'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'dob': dob,
      'family': family,
      'emergency': emergency,
      'nationality': nationality,
      'gender': gender,
      'passport': passport,
      'id': id,
      'sponsor': sponsor,
      'endDate': endDate,
      'jobType': jobType,
      'bank': bank,
      'salary': salary,
      'sickLeave': sickLeave,
      'casualLeave': casualLeave,
      'paidLeave': paidLeave,
      'status': status,
    };
  }
}
