// imports (same as before)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/models/employee_model_new.dart';
import 'package:hrms_app/core/services/employee_services.dart';

class EditEmployeeScreen extends ConsumerStatefulWidget {
  final EmployeeModelNew employee;

  const EditEmployeeScreen({super.key, required this.employee});

  @override
  ConsumerState<EditEmployeeScreen> createState() => _EditEmployeeScreenState();
}

class _EditEmployeeScreenState extends ConsumerState<EditEmployeeScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};

  late AnimationController _animationController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    final data = widget.employee;
    final fields = {
      "firstName": data.firstName,
      "surname": data.surname,
      "dob": data.dob,
      "gender": data.gender,
      "maritalStatus": data.maritalStatus,
      "presentAddress": data.presentAddress,
      "permanentAddress": data.permanentAddress,
      "passportNo": data.passportNo,
      "emirateIdNo": data.emirateIdNo,
      "eidIssue": data.eidIssue,
      "eidExpiry": data.eidExpiry,
      "passportIssue": data.passportIssue,
      "passportExpiry": data.passportExpiry,
      "visaNo": data.visaNo,
      "visaExpiry": data.visaExpiry,
      "visaType": data.visaType,
      "sponsor": data.sponsor,
      "position": data.position,
      "wing": data.wing,
      "homeLocal": data.homeLocal,
      "joinDate": data.joinDate,
      "retireDate": data.retireDate,
      "landPhone": data.landPhone,
      "mobile": data.mobile,
      "email": data.email,
      "altMobile": data.altMobile,
      "botim": data.botim,
      "whatsapp": data.whatsapp,
      "emergency": data.emergency,
      "bank": data.bank,
      "accountNo": data.accountNo,
      "accountName": data.accountName,
      "iban": data.iban,
      "emergencyName": data.emergencyName,
      "emergencyRelation": data.emergencyRelation,
      "emergencyPhone": data.emergencyPhone,
      "emergencyEmail": data.emergencyEmail,
      "emergencyBotim": data.emergencyBotim,
      "emergencyWhatsapp": data.emergencyWhatsapp,
      "spouseName": data.spouseName,
      // "children": data.childDetails,
      "sickLeave": (data.sickLeave ?? 0).toString(),
      "casualLeave": (data.casualLeave ?? 0).toString(),
      "paidLeave": (data.paidLeave ?? 0).toString(),
    };

    for (var key in fields.keys) {
      _controllers[key] = TextEditingController(text: fields[key] ?? '');
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.employee.copyWith(
      firstName: _controllers["firstName"]?.text,
      surname: _controllers["surname"]?.text,
      dob: _controllers["dob"]?.text,
      gender: _controllers["gender"]?.text,
      maritalStatus: _controllers["maritalStatus"]?.text,
      presentAddress: _controllers["presentAddress"]?.text,
      permanentAddress: _controllers["permanentAddress"]?.text,
      passportNo: _controllers["passportNo"]?.text,
      emirateIdNo: _controllers["emirateIdNo"]?.text,
      eidIssue: _controllers["eidIssue"]?.text,
      eidExpiry: _controllers["eidExpiry"]?.text,
      passportIssue: _controllers["passportIssue"]?.text,
      passportExpiry: _controllers["passportExpiry"]?.text,
      visaNo: _controllers["visaNo"]?.text,
      visaExpiry: _controllers["visaExpiry"]?.text,
      visaType: _controllers["visaType"]?.text,
      sponsor: _controllers["sponsor"]?.text,
      position: _controllers["position"]?.text,
      wing: _controllers["wing"]?.text,
      homeLocal: _controllers["homeLocal"]?.text,
      joinDate: _controllers["joinDate"]?.text,
      retireDate: _controllers["retireDate"]?.text,
      landPhone: _controllers["landPhone"]?.text,
      mobile: _controllers["mobile"]?.text,
      email: _controllers["email"]?.text,
      altMobile: _controllers["altMobile"]?.text,
      botim: _controllers["botim"]?.text,
      whatsapp: _controllers["whatsapp"]?.text,
      emergency: _controllers["emergency"]?.text,
      bank: _controllers["bank"]?.text,
      accountNo: _controllers["accountNo"]?.text,
      accountName: _controllers["accountName"]?.text,
      iban: _controllers["iban"]?.text,
      emergencyName: _controllers["emergencyName"]?.text,
      emergencyRelation: _controllers["emergencyRelation"]?.text,
      emergencyPhone: _controllers["emergencyPhone"]?.text,
      emergencyEmail: _controllers["emergencyEmail"]?.text,
      emergencyBotim: _controllers["emergencyBotim"]?.text,
      emergencyWhatsapp: _controllers["emergencyWhatsapp"]?.text,
      spouseName: _controllers["spouseName"]?.text,
      // children: _controllers["children"]?.text,
      sickLeave: int.tryParse(_controllers["sickLeave"]?.text ?? '0'),
      casualLeave: int.tryParse(_controllers["casualLeave"]?.text ?? '0'),
      paidLeave: int.tryParse(_controllers["paidLeave"]?.text ?? '0'),
    );

    try {
      await EmployeeService().updateEmployee(updated);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Employee updated successfully.")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Update Failed")));
    }
  }

  Widget _buildField(String key, String label,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: _controllers[key],
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (val) => val == null || val.trim().isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Edit Employee"),
          backgroundColor: AppColors.brandColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Personal Info",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _buildField("firstName", "First Name"),
                _buildField("surname", "Surname"),
                _buildField("dob", "DOB"),
                _buildField("gender", "Gender"),
                _buildField("maritalStatus", "Marital Status"),
                _buildField("presentAddress", "Present Address"),
                _buildField("permanentAddress", "Permanent Address"),
                _buildField("passportNo", "Passport No"),
                _buildField("emirateIdNo", "Emirate ID No"),
                _buildField("eidIssue", "EID Issue"),
                _buildField("eidExpiry", "EID Expiry"),
                _buildField("passportIssue", "Passport Issue"),
                _buildField("passportExpiry", "Passport Expiry"),
                _buildField("visaNo", "Visa No"),
                _buildField("visaExpiry", "Visa Expiry"),
                _buildField("visaType", "Visa Type"),
                _buildField("sponsor", "Sponsor"),

                const SizedBox(height: 12),
                const Text("Job Info", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildField("position", "Position"),
                _buildField("wing", "Wing"),
                _buildField("homeLocal", "Home/Local"),
                _buildField("joinDate", "Join Date"),
                _buildField("retireDate", "Retirement Date"),

                const SizedBox(height: 12),
                const Text("Contact Info", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildField("mobile", "Mobile"),
                _buildField("altMobile", "Alt Mobile"),
                _buildField("email", "Email", type: TextInputType.emailAddress),
                _buildField("botim", "Botim"),
                _buildField("whatsapp", "WhatsApp"),
                _buildField("emergency", "Emergency Contact"),

                const SizedBox(height: 12),
                const Text("Salary Info", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildField("bank", "Bank"),
                _buildField("accountNo", "Account No"),
                _buildField("accountName", "Account Name"),
                _buildField("iban", "IBAN"),

                const SizedBox(height: 12),
                const Text("Emergency Contact", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildField("emergencyName", "Name"),
                _buildField("emergencyRelation", "Relation"),
                _buildField("emergencyPhone", "Phone"),
                _buildField("emergencyEmail", "Email"),
                _buildField("emergencyWhatsapp", "WhatsApp"),
                _buildField("emergencyBotim", "Botim"),

                const SizedBox(height: 12),
                const Text("Family Info", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildField("spouseName", "Spouse Name"),
                // _buildField("children", "No. of Children"),

                const SizedBox(height: 12),
                const Text("Leave Balances", style: TextStyle(fontWeight: FontWeight.bold)),
                _buildField("sickLeave", "Sick Leave", type: TextInputType.number),
                _buildField("casualLeave", "Casual Leave", type: TextInputType.number),
                _buildField("paidLeave", "Paid Leave", type: TextInputType.number),

                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _saveChanges,
                  icon: const Icon(Icons.save),
                  label: const Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandColor,
                    minimumSize: const Size.fromHeight(48),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
