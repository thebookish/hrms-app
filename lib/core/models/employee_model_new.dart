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
  final String? status;

  EmployeeModelNew({
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
    this.status,
  });

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
      'status': status,
    };
  }
}
