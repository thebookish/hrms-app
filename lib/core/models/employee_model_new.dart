class ChildInfo {
  final String name;
  final String gender;
  final String dob;
  final String schoolingYear;
  final String school;

  ChildInfo({
    required this.name,
    required this.gender,
    required this.dob,
    required this.schoolingYear,
    required this.school,
  });

  factory ChildInfo.fromJson(Map<String, dynamic> json) => ChildInfo(
    name: json['name'] ?? '',
    gender: json['gender'] ?? '',
    dob: json['dob'] ?? '',
    schoolingYear: json['schoolingYear'] ?? '',
    school: json['school'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'gender': gender,
    'dob': dob,
    'schoolingYear': schoolingYear,
    'school': school,
  };
}

class EmployeeModelNew {
  // Personal Info
  final String? firstName;
  final String? surname;
  final String? dob;
  final String? gender;
  final String? maritalStatus;
  final String? presentAddress;
  final String? permanentAddress;
  final String? passportNo;
  final String? emirateIdNo;
  final String? eidIssue;
  final String? eidExpiry;
  final String? passportIssue;
  final String? passportExpiry;
  final String? visaNo;
  final String? visaExpiry;
  final String? visaType;
  final String? sponsor;

  // Job Info
  final String? position;
  final String? wing;
  final String? homeLocal;
  final String? joinDate;
  final String? retireDate;

  // Contact Info
  final String? landPhone;
  final String? mobile;
  final String? email;
  final String? altMobile;
  final String? botim;
  final String? whatsapp;
  final String? emergency;

  // Salary Info
  final String? bank;
  final String? accountNo;
  final String? accountName;
  final String? iban;

  // Emergency Contact
  final String? emergencyName;
  final String? emergencyRelation;
  final String? emergencyPhone;
  final String? emergencyEmail;
  final String? emergencyBotim;
  final String? emergencyWhatsapp;

  // Family Info
  final String? spouseName;
  final List<ChildInfo>? childDetails;

  // Uploaded Files
  final String? photo;
  final String? passport;
  final String? eid;
  final String? visa;
  final String? cv;
  final String? cert;
  final String? ref;

  // Leave Info
  late final int? sickLeave;
  late final int? casualLeave;
  late final int? paidLeave;

  final String? status;

  EmployeeModelNew({
    this.firstName,
    this.surname,
    this.dob,
    this.gender,
    this.maritalStatus,
    this.presentAddress,
    this.permanentAddress,
    this.passportNo,
    this.emirateIdNo,
    this.eidIssue,
    this.eidExpiry,
    this.passportIssue,
    this.passportExpiry,
    this.visaNo,
    this.visaExpiry,
    this.visaType,
    this.sponsor,
    this.position,
    this.wing,
    this.homeLocal,
    this.joinDate,
    this.retireDate,
    this.landPhone,
    this.mobile,
    this.email,
    this.altMobile,
    this.botim,
    this.whatsapp,
    this.emergency,
    this.bank,
    this.accountNo,
    this.accountName,
    this.iban,
    this.emergencyName,
    this.emergencyRelation,
    this.emergencyPhone,
    this.emergencyEmail,
    this.emergencyBotim,
    this.emergencyWhatsapp,
    this.spouseName,
    this.childDetails,
    this.photo,
    this.passport,
    this.eid,
    this.visa,
    this.cv,
    this.cert,
    this.ref,
    this.sickLeave,
    this.casualLeave,
    this.paidLeave,
    this.status,
  });

  factory EmployeeModelNew.fromJson(Map<String, dynamic> json) {
    int? parseInt(dynamic val) {
      if (val == null) return null;
      if (val is int) return val;
      if (val is String) return int.tryParse(val);
      return null;
    }

    final childrenRaw = json['children'];
    List<ChildInfo>? parsedChildren;

    if (childrenRaw is Map<String, dynamic>) {
      parsedChildren = childrenRaw.entries
          .where((e) => e.value is Map<String, dynamic>)
          .map((e) => ChildInfo.fromJson(e.value as Map<String, dynamic>))
          .toList();
    }

    return EmployeeModelNew(
      firstName: json['firstName'],
      surname: json['surname'],
      dob: json['dob'],
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      presentAddress: json['presentAddress'],
      permanentAddress: json['permanentAddress'],
      passportNo: json['passportNo'],
      emirateIdNo: json['emirateIdNo'],
      eidIssue: json['eidIssue'],
      eidExpiry: json['eidExpiry'],
      passportIssue: json['passportIssue'],
      passportExpiry: json['passportExpiry'],
      visaNo: json['visaNo'],
      visaExpiry: json['visaExpiry'],
      visaType: json['visaType'],
      sponsor: json['sponsor'],
      position: json['position'],
      wing: json['wing'],
      homeLocal: json['homeLocal'],
      joinDate: json['joinDate'],
      retireDate: json['retireDate'],
      landPhone: json['landPhone'],
      mobile: json['mobile'],
      email: json['email'],
      altMobile: json['altMobile'],
      botim: json['botim'],
      whatsapp: json['whatsapp'],
      emergency: json['emergency'],
      bank: json['bank'],
      accountNo: json['accountNo'],
      accountName: json['accountName'],
      iban: json['iban'],
      emergencyName: json['emergencyName'],
      emergencyRelation: json['emergencyRelation'],
      emergencyPhone: json['emergencyPhone'],
      emergencyEmail: json['emergencyEmail'],
      emergencyBotim: json['emergencyBotim'],
      emergencyWhatsapp: json['emergencyWhatsapp'],
      spouseName: json['spouseName'],
      childDetails: parsedChildren,
      photo: json['photo']?.toString(),
      passport: json['passport']?.toString(),
      eid: json['eid']?.toString(),
      visa: json['visa']?.toString(),
      cv: json['cv']?.toString(),
      cert: json['cert']?.toString(),
      ref: json['ref']?.toString(),
      sickLeave: parseInt(json['sickLeave']),
      casualLeave: parseInt(json['casualLeave']),
      paidLeave: parseInt(json['paidLeave']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'surname': surname,
      'dob': dob,
      'gender': gender,
      'maritalStatus': maritalStatus,
      'presentAddress': presentAddress,
      'permanentAddress': permanentAddress,
      'passportNo': passportNo,
      'emirateIdNo': emirateIdNo,
      'eidIssue': eidIssue,
      'eidExpiry': eidExpiry,
      'passportIssue': passportIssue,
      'passportExpiry': passportExpiry,
      'visaNo': visaNo,
      'visaExpiry': visaExpiry,
      'visaType': visaType,
      'sponsor': sponsor,
      'position': position,
      'wing': wing,
      'homeLocal': homeLocal,
      'joinDate': joinDate,
      'retireDate': retireDate,
      'landPhone': landPhone,
      'mobile': mobile,
      'email': email,
      'altMobile': altMobile,
      'botim': botim,
      'whatsapp': whatsapp,
      'emergency': emergency,
      'bank': bank,
      'accountNo': accountNo,
      'accountName': accountName,
      'iban': iban,
      'emergencyName': emergencyName,
      'emergencyRelation': emergencyRelation,
      'emergencyPhone': emergencyPhone,
      'emergencyEmail': emergencyEmail,
      'emergencyBotim': emergencyBotim,
      'emergencyWhatsapp': emergencyWhatsapp,
      'spouseName': spouseName,
      'childDetails': childDetails?.map((c) => c.toJson()).toList(),
      'photo': photo,
      'passport': passport,
      'eid': eid,
      'visa': visa,
      'cv': cv,
      'cert': cert,
      'ref': ref,
      'sickLeave': sickLeave,
      'casualLeave': casualLeave,
      'paidLeave': paidLeave,
      'status': status,
    };
  }

  EmployeeModelNew copyWith({
    String? firstName,
    String? surname,
    String? dob,
    String? gender,
    String? maritalStatus,
    String? presentAddress,
    String? permanentAddress,
    String? passportNo,
    String? emirateIdNo,
    String? eidIssue,
    String? eidExpiry,
    String? passportIssue,
    String? passportExpiry,
    String? visaNo,
    String? visaExpiry,
    String? visaType,
    String? sponsor,
    String? position,
    String? wing,
    String? homeLocal,
    String? joinDate,
    String? retireDate,
    String? landPhone,
    String? mobile,
    String? email,
    String? altMobile,
    String? botim,
    String? whatsapp,
    String? emergency,
    String? bank,
    String? accountNo,
    String? accountName,
    String? iban,
    String? emergencyName,
    String? emergencyRelation,
    String? emergencyPhone,
    String? emergencyEmail,
    String? emergencyBotim,
    String? emergencyWhatsapp,
    String? spouseName,
    List<ChildInfo>? childDetails,
    String? photo,
    String? passport,
    String? eid,
    String? visa,
    String? cv,
    String? cert,
    String? ref,
    int? sickLeave,
    int? casualLeave,
    int? paidLeave,
    String? status,
  }) {
    return EmployeeModelNew(
      firstName: firstName ?? this.firstName,
      surname: surname ?? this.surname,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      presentAddress: presentAddress ?? this.presentAddress,
      permanentAddress: permanentAddress ?? this.permanentAddress,
      passportNo: passportNo ?? this.passportNo,
      emirateIdNo: emirateIdNo ?? this.emirateIdNo,
      eidIssue: eidIssue ?? this.eidIssue,
      eidExpiry: eidExpiry ?? this.eidExpiry,
      passportIssue: passportIssue ?? this.passportIssue,
      passportExpiry: passportExpiry ?? this.passportExpiry,
      visaNo: visaNo ?? this.visaNo,
      visaExpiry: visaExpiry ?? this.visaExpiry,
      visaType: visaType ?? this.visaType,
      sponsor: sponsor ?? this.sponsor,
      position: position ?? this.position,
      wing: wing ?? this.wing,
      homeLocal: homeLocal ?? this.homeLocal,
      joinDate: joinDate ?? this.joinDate,
      retireDate: retireDate ?? this.retireDate,
      landPhone: landPhone ?? this.landPhone,
      mobile: mobile ?? this.mobile,
      email: email ?? this.email,
      altMobile: altMobile ?? this.altMobile,
      botim: botim ?? this.botim,
      whatsapp: whatsapp ?? this.whatsapp,
      emergency: emergency ?? this.emergency,
      bank: bank ?? this.bank,
      accountNo: accountNo ?? this.accountNo,
      accountName: accountName ?? this.accountName,
      iban: iban ?? this.iban,
      emergencyName: emergencyName ?? this.emergencyName,
      emergencyRelation: emergencyRelation ?? this.emergencyRelation,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      emergencyEmail: emergencyEmail ?? this.emergencyEmail,
      emergencyBotim: emergencyBotim ?? this.emergencyBotim,
      emergencyWhatsapp: emergencyWhatsapp ?? this.emergencyWhatsapp,
      spouseName: spouseName ?? this.spouseName,
      childDetails: childDetails ?? this.childDetails,
      photo: photo ?? this.photo,
      passport: passport ?? this.passport,
      eid: eid ?? this.eid,
      visa: visa ?? this.visa,
      cv: cv ?? this.cv,
      cert: cert ?? this.cert,
      ref: ref ?? this.ref,
      sickLeave: sickLeave ?? this.sickLeave,
      casualLeave: casualLeave ?? this.casualLeave,
      paidLeave: paidLeave ?? this.paidLeave,
      status: status ?? this.status,
    );
  }
}
