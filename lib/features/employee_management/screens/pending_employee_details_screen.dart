import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/models/employee_model_new.dart';
import 'package:hrms_app/features/dashboard/controllers/admin_provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/services/employee_services.dart';
import '../../../core/services/notification_service.dart'; // <-- import this

class PendingEmployeeDetailsScreen extends ConsumerWidget {
  final EmployeeModelNew employee;

  const PendingEmployeeDetailsScreen({super.key, required this.employee});

  Future<void> _sendNotification({
    required String title,
    required String message,
    required String receiverEmail,
  }) async {
    try {
      await NotificationService().sendNotification(
        title: title,
        message: message,
        receiverEmail: receiverEmail,
      );
    } catch (e) {
      debugPrint('Failed to send notification: $e');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = employee.fullName ?? 'Unnamed';

    return Scaffold(
      appBar: AppBar(
        title: Text('Review: $name'),
        backgroundColor: AppColors.brandColor,
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _profileHeader(name),
            const SizedBox(height: 24),
            _sectionTitle('Personal Info'),
            _infoTile("Phone", employee.phone),
            _infoTile("Email", employee.email),
            _infoTile("Date of Birth", employee.dob),
            _infoTile("Gender", employee.gender),
            _infoTile("Nationality", employee.nationality),
            const SizedBox(height: 16),
            _sectionTitle('Job Info'),
            _infoTile("Sponsor", employee.sponsor),
            _infoTile("Job Type", employee.jobType),
            _infoTile("Join-End", employee.endDate),
            _infoTile("Bank", employee.bank),
            _infoTile("Salary", employee.salary),
            const SizedBox(height: 16),
            _sectionTitle('Emergency Details'),
            _infoTile("Family", employee.family),
            _infoTile("Emergency Contact", employee.emergency),
            _infoTile("Passport", employee.passport),
            _infoTile("ID", employee.id),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Approve Employee'),
                    onPressed: () async {
                      await EmployeeService().approveEmployee(employee.email ?? '');
                      await _sendNotification(
                        title: 'Verification Approved',
                        message: 'Hi $name, your employment verification has been approved.',
                        receiverEmail: employee.email ?? '',
                      );
                      ref.invalidate(verificationRequestProvider);
                      ref.invalidate(approvedEmployeesProvider);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Employee approved')),
                        );
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: const Icon(Icons.cancel),
                    label: const Text('Decline'),
                    onPressed: () async {
                      final confirmed = await showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Decline Employee'),
                          content: const Text('Are you sure you want to decline this employee?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Decline', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        await EmployeeService().declineEmployee(employee.email ?? '');
                        await _sendNotification(
                          title: 'Verification Declined',
                          message: 'Hi $name, unfortunately your employment verification was declined.',
                          receiverEmail: employee.email ?? '',
                        );
                        ref.invalidate(verificationRequestProvider);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Employee declined')),
                          );
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileHeader(String name) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppColors.brandColor,
          child: Text(
            name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(employee.status?.toUpperCase() ?? 'PENDING', style: const TextStyle(color: Colors.orange)),
      ],
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.brandColor),
      ),
    );
  }

  Widget _infoTile(String label, String? value) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.info_outline),
        title: Text(label),
        subtitle: Text(value?.isNotEmpty == true ? value! : 'N/A'),
      ),
    );
  }
}
