import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/notification_service.dart';
import 'package:hrms_app/core/services/task_services.dart';
import 'package:hrms_app/features/job_info/model/task_model.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AssignTaskScreen extends StatefulWidget {
  final String? employeeEmail;

  const AssignTaskScreen({super.key, required this.employeeEmail});

  @override
  State<AssignTaskScreen> createState() => _AssignTaskScreenState();
}

class _AssignTaskScreenState extends State<AssignTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _statusOptions = ['Pending', 'In Progress', 'Completed'];
  final _priorityOptions = ['High', 'Medium', 'Low'];
  String? _selectedPriority;
  String? _selectedStatus;
  DateTime? _selectedDeadline;

  bool isLoading = true;
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }
  Future<void> _sendNotification({
    required String title,
    required String message,
    required String receiverEmail,
  }) async {
    try {
      await NotificationService().sendNotification(
        title: title,
        message: message,
        receiverEmail: receiverEmail,
      );
    } catch (e) {
      debugPrint('Failed to send notification: $e');
    }
  }
  Future<void> _loadTasks() async {
    try {
      final response = await TaskService().getUserTasks(widget.employeeEmail!);
      setState(() {
        tasks = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _selectedPriority == null ||
        _selectedStatus == null ||
        _selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final taskId = const Uuid().v4();
    final taskTitle = _titleController.text.trim();

    final taskData = {
      'id': taskId,
      'title': taskTitle,
      'deadline': _selectedDeadline!.toIso8601String(),
      'isCompleted': false,
      'priority': _selectedPriority,
      'status': _selectedStatus,
      'email': widget.employeeEmail,
    };

    try {
      await TaskService().createTask(taskData);

      // ✅ Send notification after creating the task
      await _sendNotification(
        title: 'New Task Assigned',
        message: 'Task "$taskTitle" has been assigned to you.',
        receiverEmail: widget.employeeEmail!,
      );

      await _loadTasks(); // Refresh list
      _titleController.clear();
      _selectedPriority = null;
      _selectedStatus = null;
      _selectedDeadline = null;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task assigned successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  double _calculateCompletionRate() {
    if (tasks.isEmpty) return 0.0;
    final completed = tasks.where((task) => task.isCompleted).length;
    return completed / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    final completionRate = _calculateCompletionRate();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign New Task'),
        backgroundColor: AppColors.brandColor,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Progress Indicator
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Task Progress",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: completionRate,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation(AppColors.brandColor),
                ),
                const SizedBox(height: 8),
                Text('${(completionRate * 100).toStringAsFixed(0)}% Completed'),
              ],
            ),
            const SizedBox(height: 24),

            // Assign Task Form
            const Text("Assign New Task",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Task Title',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                    value!.isEmpty ? 'Enter a task title' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Priority',
                      border: OutlineInputBorder(),
                    ),
                    items: _priorityOptions
                        .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                        .toList(),
                    value: _selectedPriority,
                    onChanged: (val) => setState(() => _selectedPriority = val),
                    validator: (val) => val == null ? 'Select priority' : null,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                    ),
                    items: _statusOptions
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    value: _selectedStatus,
                    onChanged: (val) => setState(() => _selectedStatus = val),
                    validator: (val) => val == null ? 'Select status' : null,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Deadline'),
                    subtitle: Text(_selectedDeadline == null
                        ? 'Select a date'
                        : DateFormat.yMMMd().format(_selectedDeadline!)),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate:
                          DateTime.now().add(const Duration(days: 365)),
                        );
                        if (picked != null) {
                          setState(() => _selectedDeadline = picked);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Assign Task'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandColor,
                      // padding: const EdgeInsets.symmetric(vertical: 14),
                    ), onPressed: () { _submit(); },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Task History
            const Text("Previous Tasks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...tasks.map((task) => Card(
              color: AppColors.white,
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(task.title, style: TextStyle(color: AppColors.brandColor, fontWeight: FontWeight.bold),),
                subtitle: Text(
                    '• Due: ${task.deadline} \n• Status: ${task.status}'),
                trailing: Icon(
                  task.isCompleted
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.isCompleted
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
