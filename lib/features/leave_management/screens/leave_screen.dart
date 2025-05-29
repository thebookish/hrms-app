import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/leave_services.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/leave_management/models/leave_model.dart';

class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key});

  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen> {
  List<LeaveModel> _leaves = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLeaves();
  }

  Future<void> _loadLeaves() async {
    try {
      final user = ref.read(loggedInUserProvider);
      final leaves = await LeaveService().fetchLeaves(email: user!.email);
      setState(() {
        _leaves = leaves;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loggedInUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leave Management'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showLeaveForm(context, user!.email);
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : _leaves.isEmpty
          ? const Center(child: Text('No leave records found.'))
          : ListView.builder(
        itemCount: _leaves.length,
        itemBuilder: (context, index) {
          final leave = _leaves[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(
                  '${leave.type} (${leave.fromDate.split('T')[0]} to ${leave.toDate.split('T')[0]})'),
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

  void _showLeaveForm(BuildContext context, String email) {
    final typeController = TextEditingController();
    final reasonController = TextEditingController();
    DateTime? fromDate;
    DateTime? toDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Apply for Leave',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: typeController,
                      decoration: const InputDecoration(
                        labelText: 'Leave Type',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reasonController,
                      decoration: const InputDecoration(
                        labelText: 'Reason',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      ),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 12),
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () async {
                        if (typeController.text.isEmpty ||
                            reasonController.text.isEmpty ||
                            fromDate == null ||
                            toDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('All fields are required')),
                          );
                          return;
                        }

                        try {
                          await LeaveService().applyLeave(email, {
                            'type': typeController.text.trim(),
                            'reason': reasonController.text.trim(),
                            'fromDate': fromDate!.toIso8601String(),
                            'toDate': toDate!.toIso8601String(),
                          });

                          if (mounted) {
                            Navigator.pop(context);
                            await _loadLeaves(); // refresh list
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      },
                      child: const Text('Submit Leave Request'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
