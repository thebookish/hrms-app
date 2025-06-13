import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/job_info/model/job_info_model.dart';
import 'package:hrms_app/features/job_info/model/task_model.dart';

class JobInfoScreen extends ConsumerStatefulWidget {
  const JobInfoScreen({super.key});

  @override
  ConsumerState<JobInfoScreen> createState() => _JobInfoScreenState();
}

class _JobInfoScreenState extends ConsumerState<JobInfoScreen> {
  late JobInfoModel jobInfo;
  late List<TaskModel> tasks;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadJobInfo();
  }

  Future<void> _loadJobInfo() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      jobInfo = JobInfoModel(
        title: 'Software Engineer',
        department: 'Product Development',
        supervisor: 'Ms. Jane Smith',
        history: [
          'Joined on March 1, 2022',
          'Promoted to Software Engineer on March 1, 2023',
          'Assigned to Project Phoenix in May 2024',
        ],
      );

      tasks = [
        TaskModel(
          id: 'T-101',
          title: 'Develop Authentication Module',
          deadline: '2025-06-15',
          isCompleted: false,
          priority: 'High',
          status: 'In Progress',
        ),
        TaskModel(
          id: 'T-102',
          title: 'Code Review for Sprint 5',
          deadline: '2025-06-10',
          isCompleted: true,
          priority: 'Medium',
          status: 'Completed',
        ),
        TaskModel(
          id: 'T-103',
          title: 'Update Documentation',
          deadline: '2025-06-20',
          isCompleted: false,
          priority: 'Low',
          status: 'Pending',
        ),
        TaskModel(
          id: 'T-104',
          title: 'Client Feedback Implementation',
          deadline: '2025-06-12',
          isCompleted: false,
          priority: 'High',
          status: 'In Progress',
        ),
      ];

      isLoading = false;
    });
  }

  void _toggleTaskCompletion(String id) {
    setState(() {
      tasks = tasks.map((task) {
        if (task.id == id) {
          return TaskModel(
            id: task.id,
            title: task.title,
            deadline: task.deadline,
            isCompleted: !task.isCompleted,
            priority: task.priority,
            status: task.status,
          );
        }
        return task;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Information'),
        backgroundColor: AppColors.brandColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _sectionTitle('Position Details'),
            _infoCard([
              _buildInfoTile(Icons.work_outline, 'Title', jobInfo.title),
              _buildInfoTile(Icons.apartment, 'Department', jobInfo.department),
              _buildInfoTile(Icons.supervisor_account, 'Supervisor', jobInfo.supervisor),
            ]),
            const SizedBox(height: 24),
            _sectionTitle('Employment History'),
            _historyCard(jobInfo.history),
            const SizedBox(height: 24),
            _sectionTitle('Assigned Tasks'),
            _taskList(tasks),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.brandColor),
    );
  }

  Widget _infoCard(List<Widget> children) {
    return Card(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(children: children),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.brandColor),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(value, style: const TextStyle(fontSize: 15)),
    );
  }

  Widget _historyCard(List<String> history) {
    return Card(
      elevation: 2,
      color: Colors.white,
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

  Widget _taskList(List<TaskModel> tasks) {
    return Column(
      children: tasks.map((task) {
        Color priorityColor;
        switch (task.priority) {
          case 'High':
            priorityColor = Colors.redAccent;
            break;
          case 'Medium':
            priorityColor = Colors.orangeAccent;
            break;
          case 'Low':
          default:
            priorityColor = Colors.green;
        }

        return Card(
          color: AppColors.white,
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
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
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
                    Text('Deadline: ${task.deadline}', style: const TextStyle(fontSize: 13)),
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
                        style: TextStyle(fontSize: 12, color: priorityColor, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: task.isCompleted ? 1.0 : 0.5,
                  color: AppColors.brandColor,
                  backgroundColor: Colors.grey[300],
                ),
                Row(
                  children: [
                    Checkbox(
                      activeColor: AppColors.brandColor,
                      value: task.isCompleted,
                      onChanged: (_) => _toggleTaskCompletion(task.id),
                    ),
                    const Text('Mark as Completed'),
                  ],
                )
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
