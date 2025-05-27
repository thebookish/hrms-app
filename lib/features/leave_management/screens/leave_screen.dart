import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/leave_services.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/leave_management/controllers/leave_provider.dart';

class LeaveScreen extends ConsumerWidget {
  const LeaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(loggedInUserProvider);
    final leaveListAsync = ref.watch(leaveListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Management'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showLeaveForm(context, ref, user!.email),
          )
        ],
      ),
      body: leaveListAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (leaves) => ListView.builder(
          itemCount: leaves.length,
          itemBuilder: (context, index) {
            final leave = leaves[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text('${leave.type} (${leave.fromDate} to ${leave.toDate})'),
                subtitle: Text('Reason: ${leave.reason}'),
                trailing: Chip(
                  label: Text(leave.status),
                  backgroundColor: _statusColor(leave.status),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _showLeaveForm(BuildContext context, WidgetRef ref, String email) {
    final typeController = TextEditingController();
    final reasonController = TextEditingController();
    DateTime? fromDate;
    DateTime? toDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: typeController,
                    decoration: const InputDecoration(labelText: 'Leave Type'),
                  ),
                  TextField(
                    controller: reasonController,
                    decoration: const InputDecoration(labelText: 'Reason'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(fromDate == null
                            ? 'From Date'
                            : 'From: ${fromDate!.toIso8601String().split('T')[0]}'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() => fromDate = picked);
                          }
                        },
                        child: const Text('Pick From'),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(toDate == null
                            ? 'To Date'
                            : 'To: ${toDate!.toIso8601String().split('T')[0]}'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: fromDate ?? DateTime.now(),
                            firstDate: fromDate ?? DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() => toDate = picked);
                          }
                        },
                        child: const Text('Pick To'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (typeController.text.isEmpty ||
                          reasonController.text.isEmpty ||
                          fromDate == null ||
                          toDate == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All fields required')),
                        );
                        return;
                      }

                      await LeaveService().applyLeave(email, {
                        'type': typeController.text.trim(),
                        'reason': reasonController.text.trim(),
                        'fromDate': fromDate!.toIso8601String(),
                        'toDate': toDate!.toIso8601String(),
                      });

                      Navigator.pop(context);
                      ref.invalidate(leaveListProvider);
                    },
                    child: const Text('Apply'),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
