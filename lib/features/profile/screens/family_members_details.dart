import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';

class FamilyMembersScreen extends StatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  List<FamilyMember> familyList = [
    FamilyMember(name: "Jane Doe", relation: "Wife", age: 32, contact: "0123456789"),
    FamilyMember(name: "John Junior", relation: "Son", age: 8, contact: "N/A"),
  ];

  void _addFamilyMemberDialog() {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final ageController = TextEditingController();
    final contactController = TextEditingController();

    showModalBottomSheet(
      backgroundColor: AppColors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text("Add Family Member",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Name"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: relationController,
                  decoration: const InputDecoration(labelText: "Relation"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Age"),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: "Contact"),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (nameController.text.isEmpty ||
                        relationController.text.isEmpty ||
                        ageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("All fields are required")));
                      return;
                    }

                    setState(() {
                      familyList.add(FamilyMember(
                        name: nameController.text.trim(),
                        relation: relationController.text.trim(),
                        age: int.tryParse(ageController.text) ?? 0,
                        contact: contactController.text.trim(),
                      ));
                    });
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text("Add Member"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandColor,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Family Members"),
        backgroundColor: AppColors.brandColor,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: familyList.length,
        itemBuilder: (_, index) {
          final member = familyList[index];
          return Card(
            color: AppColors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.brandColor,
                child: Text(member.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white)),
              ),
              title: Text(member.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Relation: ${member.relation}"),
                  Text("Age: ${member.age}"),
                  Text("Contact: ${member.contact}"),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                onPressed: () {
                  setState(() {
                    familyList.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.brandColor,
        icon: const Icon(Icons.add, color: Colors.white,),
        label: const Text("Add Member", style: TextStyle(color: AppColors.white),),
        onPressed: _addFamilyMemberDialog,
      ),
    );
  }
}

class FamilyMember {
  final String name;
  final String relation;
  final int age;
  final String contact;

  FamilyMember({
    required this.name,
    required this.relation,
    required this.age,
    required this.contact,
  });
}
