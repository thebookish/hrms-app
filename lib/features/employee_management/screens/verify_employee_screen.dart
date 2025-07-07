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

  String gender = 'Male';
  String maritalStatus = 'Single';
  String visaType = 'Employment';

  List<Map<String, TextEditingController>> childrenControllers = [];

  File? photoFile, passportFile, eidFile, visaFile, cvFile, certFile, refFile;

  @override
  void initState() {
    super.initState();
    _addChild(); // Start with one child entry
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

  Widget _buildField(String label, TextEditingController controller,
      {bool date = false, bool required = true}) {
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
        validator: (value) =>
        required && (value == null || value.trim().isEmpty) ? 'Required' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      ),
    );
  }

  Widget _buildDocumentUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          "📎 Document Uploads",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.brandColor),
        ),
        const SizedBox(height: 12),
        _styledUploadTile("Photo", photoFile, () => _pickFile('photo'), required: true),
        _styledUploadTile("Passport", passportFile, () => _pickFile('passport'), required: true),
        _styledUploadTile("EID", eidFile, () => _pickFile('eid'), required: true),
        _styledUploadTile("Visa", visaFile, () => _pickFile('visa'), required: true),
        _styledUploadTile("CV", cvFile, () => _pickFile('cv'), required: true),
        _styledUploadTile("Certificates", certFile, () => _pickFile('cert')),
        _styledUploadTile("Reference Letter", refFile, () => _pickFile('ref')),
      ],
    );
  }

  Widget _styledUploadTile(String label, File? file, VoidCallback onPick, {bool required = false}) {
    final fileName = file != null ? file.path.split('/').last : 'No file selected';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Icon(
          required ? Icons.check_circle_outline : Icons.insert_drive_file_outlined,
          color: required ? Colors.green : Colors.grey,
        ),
        title: Text(label),
        subtitle: Text(fileName, overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.upload_file, color: AppColors.brandColor),
          onPressed: onPick,
        ),
      ),
    );
  }


  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if ([photoFile, passportFile, eidFile, visaFile, cvFile].any((f) => f == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload all required documents.")),
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

    request.fields['gender'] = gender;
    request.fields['maritalStatus'] = maritalStatus;
    request.fields['visaType'] = visaType;

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
      final response = await http.Response.fromStream(await request.send());
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Submitted Successfully")));
          Navigator.pop(context);
        }
      } else {
        throw Exception('Submission failed');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isSubmitting = false);
    }
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
              _buildSection("Personal Info", [
                _buildField("First Name", controllers["firstName"]!),
                _buildField("Surname", controllers["surname"]!),
                _buildField("Date of Birth", controllers["dob"]!, date: true),
                _buildDropdown("Gender", ['Male', 'Female', 'Other'], gender, (val) => setState(() => gender = val!)),
                _buildDropdown("Marital Status", ['Single', 'Married', 'Divorced'], maritalStatus, (val) => setState(() => maritalStatus = val!)),
                _buildField("Present Address", controllers["presentAddress"]!),
                _buildField("Permanent Address", controllers["permanentAddress"]!),
                _buildField("Passport No.", controllers["passportNo"]!),
                _buildField("Emirate ID", controllers["emirateIdNo"]!),
                _buildField("EID Issue", controllers["eidIssue"]!, date: true),
                _buildField("EID Expiry", controllers["eidExpiry"]!, date: true),
                _buildField("Passport Issue", controllers["passportIssue"]!, date: true),
                _buildField("Passport Expiry", controllers["passportExpiry"]!, date: true),
                _buildField("Visa No.", controllers["visaNo"]!),
                _buildField("Visa Expiry", controllers["visaExpiry"]!, date: true),
                _buildDropdown("Visa Type", ['Employment', 'Tourist', 'Resident'], visaType, (val) => setState(() => visaType = val!)),
                _buildField("Sponsor", controllers["sponsor"]!),
              ]),
              _buildSection("Job Info", [
                _buildField("Position", controllers["position"]!),
                _buildField("Wing", controllers["wing"]!),
                _buildField("Home/Local", controllers["homeLocal"]!),
                _buildField("Joining Date", controllers["joinDate"]!, date: true),
                _buildField("Retire Date", controllers["retireDate"]!, date: true),
              ]),
              _buildSection("Contact Info", [
                _buildField("Land Phone", controllers["landPhone"]!),
                _buildField("Mobile", controllers["mobile"]!),
                _buildField("Email", controllers["email"]!),
                _buildField("Alternative Mobile", controllers["altMobile"]!, required: false),
                _buildField("Botim", controllers["botim"]!, required: false),
                _buildField("WhatsApp", controllers["whatsapp"]!, required: false),
                _buildField("Emergency", controllers["emergency"]!),
              ]),
              _buildSection("Bank Info", [
                _buildField("Bank Name", controllers["bank"]!),
                _buildField("Account No.", controllers["accountNo"]!),
                _buildField("Account Holder", controllers["accountName"]!),
                _buildField("IBAN", controllers["iban"]!),
              ]),
              _buildSection("Emergency Contact", [
                _buildField("Name", controllers["emergencyName"]!),
                _buildField("Relation", controllers["emergencyRelation"]!),
                _buildField("Phone", controllers["emergencyPhone"]!),
                _buildField("Email", controllers["emergencyEmail"]!),
                _buildField("WhatsApp", controllers["emergencyWhatsapp"]!, required: false),
                _buildField("Botim", controllers["emergencyBotim"]!, required: false),
              ]),
              _buildSection("Family Info", [
                _buildField("Spouse Name", controllers["spouseName"]!, required: false),
                _buildField("No. of Children", controllers["children"]!, required: false),
              ]),
              for (int i = 0; i < childrenControllers.length; i++)
                _buildSection("Child ${i + 1}", [
                  _buildField("Name", childrenControllers[i]["name"]!, required: false),
                  _buildField("Gender", childrenControllers[i]["gender"]!, required: false),
                  _buildField("DOB", childrenControllers[i]["dob"]!, date: true, required: false),
                  _buildField("Schooling Year", childrenControllers[i]["schoolingYear"]!, required: false),
                  _buildField("School", childrenControllers[i]["school"]!, required: false),
                ]),
              TextButton.icon(
                onPressed: _addChild,
                icon: const Icon(Icons.add),
                label: const Text("Add Child"),
              ),
              _buildDocumentUploadSection(),
              // _buildSection("Documents", _buildDocumentUploadSection() as List<Widget>),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandColor,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
