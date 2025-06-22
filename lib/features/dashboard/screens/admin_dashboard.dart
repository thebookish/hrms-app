import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/features/dashboard/controllers/admin_provider.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';
import 'package:hrms_app/features/dashboard/screens/employee_tab_acreen.dart';
import 'package:hrms_app/features/dashboard/widgets/admin_quick_action.dart';
import 'package:hrms_app/features/dashboard/widgets/employee_list_card.dart';
import 'package:hrms_app/features/dashboard/widgets/header_card.dart';
import 'package:hrms_app/features/dashboard/widgets/salary_chart.dart';
import 'package:hrms_app/features/dashboard/widgets/schedule_card.dart';
import '../../../core/constants/app_colors.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({super.key});

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _onRefresh() async {
    ref.invalidate(approvedEmployeesProvider);
    ref.invalidate(verificationRequestProvider);
    // ref.invalidate(employeeProvider);
    // Add any other providers you'd like to refresh here
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.brandColor,
        elevation: 0,
        title: const Text('Dashboard',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: const [
          Icon(Icons.notifications_none, color: Colors.white),
          SizedBox(width: 16),
        ],
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.dashboard_customize_outlined, color: Colors.white),
        ),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: AppColors.brandColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: AppColors.white,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), label: 'Employees'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                HeaderCard(),
                const SizedBox(height: 16),
                // EmployeeListCard(),
                // const SizedBox(height: 16),
                ScheduleCard(),
                const SizedBox(height: 16),
               const AdminQuickActionsSection(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      case 1:
        return const EmployeeTabScreen();
      case 2:
        return const Center(child: Text('Settings (Coming Soon)'));
      default:
        return const SizedBox.shrink();
    }
  }
}
