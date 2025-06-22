class SponsorModel {
  final String name;
  final String industry;
  final String contactPerson;
  final String email;
  final String phone;
  final String address;
  final String logoUrl;

  SponsorModel({
    required this.name,
    required this.industry,
    required this.contactPerson,
    required this.email,
    required this.phone,
    required this.address,
    required this.logoUrl,
  });

  factory SponsorModel.fromJson(Map<String, dynamic> json) {
    return SponsorModel(
      name: json['name'] ?? '',
      industry: json['industry'] ?? '',
      contactPerson: json['contactPerson'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      address: json['address'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'industry': industry,
      'contactPerson': contactPerson,
      'email': email,
      'phone': phone,
      'address': address,
      'logoUrl': logoUrl,
    };
  }
}
