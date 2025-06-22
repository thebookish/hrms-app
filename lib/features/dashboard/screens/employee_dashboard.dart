import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';
import 'package:hrms_app/features/job_info/screens/job_info_screen.dart';
import 'package:hrms_app/features/leave_management/screens/leave_screen.dart';
import 'package:hrms_app/features/notifications/screens/notifcation_screen.dart';
import 'package:hrms_app/features/profile/screens/family_members_details.dart';
import 'package:hrms_app/features/profile/screens/view_profile.dart';
import 'package:hrms_app/features/salary/screens/salary_info_screen.dart';
import 'package:hrms_app/features/settings/screens/settings_screen.dart';
import 'package:hrms_app/features/sponsor/screens/sponsor_details_screen.dart';

class EmployeeDashboard extends ConsumerStatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  ConsumerState<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends ConsumerState<EmployeeDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final employeeAsync = ref.watch(employeeDataProvider);

    return employeeAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 40),
              const SizedBox(height: 10),
              const Text('Something went wrong', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(err.toString(), style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(employeeDataProvider),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandColor,
                ),
              ),
            ],
          ),
        ),
      ),

      data: (employee) => Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: AppColors.brandColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              // Index 0 — Dashboard cards
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        _DashboardCard(
                            title: 'My Profile',
                            icon: Icons.person_outline,
                            color: Colors.indigo,
                            status: employee.status ?? ''),
                        _DashboardCard(
                            title: 'Job Info',
                            icon: Icons.work_outline,
                            color: Colors.deepPurple,
                            status: employee.status ?? ''),
                        _DashboardCard(
                            title: 'Leave Management',
                            icon: Icons.beach_access,
                            color: Colors.teal,
                            status: employee.status ?? ''),
                        _DashboardCard(
                            title: 'Salary & Bank Info',
                            icon: Icons.account_balance_wallet_outlined,
                            color: Colors.green,
                            status: employee.status ?? ''),
                        _DashboardCard(
                            title: 'Family Members',
                            icon: Icons.family_restroom,
                            color: Colors.orange,
                            status: employee.status ?? ''),
                        _DashboardCard(
                            title: 'Sponsor Details',
                            icon: Icons.handshake_outlined,
                            color: Colors.blueGrey,
                            status: employee.status ?? ''),
                      ],
                    ),
                  ),
                ],
              ),

              // Index 1 — Notifications
              const NotificationScreen()
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          elevation: 10,
          child: const Icon(Icons.settings, size: 35, color: AppColors.brandColor),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 15.0,
          color: AppColors.brandColor,
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.dashboard_outlined,
                      size: 30,
                      color: _selectedIndex == 0 ? AppColors.accent : Colors.white),
                  onPressed: () => _onItemTapped(0),
                ),
                IconButton(
                  icon: Icon(Icons.notifications_active_outlined,
                      size: 30,
                      color: _selectedIndex == 1 ? AppColors.accent : Colors.white),
                  onPressed: () => _onItemTapped(1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final MaterialColor color;
  final String status;

  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isRestricted =
        title != 'My Profile' && title != 'Settings' && status.toLowerCase() != 'approved';

    return Opacity(
      opacity: isRestricted ? 0.5 : 1,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(16),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (isRestricted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Access restricted. Wait for approval.')),
              );
              return;
            }

            if (title == 'My Profile') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
            } else if (title == 'Leave Management') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LeaveScreen()));
            } else if (title == 'Job Info') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const JobInfoScreen()));
            } else if (title == 'Salary & Bank Info') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SalaryInfoScreen()));
            } else if (title == 'Family Members') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FamilyMembersScreen()));
            } else if (title == 'Sponsor Details') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EmployeeSponsorViewScreen()
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: AppColors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 36, color: color.shade700),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: color.shade800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
