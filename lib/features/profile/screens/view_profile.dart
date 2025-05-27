import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';
import 'package:hrms_app/features/profile/screens/edit_profile.dart';
import '../../../core/constants/app_colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeAsync = ref.watch(employeeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          )
        ],

      ),
      body: employeeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (employee) => ListView(
          padding: const EdgeInsets.all(16),
          children: [

            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary,
              backgroundImage: (employee.profilePic != null && employee.profilePic!.isNotEmpty)
                  ? NetworkImage(employee.profilePic!)
                  : null,
              child: (employee.profilePic == null || employee.profilePic!.isEmpty)
                  ? Text(
                employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
                style: const TextStyle(fontSize: 32, color: Colors.white),
              )
                  : null,
            ),

            const SizedBox(height: 16),
            Center(
              child: Text(
                employee.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Center(child: Text(employee.email, style: const TextStyle(color: Colors.grey))),
            const Divider(height: 32),
            _buildInfoTile('Position', employee.position, icon: Icons.badge_outlined),
            _buildInfoTile('Department', employee.department, icon: Icons.apartment),
            _buildInfoTile('Phone', employee.phone, icon: Icons.phone),
            _buildInfoTile('Join Date', employee.joinDate),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String? value, {IconData icon = Icons.info_outline}) {
    final displayValue = (value?.trim().isNotEmpty ?? false) ? value!.trim() : 'Not provided';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      leading: Icon(icon, color: Colors.indigo),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        displayValue,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
      ),
    );
  }


}
