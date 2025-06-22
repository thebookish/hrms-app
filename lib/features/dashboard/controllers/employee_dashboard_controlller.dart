import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/models/employee_model_new.dart';
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

final employeeDataProvider = FutureProvider<EmployeeModelNew>((ref) async {
  final user = ref.watch(loggedInUserProvider);

  try {
    return await EmployeeService().getEmployeeDataByEmail(user!.email);
  } catch (e) {
    if (e.toString().contains('User not found')) {
      return EmployeeModelNew(status: 'pending'); // or 'pending'
    }
    throw e;
  }
});