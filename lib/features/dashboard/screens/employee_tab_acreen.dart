import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/dashboard/controllers/admin_provider.dart';
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
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
        Expanded(
          child: employeeAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (employees) {
              final filtered = employees.where((e) {
                final name = e.fullName ?? '';
                return name.toLowerCase().contains(_searchQuery);
              }).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text("No employees found."));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(provider);
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (_, index) {
                    final emp = filtered[index];
                    final name = emp.fullName?.trim().isNotEmpty == true
                        ? emp.fullName!
                        : 'Unnamed';
                    final contact = emp.phone ?? 'No contact';
                    final status = emp.status ?? 'unknown';

                    return status == 'approved'
                        ? _buildApprovedCard(emp)
                        : Card(
                      color: AppColors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.brandColor,
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '?',
                            style: const TextStyle(color: AppColors.white),
                          ),
                        ),
                        title: Text(name, style: const TextStyle(color: AppColors.brandColor)),
                        subtitle: Text('Contact: $contact'),
                        trailing: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: status == 'pending'
                                ? Colors.orange
                                : status == 'declined'
                                ? Colors.red
                                : Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
                          if (status == 'pending') {
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
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildApprovedCard(emp) {
    final name = emp.fullName ?? 'Unnamed';
    final endDate = emp.endDate ?? 'Unknown';
    final position = emp.jobType ?? 'Employee';
    final salary = emp.salary ?? 'N/A';
    final dob = emp.dob ?? 'N/A';
    final gender = emp.gender ?? 'N/A';
    final contact = emp.phone ?? 'N/A';
    final emergency = emp.emergency ?? 'N/A';
    final address = emp.nationality ?? 'N/A';

    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Initial
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.brandColor.withOpacity(0.8),
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),

            // Info Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name & Join Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text("Joined on\n$endDate",
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Role/Title Tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.brandColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(position,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.brandColor,
                          fontWeight: FontWeight.w500,
                        )),
                  ),

                  const SizedBox(height: 12),

                  // Details
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _detailRow("Salary", "$salary AED"),
                            _detailRow("DOB", dob),
                            _detailRow("Gender", gender),
                            // _detailRow("Emergency:", emergency),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _detailRow("Contact", contact),
                            _detailRow("Address", address),
                          ],
                        ),
                      ),

                    ],
                  ),

                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Navigate to edit screen
                      },
                      child: const Text("EDIT", style: TextStyle(fontWeight: FontWeight.w500, color: AppColors.brandColor)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
          ),
        ],
      ),
    );
  }
}
