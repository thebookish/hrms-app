import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';
import 'package:hrms_app/features/profile/screens/view_profile.dart';
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
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsScreen()),
      );
    }
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
          backgroundColor: Colors.indigo,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () => _showNotificationsModal(context, employee.notifications),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${employee.name} 👋',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
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
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Alerts'),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Settings'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
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
    return GestureDetector(
      onTap: () {
        if (title == 'My Profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProfileScreen()),
          );
        }

      },
      child: Container(
        decoration: BoxDecoration(
          color: color.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color.shade700),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color.shade700)),
          ],
        ),
      ),
    );
  }
}
