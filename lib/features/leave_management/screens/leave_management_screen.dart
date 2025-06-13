import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/features/leave_management/controllers/leave_provider.dart';
import '../../../core/constants/app_colors.dart';

class AdminLeaveManagementScreen extends ConsumerWidget {
  const AdminLeaveManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveAsync = ref.watch(leaveRequestsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Requests'),
        backgroundColor: AppColors.brandColor,
      ),
      body: leaveAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (leaves) {
          if (leaves.isEmpty) {
            return const Center(child: Text('No leave requests found.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(leaveRequestsProvider);
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(12),
              itemCount: leaves.length,
              itemBuilder: (_, index) {
                final leave = leaves[index];

                return AnimatedContainer(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  curve: Curves.easeInOut,
                  child: Card(
                    color: Colors.white.withOpacity(0.95),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.brandColor.withOpacity(0.2),
                        child: Icon(
                          Icons.person_outline,
                          color: AppColors.brandColor,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        '${leave.type} Leave',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.brandColor,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Email: ${leave.email}', style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('Duration: ${leave.fromDate} → ${leave.toDate}',
                                style: const TextStyle(fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('Reason: ${leave.reason}', style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                      trailing: Container(
                        decoration: BoxDecoration(
                          color: _statusColor(leave.status),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: Text(
                          leave.status.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
