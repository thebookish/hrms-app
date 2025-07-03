import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/features/settings/providers/theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/models/family_members_model.dart';
import 'package:hrms_app/core/services/family_services.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';

class FamilyMembersScreen extends ConsumerStatefulWidget {
  const FamilyMembersScreen({super.key});

  @override
  ConsumerState<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends ConsumerState<FamilyMembersScreen> {
  List<FamilyMember> familyList = [];
  bool isLoading = true;

  late String userEmail;

  @override
  void initState() {
    super.initState();
    final user = ref.read(loggedInUserProvider);
    userEmail = user?.email ?? '';
    _loadFamilyMembers();
  }

  Future<void> _loadFamilyMembers() async {
    try {
      final members = await FamilyService().getFamilyMembers(userEmail);
      setState(() {
        familyList = members;
        isLoading = false;
        print('Loaded members: ${members.length}');
        for (var m in members) {
          print('${m.name} (${m.relation})');
        }
      });
    } catch (e) {
      setState(() => isLoading = false);
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Something Went Wrong!')),
      // );
    }
  }

  Future<void> _addFamilyMemberDialog() async {
    final nameController = TextEditingController();
    final relationController = TextEditingController();
    final ageController = TextEditingController();
    final contactController = TextEditingController();
    final themeMode = ref.read(themeModeProvider.notifier).state;
    await showModalBottomSheet(
      backgroundColor: themeMode==ThemeMode.dark?Colors.black45:AppColors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      context: context,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            top: 24,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Add Family Member",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
              const SizedBox(height: 12),
              TextField(controller: relationController, decoration: const InputDecoration(labelText: "Relation")),
              const SizedBox(height: 12),
              TextField(controller: ageController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Age")),
              const SizedBox(height: 12),
              TextField(controller: contactController, decoration: const InputDecoration(labelText: "Contact")),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () async {
                  if (nameController.text.isEmpty || relationController.text.isEmpty || ageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("All fields are required")));
                    return;
                  }

                  final member = FamilyMember(
                    id: const Uuid().v4(),
                    name: nameController.text.trim(),
                    relation: relationController.text.trim(),
                    age: int.tryParse(ageController.text) ?? 0,
                    contact: contactController.text.trim(),
                    email: userEmail,
                  );

                  try {
                    await FamilyService().addFamilyMember(member);
                    Navigator.pop(context);
                    await _loadFamilyMembers();
                  } catch (e) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
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
        );
      },
    );
  }

  Future<void> _deleteFamilyMember(String email) async {
    try {
      await FamilyService().deleteFamilyMember(email);
      await _loadFamilyMembers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.read(themeModeProvider.notifier).state;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Family Members"),
        backgroundColor: AppColors.brandColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFamilyMembers,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadFamilyMembers,
        child: familyList.isEmpty
            ?  ListView( // Needed so RefreshIndicator still works
          children: [Center(child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text('No family members found.', style: TextStyle(color: themeMode==ThemeMode.dark?Colors.white:AppColors.brandColor,),),
          ))],
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: familyList.length,
          itemBuilder: (_, index) {
            final member = familyList[index];
            return Card(
              color: themeMode==ThemeMode.dark?Colors.white12:AppColors.white,
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
                  onPressed: () => _deleteFamilyMember(member.id),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.brandColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Member", style: TextStyle(color: Colors.white)),
        onPressed: _addFamilyMemberDialog,
      ),
    );
  }

}
