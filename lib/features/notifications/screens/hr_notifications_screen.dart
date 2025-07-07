import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/models/employee_model_new.dart';
import 'package:hrms_app/core/services/notification_service.dart';
import 'package:hrms_app/features/dashboard/controllers/admin_provider.dart';

class HRNotificationScreen extends ConsumerStatefulWidget {
  const HRNotificationScreen({super.key});

  @override
  ConsumerState<HRNotificationScreen> createState() => _HRNotificationScreenState();
}

class _HRNotificationScreenState extends ConsumerState<HRNotificationScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSending = false;

  // Future<void> _sendPushNotificationToAll(List<EmployeeModelNew> employees) async {
  //   setState(() => _isSending = true);
  //
  //   try {
  //     for (final emp in employees) {
  //       final token = emp.fcmToken;
  //       if (token != null && token.isNotEmpty) {
  //         await NotificationService().sendPushNotification(
  //           title: _titleController.text.trim(),
  //           message: _messageController.text.trim(),
  //           fcmToken: token,
  //         );
  //       }
  //     }
  //
  //     if (mounted) {
  //       _titleController.clear();
  //       _messageController.clear();
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Push notifications sent to all.')),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error sending push: $e')),
  //     );
  //   } finally {
  //     if (mounted) setState(() => _isSending = false);
  //   }
  // }

  Future<void> _sendNotificationToAll(List<String> emails) async {
    setState(() => _isSending = true);

    try {
      for (final email in emails) {
        await NotificationService().sendNotification(
          title: _titleController.text.trim(),
          message: _messageController.text.trim(),
          receiverEmail: email,
        );
      }

      if (mounted) {
        _titleController.clear();
        _messageController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification sent to all approved employees.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending notifications')),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeesAsync = ref.watch(approvedEmployeesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
        backgroundColor: AppColors.brandColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: employeesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Something Went Wrong!')),
          data: (employees) {
            final emails = employees.map((e) => e.email ?? '').where((e) => e.isNotEmpty).toList();

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text('Title', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter title',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Title required' : null,
                  ),
                  const SizedBox(height: 20),
                  const Text('Message', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your message',
                    ),
                    validator: (value) => value == null || value.isEmpty ? 'Message required' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.send),
                    label: Text(_isSending ? 'Sending...' : 'Send to ${emails.length} Employees'),
                    onPressed: _isSending
                        ? null
                        : () {
                      if (_formKey.currentState!.validate()) {
                        _sendNotificationToAll(emails);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
