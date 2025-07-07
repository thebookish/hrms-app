import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/models/employee_model_new.dart';
import 'package:hrms_app/core/services/employee_services.dart';
import 'package:hrms_app/core/services/notification_service.dart';
import 'package:hrms_app/features/dashboard/controllers/admin_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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
      debugPrint('Notification error: $e');
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (Platform.isAndroid) {
      if (await Permission.storage.request().isGranted) return true;

      if (await Permission.manageExternalStorage.isGranted) return true;

      final status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    }
    return true;
  }

  Future<void> _downloadFile(BuildContext context, String url, String label) async {
    try {
      final hasPermission = await _requestStoragePermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
        return;
      }

      final dir = Directory('/storage/emulated/0/Download'); // Downloads folder
      final fileName = url.split('/').last;
      final savePath = '${dir.path}/$fileName';

      await Dio().download(url, savePath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label downloaded to Downloads folder')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed!')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullName = "${employee.firstName ?? ''} ${employee.surname ?? ''}".trim();

    return Scaffold(
      appBar: AppBar(
        title: Text('Review: $fullName'),
        backgroundColor: AppColors.brandColor,
      ),
      backgroundColor: const Color(0xFFF9FAFB),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _profileHeader(fullName),
            const SizedBox(height: 24),
            _sectionTitle('Personal Info'),
            _infoTile("Date of Birth", employee.dob),
            _infoTile("Gender", employee.gender),
            _infoTile("Marital Status", employee.maritalStatus),
            _infoTile("Present Address", employee.presentAddress),
            _infoTile("Permanent Address", employee.permanentAddress),
            _infoTile("Passport No.", employee.passportNo),
            _infoTile("Emirate ID", employee.emirateIdNo),
            _infoTile("EID Issue", employee.eidIssue),
            _infoTile("EID Expiry", employee.eidExpiry),
            _infoTile("Passport Issue", employee.passportIssue),
            _infoTile("Passport Expiry", employee.passportExpiry),

            const SizedBox(height: 16),
            _sectionTitle('Job Info'),
            _infoTile("Sponsor", employee.sponsor),
            _infoTile("Position", employee.position),
            _infoTile("Wing", employee.wing),
            _infoTile("Home/Local", employee.homeLocal),
            _infoTile("Joining Date", employee.joinDate),
            _infoTile("Retirement Date", employee.retireDate),

            const SizedBox(height: 16),
            _sectionTitle('Contact Info'),
            _infoTile("Phone", employee.mobile),
            _infoTile("Alternative Phone", employee.altMobile),
            _infoTile("Email", employee.email),
            _infoTile("Botim", employee.botim),
            _infoTile("WhatsApp", employee.whatsapp),
            _infoTile("Emergency Contact", employee.emergency),

            const SizedBox(height: 16),
            _sectionTitle('Salary Account Info'),
            _infoTile("Bank", employee.bank),
            _infoTile("Account No.", employee.accountNo),
            _infoTile("Account Holder", employee.accountName),
            _infoTile("IBAN", employee.iban),

            const SizedBox(height: 16),
            _sectionTitle('Emergency Contact'),
            _infoTile("Name", employee.emergencyName),
            _infoTile("Relation", employee.emergencyRelation),
            _infoTile("Phone", employee.emergencyPhone),
            _infoTile("Email", employee.emergencyEmail),
            _infoTile("WhatsApp", employee.emergencyWhatsapp),
            _infoTile("Botim", employee.emergencyBotim),

            const SizedBox(height: 16),
            _sectionTitle('Family Info'),
            _infoTile("Spouse Name", employee.spouseName),
            // _infoTile("No. of Children", employee.children),
            if (employee.childDetails != null && employee.childDetails!.isNotEmpty)
              ...employee.childDetails!.map((child) => _infoTile("Child: ${child.name}", "School: ${child.school}, DOB: ${child.dob}")),
            _sectionTitle('Documents'),
            _wrapFileTile(context, 'Photo', employee.photo),
            _wrapFileTile(context, 'Passport', employee.passport),
            _wrapFileTile(context, 'EID', employee.eid),
            _wrapFileTile(context, 'Visa', employee.visa),
            _wrapFileTile(context, 'CV', employee.cv),
            _wrapFileTile(context, 'Certificates', employee.cert),
            _wrapFileTile(context, 'Reference Letter', employee.ref),
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
                        message: 'Hi $fullName, your employment verification has been approved.',
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
                          message: 'Hi $fullName, unfortunately your employment verification was declined.',
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
            name.isNotEmpty ? name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
        const SizedBox(height: 12),
        Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  Widget _wrapFileTile(BuildContext context, String label, String? filePath) {
    final url = filePath != null && filePath.isNotEmpty
        ? 'https://backend-hrm-cwbfc6cwbwbbdhae.southeastasia-01.azurewebsites.net$filePath'
        : null;

    if (url == null) {
      return _infoTile(label, 'N/A');
    }

    final isImage = url.endsWith('.png') || url.endsWith('.jpg') || url.endsWith('.jpeg');
    final isPdf = url.endsWith('.pdf');

    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            if (isImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  url,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Text("Failed to load image"),
                ),
              )
            else if (isPdf)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: const Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 10),
                    Text("PDF Document"),
                  ],
                ),
              )
            else
              const Text("Unsupported file type"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // TextButton.icon(
                //   icon: const Icon(Icons.open_in_browser),
                //   label: const Text("Open"),
                //   onPressed: () async {
                //     final uri = Uri.parse(url);
                //     try {
                //       if (await canLaunchUrl(uri)) {
                //         await launchUrl(uri, mode: LaunchMode.externalApplication);
                //       } else {
                //         ScaffoldMessenger.of(context).showSnackBar(
                //           const SnackBar(content: Text('Cannot open the link')),
                //         );
                //       }
                //     } catch (e) {
                //       ScaffoldMessenger.of(context).showSnackBar(
                //         SnackBar(content: Text('Failed to open link: $e')),
                //       );
                //     }
                //   },
                // ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text("Download"),
                  onPressed: () async {
                    await _downloadFile(context, url, label);
                  },
                ),
              ],
            )
          ],
        ),
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
        subtitle: value != null && value.trim().isNotEmpty
            ? SelectableText(value)
            : const Text('N/A'),
      ),
    );
  }
}
