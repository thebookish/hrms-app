import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/services/employee_services.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import '../../../core/models/employee_model.dart';

final employeeProvider = FutureProvider<EmployeeModel>((ref) {
  final user = ref.watch(loggedInUserProvider);

  if (user == null) {
    throw Exception('User not logged in');
  }

  return EmployeeService().getEmployeeByEmail(user.email);
});
