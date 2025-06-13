import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hrms_app/core/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/constants/api_endpoints.dart';
import '../../../core/constants/app_colors.dart';

class VerifyEmployeeScreen extends StatefulWidget {
  const VerifyEmployeeScreen({super.key});

  @override
  State<VerifyEmployeeScreen> createState() => _VerifyEmployeeScreenState();
}

class _VerifyEmployeeScreenState extends State<VerifyEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  // Controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final dobController = TextEditingController();
  final familyController = TextEditingController();
  final emergencyController = TextEditingController();
  final nationalityController = TextEditingController();
  final genderController = TextEditingController();

  final idController = TextEditingController();
  final sponsorController = TextEditingController();
  final joinDateController = TextEditingController();
  final endDateController = TextEditingController();
  final jobTypeController = TextEditingController();
  final bankController = TextEditingController();
  final salaryController = TextEditingController();

  File? passportFile;
  File? sponsorFile;

  void _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
    }
  }

  Future<void> _pickAttachment(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );
    if (result != null) {
      setState(() {
        if (type == 'passport') {
          passportFile = File(result.files.single.path!);
        } else {
          sponsorFile = File(result.files.single.path!);
        }
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (passportFile == null || sponsorFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please attach passport and sponsor documents.")),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final token = await AuthService().getToken();
    final uri = Uri.parse('${ApiEndpoints.baseUrl}/employees/apply');
    final request = http.MultipartRequest("POST", uri)
      ..headers.addAll({
        'Authorization': 'Bearer $token',
      })
      ..fields.addAll({
        "fullName": fullNameController.text,
        "phone": phoneController.text,
        "email": emailController.text,
        "dob": dobController.text,
        "family": familyController.text,
        "emergency": emergencyController.text,
        "nationality": nationalityController.text,
        "gender": genderController.text,
        "id": idController.text,
        "sponsor": sponsorController.text,
        "joinDate": joinDateController.text,
        "endDate": endDateController.text,
        "jobType": jobTypeController.text,
        "bank": bankController.text,
        "salary": salaryController.text,
      })
      ..files.add(await http.MultipartFile.fromPath('passport', passportFile!.path))
      ..files.add(await http.MultipartFile.fromPath('sponsor', sponsorFile!.path));

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Application submitted successfully!')),
        );
        Navigator.pop(context);
      } else {
        throw Exception('Submission failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildField(String label, TextEditingController controller, {bool isDate = false}) {
    return TextFormField(
      controller: controller,
      readOnly: isDate,
      onTap: isDate ? () => _pickDate(controller) : null,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: isDate ? const Icon(Icons.calendar_today) : null,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        if (label.toLowerCase().contains('email') && !value.contains('@')) return 'Enter a valid email';
        return null;
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.primary),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildAttachment(String label, File? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: onTap,
              icon: const Icon(Icons.upload_file),
              label: const Text("Choose File"),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(file != null ? file.path.split('/').last : "No file chosen",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    dobController.dispose();
    familyController.dispose();
    emergencyController.dispose();
    nationalityController.dispose();
    genderController.dispose();
    idController.dispose();
    sponsorController.dispose();
    joinDateController.dispose();
    endDateController.dispose();
    jobTypeController.dispose();
    bankController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Verification"), backgroundColor: AppColors.brandColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _sectionTitle("Personal Information"),
              _buildField("Full Name", fullNameController),
              const SizedBox(height: 12),
              _buildField("Phone Number", phoneController),
              const SizedBox(height: 12),
              _buildField("Email Address", emailController),
              const SizedBox(height: 12),
              _buildField("Date of Birth", dobController, isDate: true),
              const SizedBox(height: 12),
              _buildField("Family Members", familyController),
              const SizedBox(height: 12),
              _buildField("Emergency Contact", emergencyController),
              const SizedBox(height: 12),
              _buildField("Nationality", nationalityController),
              const SizedBox(height: 12),
              _buildField("Gender", genderController),

              const SizedBox(height: 20),
              _sectionTitle("Job Information"),
              _buildField("Employee ID", idController),
              const SizedBox(height: 12),
              _buildField("Sponsor", sponsorController),
              const SizedBox(height: 12),
              _buildField("Joining Date", joinDateController, isDate: true),
              const SizedBox(height: 12),
              _buildField("End Date", endDateController, isDate: true),
              const SizedBox(height: 12),
              _buildField("Job Type", jobTypeController),
              const SizedBox(height: 12),
              _buildField("Bank Info", bankController),
              const SizedBox(height: 12),
              _buildField("Salary", salaryController),

              const SizedBox(height: 20),
              _sectionTitle("Attachments"),
              _buildAttachment("Passport Document", passportFile, () => _pickAttachment("passport")),
              const SizedBox(height: 16),
              _buildAttachment("Sponsor Document", sponsorFile, () => _pickAttachment("sponsor")),

              const SizedBox(height: 30),
              ElevatedButton.icon(
                icon: _isSubmitting
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.send),
                label: const Text("Submit"),
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandColor,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
