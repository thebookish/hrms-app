import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/dashboard/controllers/admin_provider.dart';

class EmployeeListCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeAsync = ref.watch(approvedEmployeesProvider);

    return employeeAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (employees) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Employees", style: TextStyle(color: AppColors.brandColor, fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: [
                ...employees.take(6).map((e) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: CircleAvatar(
                    backgroundColor: AppColors.brandColor,
                    child: Text(
                      (e.firstName != null && e.firstName!.isNotEmpty)
                          ? e.firstName![0].toUpperCase()
                          : '?',
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
                )),
                Container(
                  width: 40,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text("${employees.length}+", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}