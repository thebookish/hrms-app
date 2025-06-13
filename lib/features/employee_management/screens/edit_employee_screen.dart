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

class _EditEmployeeScreenState extends ConsumerState<EditEmployeeScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _contactController;
  late TextEditingController _jobTypeController;
  late TextEditingController _salaryController;
  late TextEditingController _leaveBalanceController;
  late TextEditingController sickLeaveController;
  late TextEditingController casualLeaveController;
  late TextEditingController paidLeaveController;
  late AnimationController _animationController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employee.fullName);
    _contactController = TextEditingController(text: widget.employee.phone);
    _jobTypeController = TextEditingController(text: widget.employee.jobType);
    _salaryController = TextEditingController(text: widget.employee.salary);
    _leaveBalanceController = TextEditingController();
    sickLeaveController = TextEditingController(text: (widget.employee.sickLeave ?? 0).toString());
    casualLeaveController = TextEditingController(text: (widget.employee.casualLeave ?? 0).toString());
    paidLeaveController = TextEditingController(text: (widget.employee.paidLeave ?? 0).toString());

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeIn = CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _jobTypeController.dispose();
    _salaryController.dispose();
    _leaveBalanceController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedEmployee = widget.employee.copyWith(
        fullName: _nameController.text,
        phone: _contactController.text,
        jobType: _jobTypeController.text,
        salary: _salaryController.text,
        sickLeave: int.tryParse(sickLeaveController.text) ?? 0,
        casualLeave: int.tryParse(casualLeaveController.text) ?? 0,
        paidLeave: int.tryParse(paidLeaveController.text) ?? 0,
      );

      await EmployeeService().updateEmployee(updatedEmployee);

      // if (_leaveBalanceController.text.trim().isNotEmpty) {
      //   await EmployeeService().addLeaveBalance(widget.employee.email!, int.parse(_leaveBalanceController.text));
      // }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee updated successfully')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeIn,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Employee'),
          backgroundColor: AppColors.brandColor,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildTextField(_nameController, 'Full Name'),
                _buildTextField(_contactController, 'Phone'),
                _buildTextField(_jobTypeController, 'Job Type'),
                _buildTextField(_salaryController, 'Salary (AED)', keyboardType: TextInputType.number),
                const Text("Leave Balances", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                _buildTextField(sickLeaveController, "Sick Leave", keyboardType: TextInputType.number),
                _buildTextField( casualLeaveController, "Casual Leave",keyboardType: TextInputType.number),
                _buildTextField( paidLeaveController, "Paid Leave",keyboardType:TextInputType.number),
                const SizedBox(height: 24),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Save Changes"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandColor,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _saveChanges,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
