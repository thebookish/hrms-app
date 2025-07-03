import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/employee_services.dart';
import 'package:hrms_app/core/services/leave_services.dart';
import 'package:hrms_app/core/services/notification_service.dart';
import 'package:hrms_app/features/leave_management/controllers/leave_provider.dart';
import 'package:hrms_app/core/models/employee_model_new.dart';

class AdminLeaveManagementScreen extends ConsumerStatefulWidget {
  const AdminLeaveManagementScreen({super.key});

  @override
  ConsumerState<AdminLeaveManagementScreen> createState() =>
      _AdminLeaveManagementScreenState();
}

class _AdminLeaveManagementScreenState
    extends ConsumerState<AdminLeaveManagementScreen> {
  final Map<String, EmployeeModelNew> _employeeCache = {};

  Future<EmployeeModelNew?> _getEmployeeByEmail(String email) async {
    // if (_employeeCache.containsKey(email)) return _employeeCache[email];
    //
    // try {
      final employee = await EmployeeService().getEmployeeDataByEmail(email);
      _employeeCache[email] = employee;
      return employee;
    // } catch (_) {
    //   return null;
    // }
  }

  Future<void> _handleLeaveAction({
    required String email,
    required String action,
    required String type,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${action[0].toUpperCase()}${action.substring(1)} Leave'),
        content: const Text('Are you sure you want to proceed?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'approved' ? Colors.green : Colors.red,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      final employee = await _getEmployeeByEmail(email);
      if (employee == null) throw Exception('Employee not found');

      if (action == 'approved') {
        // Deduct leave balance
        switch (type.toLowerCase()) {
          case 'sick leave':
            employee.sickLeave = (employee.sickLeave ?? 0) - 1;
            break;
          case 'casual leave':
            employee.casualLeave = (employee.casualLeave ?? 0) - 1;
            break;
          case 'paid leave':
            employee.paidLeave = (employee.paidLeave ?? 0) - 1;
            break;
        }

        await EmployeeService().updateEmployee(employee);
        await LeaveService().approveLeave(email);
      } else {
        await LeaveService().rejectLeave(email);
      }

      // Send Notification
      await NotificationService().sendNotification(
        title: 'Leave ${action == 'approved' ? 'Approved' : 'Rejected'}',
        message: 'Your ${type.toLowerCase()} has been ${action.toLowerCase()} by HR.',
        receiverEmail: email,
      );

      ref.invalidate(leaveRequestsProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Leave $action successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
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
              _employeeCache.clear();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: leaves.length,
              itemBuilder: (_, index) {
                final leave = leaves[index];
                return FutureBuilder<EmployeeModelNew?>(
                  future: _getEmployeeByEmail(leave.email),
                  builder: (_, snapshot) {
                    final employee = snapshot.data;
                    // final employeeId = employee?.id ?? 'Loading...';

                    return Card(
                      color: AppColors.white,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor:
                                AppColors.brandColor.withOpacity(0.2),
                                child: const Icon(Icons.person,
                                    color: AppColors.brandColor),
                              ),
                              title: Text(
                                leave.type,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.brandColor),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('Name: ${leave.name}'),
                                  // Text('Employee ID: $employeeId'),
                                  Text('Email: ${leave.email}'),
                                  Text('Duration: ${leave.fromDate} → ${leave.toDate}'),
                                  Text('Reason: ${leave.reason}'),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _statusColor(leave.status),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  leave.status.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            if (leave.status.toLowerCase() == 'pending')
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton.icon(

                                    onPressed: () => _handleLeaveAction(
                                      email: leave.email,
                                      action: 'approved',
                                      type: leave.type,
                                    ),
                                    icon: const Icon(Icons.check),
                                    label: const Text('Approve'),
                                    style: ElevatedButton.styleFrom(

                                        backgroundColor: Colors.green),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: () => _handleLeaveAction(
                                      email: leave.email,
                                      action: 'rejected',
                                      type: leave.type,
                                    ),
                                    icon: const Icon(Icons.close),
                                    label: const Text('Reject'),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red),
                                  ),
                                ],
                              )
                          ],
                        ),
                      ),
                    );
                  },
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
