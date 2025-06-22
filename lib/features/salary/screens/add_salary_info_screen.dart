import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/notification_service.dart';
import 'package:hrms_app/core/services/salary_services.dart';
import 'package:hrms_app/features/salary/models/salary_model.dart';

class AddSalaryInfoScreen extends StatefulWidget {
  final String? employeeEmail;

  const AddSalaryInfoScreen({super.key, required this.employeeEmail});

  @override
  State<AddSalaryInfoScreen> createState() => _AddSalaryInfoScreenState();
}

class _AddSalaryInfoScreenState extends State<AddSalaryInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _basicController = TextEditingController();
  final TextEditingController _hraController = TextEditingController();
  final TextEditingController _allowanceController = TextEditingController();
  final TextEditingController _deductionController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  String _paymentStatus = 'Paid';
  final TextEditingController _incrementDateController = TextEditingController();
  final TextEditingController _newSalaryController = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExistingSalary();
  }

  Future<void> _loadExistingSalary() async {
    try {
      final data = await SalaryService().getSalaryInfo(widget.employeeEmail!);
      final model = SalaryModel.fromJson(data);

      _basicController.text = model.basic.toStringAsFixed(2);
      _hraController.text = model.hra.toStringAsFixed(2);
      _allowanceController.text = model.allowance.toStringAsFixed(2);
      _deductionController.text = model.deduction.toStringAsFixed(2);

      if (model.paymentHistory.isNotEmpty) {
        _monthController.text = model.paymentHistory.first.month;
        _amountController.text = model.paymentHistory.first.amount.toStringAsFixed(2);
        _paymentStatus = model.paymentHistory.first.status;
      }

      if (model.upcomingIncrements.isNotEmpty) {
        _incrementDateController.text = model.upcomingIncrements.first.effectiveDate;
        _newSalaryController.text = model.upcomingIncrements.first.newSalary.toStringAsFixed(2);
      }
    } catch (_) {
      // It's okay if no salary exists yet
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final salaryData = {
      'email': widget.employeeEmail,
      'basic': double.parse(_basicController.text),
      'hra': double.parse(_hraController.text),
      'allowance': double.parse(_allowanceController.text),
      'deduction': double.parse(_deductionController.text),
      'paymentHistory': [
        {
          'month': _monthController.text.trim(),
          'amount': double.parse(_amountController.text),
          'status': _paymentStatus,
        },
      ],
      'upcomingIncrements': [
        {
          'effectiveDate': _incrementDateController.text.trim(),
          'newSalary': double.parse(_newSalaryController.text),
        },
      ],
    };

    try {
      await SalaryService().addSalaryInfo(salaryData);

      await NotificationService().sendNotification(
        title: 'New Salary Info Added',
        message: 'Your salary details have been updated. Check now.',
        receiverEmail: widget.employeeEmail!,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Salary info added')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Salary Info'),
        backgroundColor: AppColors.brandColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 15),
              _buildTextField(_basicController, 'Basic Salary'),
              _buildTextField(_hraController, 'HRA'),
              _buildTextField(_allowanceController, 'Allowance'),
              _buildTextField(_deductionController, 'Deduction'),

              const SizedBox(height: 24),
              const Text('Payment History', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(_monthController, 'Month (e.g. May 2025)'),
              _buildTextField(_amountController, 'Amount'),
              DropdownButtonFormField<String>(
                value: _paymentStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Paid', 'Pending']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setState(() => _paymentStatus = val!),
              ),

              const SizedBox(height: 24),
              const Text('Upcoming Increment', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(_incrementDateController, 'Effective Date (e.g. 2025-08-01)'),
              _buildTextField(_newSalaryController, 'New Salary'),

              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save),
                label: const Text('Save Salary Info'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }
}
