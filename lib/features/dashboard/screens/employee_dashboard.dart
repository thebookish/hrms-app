import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';
import 'package:hrms_app/features/job_info/screens/job_info_screen.dart';
import 'package:hrms_app/features/leave_management/screens/leave_screen.dart';
import 'package:hrms_app/features/profile/screens/view_profile.dart';
import 'package:hrms_app/features/salary/screens/salary_info_screen.dart';
import 'package:hrms_app/features/settings/screens/settings_screen.dart';

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

  void _showNotificationsModal(BuildContext context, List<String> notifications) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...notifications.map(
                  (note) => Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const Icon(Icons.notifications, color: Colors.indigo),
                  title: Text(note),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employeeAsync = ref.watch(employeeProvider);

    return employeeAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (employee) => Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          title: const Text('Employee Dashboard'),
          centerTitle: true,
          backgroundColor: AppColors.brandColor,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () => _showNotificationsModal(context, employee.notifications),
            ),
          ],
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
                  children: const [
                    _DashboardCard(title: 'My Profile', icon: Icons.person_outline, color: Colors.indigo),
                    _DashboardCard(title: 'Job Info', icon: Icons.work_outline, color: Colors.deepPurple),
                    _DashboardCard(title: 'Leave Management', icon: Icons.beach_access, color: Colors.teal),
                    _DashboardCard(title: 'Salary & Bank Info', icon: Icons.account_balance_wallet_outlined, color: Colors.green),
                    _DashboardCard(title: 'Family Members', icon: Icons.family_restroom, color: Colors.orange),
                    _DashboardCard(title: 'Sponsor Details', icon: Icons.handshake_outlined, color: Colors.blueGrey),
                  ],
                ),
              ),
            ],
          ),

          // Index 1 — Placeholder for Profile or Alerts
          // const ProfileScreen()
        ],
      ),
    ),

    floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          shape: const CircleBorder(),
          backgroundColor: Colors.white,
          elevation: 10,
          child: const Icon(Icons.settings, size: 35,color: AppColors.brandColor,),

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
                  icon: Icon(Icons.dashboard_outlined,size: 30,
                      color: _selectedIndex == 0 ? AppColors.accent : Colors.white),
                  onPressed: () => {
                    _onItemTapped(0),
                 }
                ),
                IconButton(
                  icon: Icon(Icons.person,size: 30,
                      color: _selectedIndex == 1 ? AppColors.accent : Colors.white),
                  onPressed: () => {
                    _onItemTapped(1),
                    }
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

  const _DashboardCard({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (title == 'My Profile') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
          }
          if (title == 'Leave Management') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LeaveScreen()),
            );
          }
          if (title == 'Job Info') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const JobInfoScreen()),
            );
          }
          if (title == 'Salary & Bank Info') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SalaryInfoScreen()),
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
    );
  }
}
