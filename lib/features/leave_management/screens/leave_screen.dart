import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/employee_services.dart';
import 'package:hrms_app/core/services/leave_services.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';
import 'package:hrms_app/features/dashboard/controllers/employee_dashboard_controlller.dart';
import 'package:hrms_app/features/leave_management/models/leave_model.dart';
import 'package:hrms_app/features/settings/providers/theme_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LeaveScreen extends ConsumerStatefulWidget {
  const LeaveScreen({super.key});

  @override
  ConsumerState<LeaveScreen> createState() => _LeaveScreenState();
}

class _LeaveScreenState extends ConsumerState<LeaveScreen>
    with TickerProviderStateMixin {
  List<LeaveModel> _leaves = [];
  bool _isLoading = true;
  String? _error;
  late TabController _tabController;

  final List<String> leaveTypes = ['Casual', 'Sick', 'Paid'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadLeaves();
  }

  Future<void> _loadLeaves() async {
    try {
      final user = ref.read(loggedInUserProvider);
      final leaves = await LeaveService().fetchLeaves(email: user!.email);
      setState(() {
        _leaves = leaves;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(loggedInUserProvider);
    final employeeAsync = ref.watch(employeeDataProvider);
    final themeMode = ref.read(themeModeProvider.notifier).state;
    late String? empName;
    return Scaffold(
      backgroundColor: const Color(0xFF0E1D36),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Leaves Status', style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : _error != null
          ? Center(
          child: Text('Something Went Wrong!',
              style: const TextStyle(color: Colors.white)))
          : employeeAsync.when(
        loading: () =>
        const Center(
            child: CircularProgressIndicator(color: Colors.white)),
        error: (err, _) =>
            Center(
                child: Text('Something Went Wrong!',
                    style: const TextStyle(color: Colors.white))),
        data: (employee) {
          final sick = employee.sickLeave ?? 0;
          final casual = employee.casualLeave ?? 0;
          final paid = employee.paidLeave ?? 0;
          empName = employee.firstName;
          int approvedCasual = 0;
          int approvedSick = 0;
          int approvedPaid = 0;

          for (var leave in _leaves.where((l) => l.status == 'approved')) {
            switch (leave.type.toLowerCase()) {
              case 'casual leave':
                approvedCasual++;
                break;
              case 'sick leave':
                approvedSick++;
                break;
              case 'paid leave':
                approvedPaid++;
                break;
            }
          }


          final used = approvedCasual + approvedSick + approvedPaid;
          final total = sick + casual + paid + used;
          final balance = total - used;

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 8),
                CircularPercentIndicator(
                  radius: 60,
                  lineWidth: 12,
                  animation: true,
                  percent: total == 0
                      ? 0
                      : (balance / total).clamp(0.0, 1.0),
                  center: Text("$balance\nBalance",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  circularStrokeCap: CircularStrokeCap.round,
                  backgroundColor: Colors.grey.shade800,
                  progressColor: Colors.greenAccent,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatBox("$total", "Total Leaves", Colors.blue),
                    _buildStatBox("$balance", "Balance", Colors.green),
                    _buildStatBox("$used", "Used", Colors.amber),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLeaveTypeCircle(
                        "${casual - approvedCasual}", "Casual"),
                    _buildLeaveTypeCircle("${sick - approvedSick}", "Sick"),
                    _buildLeaveTypeCircle("${paid - approvedPaid}", "Paid"),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    color: themeMode==ThemeMode.dark?Colors.black:AppColors.white,
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    children: [
                      TabBar(
                        controller: _tabController,
                        indicatorColor: AppColors.primary,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: "Approved"),
                          Tab(text: "History"),
                        ],
                      ),
                      SizedBox(
                        height: 300,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildLeaveList(context,themeMode,
                                statusFilter: 'approved'),
                            _buildLeaveList(context,themeMode),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },

      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Apply Leave", style: TextStyle(color: Colors.white)),
        onPressed: () =>
            _showLeaveForm(context, user!.email, empName!,themeMode),
      ),
    );
  }

  Widget _buildStatBox(String count, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(count,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildLeaveTypeCircle(String count, String type) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 24,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent, width: 2),
              shape: BoxShape.circle,
            ),
            child: Center(
                child:
                Text(count, style: const TextStyle(color: Colors.white))),
          ),
        ),
        const SizedBox(height: 6),
        Text(type, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }

  Widget _buildLeaveList(BuildContext context,themeMode, {String? statusFilter}) {
    final filtered = statusFilter == null
        ? _leaves
        : _leaves.where((l) => l.status.toLowerCase() == statusFilter).toList();

    if (filtered.isEmpty) {
      return const Center(
          child:
          Text("No records found", style: TextStyle(color: Colors.grey)));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final leave = filtered[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color:themeMode==ThemeMode.dark?Colors.white12:Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              '${leave.type} \n${leave.fromDate.split("T")[0]} - ${leave.toDate
                  .split("T")[0]}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(leave.reason),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: _statusColor(leave.status).withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(leave.status,
                  style: TextStyle(
                      color: _statusColor(leave.status),
                      fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  void _showLeaveForm(BuildContext context, String email, String employeeName,themeMode) {
    final toController = TextEditingController(text: 'Head of Chancery');
    final nameController = TextEditingController(text: employeeName);
    final subjectOptions = [
      'Casual Leave Application',
      'Annual Leave Application'
    ];
    final reasonOptions = ['Medical', 'Personal', 'Family', 'Overseas Travel'];
    final whatsAppController = TextEditingController();
    final emergencyContactController = TextEditingController();
    final substituteNameController = TextEditingController();
    final substituteContactController = TextEditingController();
    final signatureController = TextEditingController();
    final designationController = TextEditingController();
    final wingController = TextEditingController();

    String? selectedSubject;
    String? selectedReason;
    bool noSubstitute = true;
    DateTime? fromDate;
    DateTime? toDate;

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: themeMode==ThemeMode.dark?Colors.black:AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom + 24,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              final now = DateTime.now();
              final formattedDate = '${now.year}-${now.month.toString().padLeft(
                  2, '0')}-${now.day.toString().padLeft(2, '0')}';

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Leave Application Form",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 16),
                    _buildTextField(toController, "To"),

                    _buildTextField(nameController, "Applicant’s Name"),

                    Text("Date of Application: $formattedDate"),

                    DropdownButtonFormField<String>(
                      value: selectedSubject,
                      decoration: const InputDecoration(labelText: 'Subject'),
                      items: subjectOptions.map((s) =>
                          DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) => setState(() => selectedSubject = val),
                    ),

                    DropdownButtonFormField<String>(
                      value: selectedReason,
                      decoration: const InputDecoration(
                          labelText: 'Reason for Leave'),
                      items: reasonOptions.map((r) =>
                          DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (val) => setState(() => selectedReason = val),
                    ),

                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: Text(
                            fromDate == null ? 'Start Date' : 'From: ${fromDate!
                                .toIso8601String().split("T")[0]}')),
                        ElevatedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                  const Duration(days: 365)),
                            );
                            if (picked != null) setState(() =>
                            fromDate = picked);
                          },
                          child: const Text('Pick Start'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(child: Text(
                            toDate == null ? 'End Date' : 'To: ${toDate!
                                .toIso8601String().split("T")[0]}')),
                        ElevatedButton(
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: fromDate ?? DateTime.now(),
                              firstDate: fromDate ?? DateTime.now(),
                              lastDate: DateTime.now().add(
                                  const Duration(days: 365)),
                            );
                            if (picked != null) setState(() => toDate = picked);
                          },
                          child: const Text('Pick End'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    if (fromDate != null && toDate != null)
                      Text("Number of Days: ${toDate!.difference(fromDate!)
                          .inDays + 1}"),

                    _buildTextField(whatsAppController, "WhatsApp Contact"),
                    _buildTextField(
                        emergencyContactController, "Emergency Contact"),

                    CheckboxListTile(
                      title: const Text("No Substitute Staff (N/A)"),
                      value: noSubstitute,
                      onChanged: (val) =>
                          setState(() =>
                          noSubstitute = val ?? true),
                    ),

                    if (!noSubstitute) ...[
                      _buildTextField(
                          substituteNameController, "Substitute Name"),
                      _buildTextField(
                          substituteContactController, "Substitute Contact"),
                    ],

                    const SizedBox(height: 16),
                    const Text("Request for Approval:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text(
                      "I humbly request your kind approval for this leave application. "
                          "If required, I can provide additional information or documentation.",
                      style: TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 12),
                    const Text("Declaration:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Text(
                      "I understand that my leave is subject to the terms and conditions "
                          "of my employment contract and the Consulate’s leave policy.",
                      style: TextStyle(fontSize: 14),
                    ),

                    _buildTextField(signatureController, "Signature"),
                    // _buildTextField(nameController, "Name"),
                    _buildTextField(designationController, "Designation"),
                    _buildTextField(wingController, "Wing"),

                    const SizedBox(height: 20),
                    ElevatedButton(
                
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandColor),
                      onPressed: () async {
                        if (selectedSubject == null ||
                            selectedReason == null ||
                            fromDate == null ||
                            toDate == null ||
                            nameController.text.isEmpty ||
                            signatureController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text(
                                'Please fill all required fields')),
                          );
                          return;
                        }

                        final payload = {
                          "name": nameController.text.trim(),
                          "email": email,
                          "type": selectedSubject,
                          "reason": selectedReason,
                          "fromDate": fromDate!.toIso8601String(),
                          "toDate": toDate!.toIso8601String(),
                          "noOfDays": toDate!.difference(fromDate!).inDays + 1,
                          "whatsapp": whatsAppController.text.trim(),
                          "emergencyContact": emergencyContactController.text
                              .trim(),
                          "substituteName": noSubstitute
                              ? "N/A"
                              : substituteNameController.text.trim(),
                          "substituteContact": noSubstitute
                              ? "N/A"
                              : substituteContactController.text.trim(),
                          "signature": signatureController.text.trim(),
                          "designation": designationController.text.trim(),
                          "wing": wingController.text.trim(),
                        };

                        try {
                          await LeaveService().applyLeave(email, payload);
                          if (mounted) {
                            Navigator.pop(context);
                            await _loadLeaves();
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Something Went Wrong!')));
                        }
                      }, child: Text('Submit LeaveRequest'),
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}