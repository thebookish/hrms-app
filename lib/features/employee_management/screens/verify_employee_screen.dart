import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:hrms_app/core/constants/api_endpoints.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/auth_service.dart';
import 'package:http/http.dart' as http;

class VerifyEmployeeScreen extends StatefulWidget {
  const VerifyEmployeeScreen({super.key});

  @override
  State<VerifyEmployeeScreen> createState() => _VerifyEmployeeScreenState();
}

class _VerifyEmployeeScreenState extends State<VerifyEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;

  final Map<String, TextEditingController> controllers = {
    "firstName": TextEditingController(),
    "surname": TextEditingController(),
    "dob": TextEditingController(),
    "gender": TextEditingController(),
    "maritalStatus": TextEditingController(),
    "presentAddress": TextEditingController(),
    "permanentAddress": TextEditingController(),
    "passportNo": TextEditingController(),
    "emirateIdNo": TextEditingController(),
    "eidIssue": TextEditingController(),
    "eidExpiry": TextEditingController(),
    "passportIssue": TextEditingController(),
    "passportExpiry": TextEditingController(),
    "visaNo": TextEditingController(),
    "visaExpiry": TextEditingController(),
    "visaType": TextEditingController(),
    "sponsor": TextEditingController(),
    "position": TextEditingController(),
    "wing": TextEditingController(),
    "homeLocal": TextEditingController(),
    "joinDate": TextEditingController(),
    "retireDate": TextEditingController(),
    "landPhone": TextEditingController(),
    "mobile": TextEditingController(),
    "email": TextEditingController(),
    "altMobile": TextEditingController(),
    "botim": TextEditingController(),
    "whatsapp": TextEditingController(),
    "emergency": TextEditingController(),
    "bank": TextEditingController(),
    "accountNo": TextEditingController(),
    "accountName": TextEditingController(),
    "iban": TextEditingController(),
    "emergencyName": TextEditingController(),
    "emergencyRelation": TextEditingController(),
    "emergencyPhone": TextEditingController(),
    "emergencyEmail": TextEditingController(),
    "emergencyBotim": TextEditingController(),
    "emergencyWhatsapp": TextEditingController(),
    "spouseName": TextEditingController(),
    "children": TextEditingController(),
  };

  List<Map<String, TextEditingController>> childrenControllers = [];

  File? photoFile, passportFile, eidFile, visaFile, cvFile, certFile, refFile;

  @override
  void initState() {
    super.initState();
    _addChild(); // One child entry by default
  }

  void _addChild() {
    childrenControllers.add({
      "name": TextEditingController(),
      "gender": TextEditingController(),
      "dob": TextEditingController(),
      "schoolingYear": TextEditingController(),
      "school": TextEditingController(),
    });
    setState(() {});
  }

  void _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = picked.toIso8601String().split('T').first;
    }
  }

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      final file = File(result.files.single.path!);
      setState(() {
        switch (type) {
          case 'photo': photoFile = file; break;
          case 'passport': passportFile = file; break;
          case 'eid': eidFile = file; break;
          case 'visa': visaFile = file; break;
          case 'cv': cvFile = file; break;
          case 'cert': certFile = file; break;
          case 'ref': refFile = file; break;
        }
      });
    }
  }

  Widget _buildField(String label, TextEditingController controller, {bool date = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        readOnly: date,
        onTap: date ? () => _pickDate(controller) : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: date ? const Icon(Icons.calendar_today) : null,
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildFileUpload(String label, File? file, VoidCallback onPick) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.upload_file),
            label: Text(label),
            onPressed: onPick,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(file != null ? file.path.split('/').last : 'No file chosen',
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if ([photoFile, passportFile, eidFile, visaFile, cvFile].any((f) => f == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Upload all required documents")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final uri = Uri.parse('${ApiEndpoints.baseUrl}/employees/apply');
    final token = await AuthService().getToken();
    final request = http.MultipartRequest("POST", uri)
      ..headers['Authorization'] = 'Bearer $token';

    controllers.forEach((key, controller) {
      request.fields[key] = controller.text.trim();
    });

    for (int i = 0; i < childrenControllers.length; i++) {
      childrenControllers[i].forEach((key, ctrl) {
        request.fields['children[$i][$key]'] = ctrl.text;
      });
    }

    final uploads = {
      'photo': photoFile,
      'passport': passportFile,
      'eid': eidFile,
      'visa': visaFile,
      'cv': cvFile,
      'cert': certFile,
      'ref': refFile,
    };

    for (var entry in uploads.entries) {
      if (entry.value != null) {
        request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value!.path));
      }
    }

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Submitted Successfully")));
          Navigator.pop(context);
        }
      } else {
        throw Exception('Submission failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    controllers.values.forEach((c) => c.dispose());
    for (final map in childrenControllers) {
      map.values.forEach((c) => c.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Employee Verification"), backgroundColor: AppColors.brandColor),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection("Personal Details", [
                _buildField("First Name", controllers["firstName"]!),
                _buildField("Surname", controllers["surname"]!),
                _buildField("Date of Birth", controllers["dob"]!, date: true),
                _buildField("Gender", controllers["gender"]!),
                _buildField("Marital Status", controllers["maritalStatus"]!),
                _buildField("Present Address", controllers["presentAddress"]!),
                _buildField("Permanent Address", controllers["permanentAddress"]!),
                _buildField("Passport No.", controllers["passportNo"]!),
                _buildField("Emirate ID No.", controllers["emirateIdNo"]!),
                _buildField("EID Issue Date", controllers["eidIssue"]!, date: true),
                _buildField("EID Expiry Date", controllers["eidExpiry"]!, date: true),
                _buildField("Passport Issue Date", controllers["passportIssue"]!, date: true),
                _buildField("Passport Expiry Date", controllers["passportExpiry"]!, date: true),
                _buildField("Visa No.", controllers["visaNo"]!),
                _buildField("Visa Expiry Date", controllers["visaExpiry"]!, date: true),
                _buildField("Visa Type", controllers["visaType"]!),
                _buildField("Sponsor", controllers["sponsor"]!),
              ]),
              _buildSection("Job Detail", [
                _buildField("Position/Role", controllers["position"]!),
                _buildField("Wing", controllers["wing"]!),
                _buildField("Home/Local", controllers["homeLocal"]!),
                _buildField("Date of Joining", controllers["joinDate"]!, date: true),
                _buildField("Date of Retirement", controllers["retireDate"]!, date: true),
              ]),
              _buildSection("Contact Detail", [
                _buildField("Land Phone", controllers["landPhone"]!),
                _buildField("Mobile", controllers["mobile"]!),
                _buildField("Email Address", controllers["email"]!),
                _buildField("Alternative Mobile", controllers["altMobile"]!),
                _buildField("Botim", controllers["botim"]!),
                _buildField("WhatsApp", controllers["whatsapp"]!),
                _buildField("Emergency Contact", controllers["emergency"]!),
              ]),
              _buildSection("Salary Account Detail", [
                _buildField("Bank Name", controllers["bank"]!),
                _buildField("Account No.", controllers["accountNo"]!),
                _buildField("Account Holder's Name", controllers["accountName"]!),
                _buildField("IBAN No.", controllers["iban"]!),
              ]),
              _buildSection("Emergency Contact", [
                _buildField("Name", controllers["emergencyName"]!),
                _buildField("Relationship", controllers["emergencyRelation"]!),
                _buildField("Phone", controllers["emergencyPhone"]!),
                _buildField("Email", controllers["emergencyEmail"]!),
                _buildField("WhatsApp", controllers["emergencyWhatsapp"]!),
                _buildField("Botim", controllers["emergencyBotim"]!),
              ]),
              _buildSection("Family", [
                _buildField("Spouse Name", controllers["spouseName"]!),
                _buildField("No. of Children", controllers["children"]!),
              ]),
              for (int i = 0; i < childrenControllers.length; i++)
                _buildSection("Child ${i + 1}", [
                  _buildField("Name", childrenControllers[i]["name"]!),
                  _buildField("Gender", childrenControllers[i]["gender"]!),
                  _buildField("Date of Birth", childrenControllers[i]["dob"]!, date: true),
                  _buildField("Schooling Year", childrenControllers[i]["schoolingYear"]!),
                  _buildField("School", childrenControllers[i]["school"]!),
                ]),
              TextButton.icon(
                onPressed: _addChild,
                icon: const Icon(Icons.add),
                label: const Text("Add Child"),
              ),
              _buildSection("Document Uploads", [
                _buildFileUpload("Photo", photoFile, () => _pickFile('photo')),
                _buildFileUpload("Passport", passportFile, () => _pickFile('passport')),
                _buildFileUpload("Emirate ID", eidFile, () => _pickFile('eid')),
                _buildFileUpload("Visa", visaFile, () => _pickFile('visa')),
                _buildFileUpload("CV", cvFile, () => _pickFile('cv')),
                _buildFileUpload("Academic Certificates", certFile, () => _pickFile('cert')),
                _buildFileUpload("Reference Letter", refFile, () => _pickFile('ref')),
              ]),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.brandColor)),
        const SizedBox(height: 8),
        ...children,
      ],
    );
  }
}
