import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/services/leave_services.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/leave_management/models/leave_model.dart';

final leaveListProvider = FutureProvider<List<LeaveModel>>((ref) {
  final user = ref.watch(loggedInUserProvider);
  if (user == null) throw Exception('User not logged in');
  return LeaveService().fetchLeaves(email: user.email); // ✅ required call
});
