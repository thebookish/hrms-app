import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/dashboard/controllers/admin_provider.dart';
import 'package:hrms_app/features/sponsor/screens/add_sponsor_info_screen.dart';

class EmployeeListScreenSponsor extends ConsumerStatefulWidget {
  const EmployeeListScreenSponsor({super.key});

  @override
  ConsumerState<EmployeeListScreenSponsor> createState() => _ApprovedEmployeeListScreenState();
}

class _ApprovedEmployeeListScreenState extends ConsumerState<EmployeeListScreenSponsor> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final asyncEmployees = ref.watch(approvedEmployeesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Sponsor To Employee'),
        backgroundColor: AppColors.brandColor,
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
              decoration: InputDecoration(
                hintText: 'Search by employee name...',
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

          // Employee List
          Expanded(
            child: asyncEmployees.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
              data: (employees) {
                final filtered = employees.where((e) {
                  final name = (e.fullName ?? '').toLowerCase();
                  return name.contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('No matching employees.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: filtered.length,
                  itemBuilder: (_, index) {
                    final emp = filtered[index];
                    final name = emp.fullName ?? 'Unnamed';
                    final position = emp.jobType ?? 'Employee';

                    return Card(
                      color: AppColors.white,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.brandColor,
                          child: Text(name[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(name),
                        subtitle: Text(position),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddSponsorInfoScreen(employeeEmail: emp.email??''),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
