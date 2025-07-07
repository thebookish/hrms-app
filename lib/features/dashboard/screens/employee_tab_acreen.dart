import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/dashboard/controllers/admin_provider.dart';
import 'package:hrms_app/features/employee_management/screens/edit_employee_screen.dart';
import 'package:hrms_app/features/employee_management/screens/pending_employee_details_screen.dart';

class EmployeeTabScreen extends ConsumerStatefulWidget {
  const EmployeeTabScreen({super.key});

  @override
  ConsumerState<EmployeeTabScreen> createState() => _EmployeeTabScreenState();
}

class _EmployeeTabScreenState extends ConsumerState<EmployeeTabScreen> {
  String _searchQuery = '';
  bool showVerificationRequests = false;

  @override
  Widget build(BuildContext context) {
    final provider = showVerificationRequests
        ? verificationRequestProvider
        : approvedEmployeesProvider;

    final employeeAsync = ref.watch(provider);

    return Column(
      children: [
        const SizedBox(height: 12),
        // — Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            decoration: InputDecoration(
              hintText: 'Search employee by name...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // — Toggle chips
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilterChip(
              label: const Text('Approved'),
              selected: !showVerificationRequests,
              onSelected: (_) => setState(() => showVerificationRequests = false),
              selectedColor: AppColors.brandColor.withOpacity(0.1),
              backgroundColor: AppColors.white,
            ),
            const SizedBox(width: 10),
            FilterChip(
              label: const Text('Pending Verification'),
              selected: showVerificationRequests,
              onSelected: (_) => setState(() => showVerificationRequests = true),
              selectedColor: Colors.orange.withOpacity(0.1),
            ),
          ],
        ),

        const SizedBox(height: 12),
        // — List
        Expanded(
          child: employeeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Something Went Wrong!')),
            data: (employees) {
              final filtered = employees.where((e) {
                final name = "${e.firstName} ${e.surname}".toLowerCase();
                return name.contains(_searchQuery);
              }).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text("No employees found."));
              }

              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(provider),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (_, idx) {
                    final emp = filtered[idx];
                    final firstName =
                    "${emp.firstName ?? ''} ${emp.surname ?? ''}".trim();
                    final status = emp.status ?? 'unknown';

                    if (status.toLowerCase() != 'approved') {
                      return Card(
                        color: AppColors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.brandColor,
                            child: Text(
                              firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(firstName, style: const TextStyle(color: AppColors.brandColor)),
                          subtitle: Text('Status: ${status.toUpperCase()}'),
                          onTap: () {
                            if (status.toLowerCase() == 'pending') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PendingEmployeeDetailsScreen(employee: emp),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }

                    // — Approved card
                    return Card(
                      color: AppColors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // — Avatar
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: AppColors.brandColor.withOpacity(0.8),
                              child: Text(
                                firstName.isNotEmpty ? firstName[0].toUpperCase() : '?',
                                style: const TextStyle(fontSize: 20, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // — Details section
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Row with name & join date
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(firstName,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      Text(
                                        "Joined: ${emp.joinDate ?? 'N/A'}",
                                        style: const TextStyle(fontSize: 11, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  // Position tag
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.brandColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(emp.position ?? '—',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.brandColor,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                  const SizedBox(height: 12),

                                  // Two-column details
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _detailRow("DOB:", emp.dob ?? '—'),
                                            _detailRow("Gender:", emp.gender ?? '—'),
                                            _detailRow("Sick Leave:", '${emp.sickLeave ?? 0}'),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            _detailRow("Contact:", emp.mobile ?? '—'),
                                            _detailRow("Nationality:", emp.presentAddress ?? '—'),
                                            _detailRow("Casual Leave:", '${emp.casualLeave ?? 0}'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // Leave balances
                                  Row(
                                    children: [
                                      _leaveBalanceCircle(emp.paidLeave ?? 0, 'Paid'),
                                      const SizedBox(width: 12),
                                      _leaveBalanceCircle(emp.sickLeave ?? 0, 'Sick'),
                                      const SizedBox(width: 12),
                                      _leaveBalanceCircle(emp.casualLeave ?? 0, 'Casual'),
                                    ],
                                  ),

                                  // Edit button
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditEmployeeScreen(employee: emp),
                                          ),
                                        );
                                      },
                                      child: const Text('EDIT',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.brandColor)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        '$label $value',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      ),
    );
  }

  Widget _leaveBalanceCircle(int count, String type) {
    return Column(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text('$count', style: const TextStyle(color: AppColors.primary)),
        ),
        const SizedBox(height: 4),
        Text(type, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
