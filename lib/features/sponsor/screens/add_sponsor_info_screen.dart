// features/sponsor/screens/add_sponsor_info_screen.dart

import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/notification_service.dart';
import 'package:hrms_app/core/services/sponsor_service.dart';
import 'package:hrms_app/features/sponsor/model/sponsor_model.dart';

class AddSponsorInfoScreen extends StatefulWidget {
  final String employeeEmail;
  const AddSponsorInfoScreen({super.key, required this.employeeEmail});

  @override
  State<AddSponsorInfoScreen> createState() => _AddSponsorInfoScreenState();
}

class _AddSponsorInfoScreenState extends State<AddSponsorInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _industry = TextEditingController();
  final TextEditingController _contactPerson = TextEditingController();
  // final TextEditingController _email = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _logoUrl = TextEditingController();

  bool _isSubmitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final sponsorData = SponsorModel(
      name: _name.text.trim(),
      industry: _industry.text.trim(),
      contactPerson: _contactPerson.text.trim(),
      email: widget.employeeEmail,
      phone: _phone.text.trim(),
      address: _address.text.trim(),
      logoUrl: _logoUrl.text.trim(),
    );

    try {
      await SponsorService().addSponsor(sponsorData);
      await NotificationService().sendNotification(title: 'Sponsor Info Updated!', message: 'Your sponsor info just updated. Check it now.', receiverEmail: widget.employeeEmail);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sponsor info added successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildField(TextEditingController controller, String label, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sponsor Info'),
        backgroundColor: AppColors.brandColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildField(_name, "Sponsor Name"),
              _buildField(_industry, "Industry"),
              _buildField(_contactPerson, "Contact Person"),
              // _buildField(_email, "Email", type: TextInputType.emailAddress),
              _buildField(_phone, "Phone", type: TextInputType.phone),
              _buildField(_address, "Address"),
              _buildField(_logoUrl, "Logo URL"),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _isSubmitting ? null : _submit,
                icon: const Icon(Icons.save),
                label: Text(_isSubmitting ? 'Saving...' : 'Save Sponsor Info'),
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
}
