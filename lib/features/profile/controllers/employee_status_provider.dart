import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/features/dashboard/controllers/admin_provider.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';

final currentEmployeeStatusProvider = Provider<String>((ref) {
  final employeeAsync = ref.watch(employeeProvider);
  final approvedAsync = ref.watch(approvedEmployeesProvider);
  final pendingAsync = ref.watch(verificationRequestProvider);

  String status = 'unverified';

  employeeAsync.whenData((employee) {
    final email = employee.email.trim();

    approvedAsync.whenData((list) {
      if (list.any((e) => e.email?.trim() == email)) {
        status = 'approved';
      }
    });

    pendingAsync.whenData((list) {
      if (list.any((e) => e.email?.trim() == email)) {
        status = 'pending';
      }
    });
    pendingAsync.whenData((list) {
      if (list.any((e) => e.email?.trim() == email)) {
        status = 'declined';
      }
    });
  });

  return status;
});
