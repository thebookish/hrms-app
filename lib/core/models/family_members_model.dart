// core/models/family_member_model.dart

class FamilyMember {
  final String id;
  final String name;
  final String relation;
  final int age;
  final String contact;
  final String email;

  FamilyMember({
    required this.id,
    required this.name,
    required this.relation,
    required this.age,
    required this.contact,
    required this.email,
  });

  factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id: json['id'],
      name: json['name'],
      relation: json['relation'],
      age: json['age'],
      contact: json['contact'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'relation': relation,
      'age': age,
      'contact': contact,
      'email': email,
    };
  }
}
