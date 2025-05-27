import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/employee_services.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _positionController;
  late TextEditingController _departmentController;
  bool _isLoading = false;
  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _positionController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _selectedImage = File(picked.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final employeeAsync = ref.watch(employeeProvider);

    return employeeAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
      data: (employee) {
        _nameController = TextEditingController(text: employee.name);
        _phoneController = TextEditingController(text: employee.phone);
        _positionController = TextEditingController(text: employee.position);
        _departmentController = TextEditingController(text: employee.department);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            backgroundColor: AppColors.primary,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary,
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (employee.profilePic != null &&
                          employee.profilePic!.isNotEmpty)
                          ? NetworkImage(employee.profilePic!)
                          : null,
                      child: (_selectedImage == null &&
                          (employee.profilePic == null ||
                              employee.profilePic!.isEmpty))
                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, size: 18, color: Colors.indigo),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildField('Name', _nameController),
              _buildField('Phone', _phoneController),
              _buildField('Position', _positionController),
              _buildField('Department', _departmentController),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  setState(() => _isLoading = true);
                  try {
                    // 1. Update profile fields
                    await EmployeeService().updateEmployeeProfile(
                      email: employee.email,
                      updates: {
                        'name': _nameController.text.trim(),
                        'phone': _phoneController.text.trim(),
                        'position': _positionController.text.trim(),
                        'department': _departmentController.text.trim(),
                      },
                    );

                    // 2. Upload profile picture if selected
                    if (_selectedImage != null) {
                      final prefs = await SharedPreferences.getInstance();
                      final token = prefs.getString('auth_token');
                      if (token != null) {
                        await EmployeeService().uploadProfilePic(email: employee.email, _selectedImage!, token);
                      }
                    }

                    if (mounted) {
                      ref.invalidate(employeeProvider); // refresh dashboard/profile
                      Navigator.pop(context);
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Error: $e')));
                  } finally {
                    setState(() => _isLoading = false);
                  }
                },
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save Changes'),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
