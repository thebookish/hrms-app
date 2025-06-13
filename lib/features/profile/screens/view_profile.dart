import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';
import 'package:hrms_app/features/employee_management/screens/verify_employee_screen.dart';
import 'package:hrms_app/features/profile/screens/edit_profile.dart';
import '../../../core/constants/app_colors.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  Future<void> _refresh() async {
    ref.invalidate(employeeProvider);
    await Future.delayed(const Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    final employeeAsync = ref.watch(employeeProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: employeeAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
          data: (employee) => ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 24),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const SizedBox(height: 10),

              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: employee.profilePic != null && employee.profilePic!.isNotEmpty
                      ? Image.network(employee.profilePic!, width: 120, height: 120, fit: BoxFit.cover)
                      : Container(
                    width: 120,
                    height: 120,
                    color: AppColors.brandColor,
                    alignment: Alignment.center,
                    child: Text(
                      employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Column(
                  children: [
                    Text(employee.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.brandColor)),
                    const SizedBox(height: 4),
                    Text(
                      '${employee.position} • ${employee.department}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Divider(),
              _sectionItem(context, icon: Icons.call, title: "Mobile", description: employee.phone.isNotEmpty ? employee.phone : "No number provided."),
              _sectionItem(context, icon: Icons.attach_email_outlined, title: "Contact Email", description: employee.email.isNotEmpty ? employee.email : "Not specified."),
              _sectionItem(context, icon: Icons.work_outline, title: "Position", description: employee.position.isNotEmpty ? employee.position : "Not specified."),
              _sectionItem(context, icon: Icons.group_work, title: "Department", description: employee.department.isNotEmpty ? employee.department : "Not specified."),

              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.verified_user_outlined),
                  label: const Text("Verify as Employee"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandColor,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const VerifyEmployeeScreen()),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionItem(BuildContext context,
      {required IconData icon, required String title, required String description}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 24, color: AppColors.brandColor),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.brandColor)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: AppColors.brandColor),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(description, style: const TextStyle(color: Colors.black87, fontSize: 14)),
            ),
          ),
          const Divider(height: 32),
        ],
      ),
    );
  }
}
