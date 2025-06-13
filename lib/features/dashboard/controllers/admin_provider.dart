import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/models/employee_model.dart';
import 'package:hrms_app/core/models/employee_model_new.dart';
import 'package:hrms_app/core/services/admin_services.dart';

final employeeListProvider = FutureProvider<List<EmployeeModel>>((ref) {
  return AdminService().getEmployees();
});

final approvedEmployeesProvider = FutureProvider<List<EmployeeModelNew>>((ref) async {
  return AdminService().getApprovedEmployees();
});

final verificationRequestProvider = FutureProvider<List<EmployeeModelNew>>((ref) async {
  return AdminService().getPendingEmployees();
});

