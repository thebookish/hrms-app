// features/job_info/screens/job_info_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/task_services.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';
import 'package:hrms_app/features/job_info/model/job_info_model.dart';
import 'package:hrms_app/features/job_info/model/task_model.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/settings/providers/theme_provider.dart';
import 'package:intl/intl.dart';

class JobInfoScreen extends ConsumerStatefulWidget {
  const JobInfoScreen({super.key});

  @override
  ConsumerState<JobInfoScreen> createState() => _JobInfoScreenState();
}

class _JobInfoScreenState extends ConsumerState<JobInfoScreen> {
  late JobInfoModel jobInfo;
  List<TaskModel> tasks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobInfo();
  }

  Future<void> _loadJobInfo() async {
    try {
      final employeeAsync = ref.read(employeeDataProvider);

      employeeAsync.whenData((employee) async {
        final loadedTasks = await TaskService().getUserTasks(employee.email??'');

        jobInfo = JobInfoModel(
          title: employee.position ?? 'N/A',
          department: employee.wing ?? 'N/A',
          // supervisor: employee.sponsor ?? 'N/A',
          history: [
            if (employee.joinDate != null)
              'Joined on ${DateFormat.yMMMMd().format(DateTime.parse(employee.joinDate!))}',
            if (employee.retireDate != null)
              'Retirement Date: ${DateFormat.yMMMMd().format(DateTime.parse(employee.retireDate!))}',
            if (employee.homeLocal != null && employee.homeLocal!.isNotEmpty)
              'Home/Local: ${employee.homeLocal}',
          ],
        );

        setState(() {
          tasks = loadedTasks;
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        tasks = [];
        isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading job info')));
    }
  }



  Future<void> _toggleTaskCompletion(String id) async {
    final user = ref.read(loggedInUserProvider)!;
    try {
      await TaskService().toggleTaskCompletion(id, user.email);
      await _loadJobInfo();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Toggle failed')));
    }
  }

  void _updateTaskStatus(String id, String status) async {
    final user = ref.read(loggedInUserProvider)!;
    try {
      await TaskService().updateTaskStatus(id, user.email, status);
      await _loadJobInfo();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Update failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.read(themeModeProvider.notifier).state;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Info & Tasks'),
        backgroundColor: AppColors.brandColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _loadJobInfo,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _sectionTitle('Position Details',themeMode),
            _infoCard([
              _buildInfoTile(Icons.work_outline, 'Title', jobInfo.title,themeMode),
              _buildInfoTile(Icons.apartment, 'Department', jobInfo.department,themeMode),
              // _buildInfoTile(Icons.supervisor_account, 'Supervisor', jobInfo.supervisor),
            ],themeMode),
            const SizedBox(height: 24),
            _sectionTitle('Employment History',themeMode),
            _historyCard(jobInfo.history,themeMode),
            const SizedBox(height: 24),
            _sectionTitle('Assigned Tasks',themeMode),
            ...tasks.map((t) => _buildTaskCard(t,themeMode)).toList(),
          ],
        ),
      ),
    );
  }
  Widget _sectionTitle(String text, themeMode) {
    return Text(
      text,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: themeMode==ThemeMode.dark?AppColors.white:AppColors.brandColor),
    );
  }

  Widget _infoCard(List<Widget> children,themeMode) {
    return Card(
      color:themeMode==ThemeMode.dark?Colors.white12:AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value,themeMode) {
    return ListTile(
      leading: Icon(icon, color: themeMode==ThemeMode.dark?Colors.white:AppColors.brandColor,),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, )),
      subtitle: Text(value, style: const TextStyle(fontSize: 15,)),
    );
  }

  Widget _historyCard(List<String> history,themeMode) {
    return Card(
      elevation: 2,
      color: themeMode==ThemeMode.dark?Colors.white12:AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: history.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 8, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(child: Text(e, style: const TextStyle(fontSize: 15))),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task,themeMode) {
    Color priorityColor;
    switch (task.priority) {
      case 'High':
        priorityColor = Colors.redAccent;
        break;
      case 'Medium':
        priorityColor = Colors.orangeAccent;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Card(
      color: themeMode==ThemeMode.dark?Colors.white12:AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(task.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: task.status == 'Completed'
                        ? Colors.green[100]
                        : task.status == 'In Progress'
                        ? Colors.blue[100]
                        : Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    task.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: task.status == 'Completed'
                          ? Colors.green[800]
                          : task.status == 'In Progress'
                          ? Colors.blue[800]
                          : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text('Deadline: ${DateFormat.yMMMd().format(DateTime.parse(task.deadline))}', style: const TextStyle(fontSize: 13)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: priorityColor.withOpacity(0.1),
                    border: Border.all(color: priorityColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Priority: ${task.priority}',
                    style:
                    TextStyle(fontSize: 12, color: priorityColor, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: task.isCompleted ? 1.0 : 0.5,
              color: themeMode==ThemeMode.dark?Colors.green:AppColors.brandColor,
              backgroundColor: Colors.grey[300],
            ),
            Row(
              children: [
                Checkbox(
                  activeColor: themeMode==ThemeMode.dark?Colors.white12:AppColors.brandColor,
                  value: task.isCompleted,
                  onChanged: (_) => _toggleTaskCompletion(task.id),
                ),
                const Text('Mark as Completed'),
                const Spacer(),
                DropdownButton<String>(
                  value: task.status,
                  items: ['Pending', 'In Progress', 'Completed']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null && val != task.status) {
                      _updateTaskStatus(task.id, val);
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}
