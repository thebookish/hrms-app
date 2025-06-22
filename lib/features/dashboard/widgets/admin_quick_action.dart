import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/job_info/screens/approved_employee_screen_for_task.dart';
import 'package:hrms_app/features/job_info/screens/assign_task_screen.dart';
import 'package:hrms_app/features/leave_management/screens/leave_management_screen.dart';
import 'package:hrms_app/features/notifications/screens/hr_notifications_screen.dart';
import 'package:hrms_app/features/salary/screens/employee_list_for_salary_screen.dart';
import 'package:hrms_app/features/sponsor/screens/add_sponsor_info_screen.dart';
import 'package:hrms_app/features/sponsor/screens/employee_list_screen_sponsor.dart';
// Import other target screens as needed

class AdminQuickActionsSection extends StatefulWidget {
  const AdminQuickActionsSection({super.key});

  @override
  State<AdminQuickActionsSection> createState() => _AdminQuickActionsSectionState();
}

class _AdminQuickActionsSectionState extends State<AdminQuickActionsSection> {
  bool isPendingSelected = true;

  late final List<_AdminActionItem> items;

  @override
  void initState() {
    super.initState();

    items = [
      _AdminActionItem(
        title: 'Leave\nManagement',
        icon: Icons.beach_access,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminLeaveManagementScreen()),
          );
        },
      ),
      _AdminActionItem(
        title: 'Task\nManagement',
        icon: Icons.task,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ApprovedEmployeeListScreen(),
            ),
          );

        },
      ),
      _AdminActionItem(
        title: 'Salary\nManagement',
        icon: Icons.attach_money,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ApprovedEmployeeListScreenTwo(),
            ),
          );
        },
      ),
      _AdminActionItem(
        title: 'Reports',
        icon: Icons.bar_chart,
        onTap: () {
          // TODO: Navigate to Reports Screen
        },
      ),
      _AdminActionItem(
        title: 'Notifications',
        icon: Icons.notification_important_sharp,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => HRNotificationScreen(),
            ),
          );
        },
      ),
      _AdminActionItem(
        title: 'Sponsors',
        icon: Icons.handshake,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EmployeeListScreenSponsor(),
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Icons Grid
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Wrap(
            spacing: 12,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            children: items.map((item) {
              return _QuickBox(
                icon: item.icon,
                label: item.title,
                onTap: item.onTap,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 24),

        // Toggle Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              _ToggleTab(
                label: 'Pending Requests',
                isSelected: isPendingSelected,
                onTap: () => setState(() => isPendingSelected = true),
              ),
              _ToggleTab(
                label: 'Past Requests',
                isSelected: !isPendingSelected,
                onTap: () => setState(() => isPendingSelected = false),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickBox({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.brandColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: AppColors.brandColor, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.brandColor : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminActionItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  _AdminActionItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
