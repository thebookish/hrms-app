import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/models/employee_model_new.dart';
import 'package:hrms_app/core/services/employee_services.dart';
import 'package:hrms_app/core/services/salary_services.dart';
import 'package:hrms_app/core/services/sponsor_service.dart';
import 'package:hrms_app/core/services/task_services.dart';
import 'package:hrms_app/features/job_info/model/task_model.dart';
import 'package:hrms_app/features/salary/models/salary_model.dart';
import 'package:hrms_app/features/sponsor/model/sponsor_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class EmployeeReportScreen extends StatefulWidget {
  final String employeeEmail;
  const EmployeeReportScreen({super.key, required this.employeeEmail});

  @override
  State<EmployeeReportScreen> createState() => _EmployeeReportScreenState();
}

class _EmployeeReportScreenState extends State<EmployeeReportScreen> {
  bool isLoading = true;

  EmployeeModelNew? employee;
  SalaryModel? salary;
  SponsorModel? sponsor;
  List<TaskModel> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadReportData();
  }
  Future<void> exportEmployeeReportToPDF({
    required BuildContext context,
    required EmployeeModelNew employee,
    required SalaryModel? salary,
    required SponsorModel? sponsor,
    required List<TaskModel> tasks,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, child: pw.Text('Employee Report', style: pw.TextStyle(fontSize: 24))),
          _buildSection('Personal Information', [
            'Name: ${employee.firstName}',
            'Email: ${employee.email}',
            'Phone: ${employee.mobile}',
            'DOB: ${employee.dob}',
            'Gender: ${employee.gender}',
            'Nationality: ${employee.presentAddress}',
          ]),
          _buildSection('Job Details', [
            'Sponsor: ${employee.sponsor}',
            'Job Type: ${employee.position}',
            'Join-End: ${employee.joinDate}',
            'Bank: ${employee.bank}',
            // 'Salary: ${employee.}',
          ]),
          _buildSection('Leave Summary', [
            'Sick Leave: ${employee.sickLeave}',
            'Casual Leave: ${employee.casualLeave}',
            'Paid Leave: ${employee.paidLeave}',
          ]),
          if (salary != null)
            _buildSection('Salary Breakdown', [
              'Basic: ${salary.basic}',
              'HRA: ${salary.hra}',
              'Allowance: ${salary.allowance}',
              'Deduction: ${salary.deduction}',
              'Net: ${salary.basic + salary.hra + salary.allowance - salary.deduction}',
            ]),
          if (sponsor != null)
            _buildSection('Sponsor Info', [
              'Sponsor Name: ${sponsor.name}',
              'Industry: ${sponsor.industry}',
              'Contact Person: ${sponsor.contactPerson}',
              'Phone: ${sponsor.phone}',
              'Address: ${sponsor.address}',
            ]),
          _buildSection('Assigned Tasks', tasks.map((task) {
            return '- ${task.title} [${task.status}] Due: ${task.deadline.split("T").first}';
          }).toList()),
        ],
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  pw.Widget _buildSection(String title, List<String> lines) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),
        pw.Text(title, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 6),
        ...lines.map((line) => pw.Text(line)),
      ],
    );
  }
  Future<void> _loadReportData() async {
    try {
      employee = await EmployeeService().getEmployeeDataByEmail(widget.employeeEmail);
      final salaryJson = await SalaryService().getSalaryInfo(widget.employeeEmail);
      salary = SalaryModel.fromJson(salaryJson);
      sponsor = await SponsorService().fetchSponsor(widget.employeeEmail);
      tasks = await TaskService().getUserTasks(widget.employeeEmail);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load data')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.brandColor)),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, size: 18, color: AppColors.brandColor),
          if (icon != null) const SizedBox(width: 6),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(
            child: Text(value?.isNotEmpty == true ? value! : 'N/A',
                style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (tasks.isEmpty) return const Text('No tasks assigned.');

    return Column(
      children: tasks.map((task) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Due: ${task.deadline.split('T').first} • Status: ${task.status}"),
          trailing: Icon(task.isCompleted ? Icons.check_circle : Icons.pending_actions,
              color: task.isCompleted ? Colors.green : Colors.orange),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final leaveRow = [
      _infoRow('Sick Leave', '${employee?.sickLeave ?? 0}'),
      _infoRow('Casual Leave', '${employee?.casualLeave ?? 0}'),
      _infoRow('Paid Leave', '${employee?.paidLeave ?? 0}'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Report'),
        backgroundColor: AppColors.brandColor,
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              if (employee != null) {
                exportEmployeeReportToPDF(
                  context: context,
                  employee: employee!,
                  salary: salary,
                  sponsor: sponsor,
                  tasks: tasks,
                );
              }
            },
            icon: const Icon(Icons.picture_as_pdf,size: 15,),
            label: const Text('Export'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
          ),

        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _sectionCard(title: 'Personal Information', children: [
              _infoRow('Name', employee?.firstName, icon: Icons.person),
              _infoRow('Email', employee?.email, icon: Icons.email),
              _infoRow('Phone', employee?.mobile, icon: Icons.phone),
              _infoRow('DOB', employee?.dob, icon: Icons.cake),
              _infoRow('Gender', employee?.gender),
              _infoRow('Nationality', employee?.permanentAddress),
            ]),

            _sectionCard(title: 'Job Details', children: [
              _infoRow('Sponsor', employee?.sponsor),
              _infoRow('Job Type', employee?.position),
              _infoRow('Join-End', employee?.joinDate),
              _infoRow('Bank', employee?.bank),
              // _infoRow('Salary', employee?.salary),
            ]),

            _sectionCard(title: 'Family & Emergency', children: [
              // _infoRow('Family', employee?.),
              _infoRow('Emergency Contact', employee?.emergency),
              // _infoRow('Passport', employee?.passport),
              // _infoRow('ID', employee?.eid),
            ]),

            _sectionCard(title: 'Leave Summary', children: leaveRow),

            _sectionCard(title: 'Salary Breakdown', children: salary != null
                ? [
              _infoRow('Basic', '${salary!.basic}'),
              _infoRow('HRA', '${salary!.hra}'),
              _infoRow('Allowance', '${salary!.allowance}'),
              _infoRow('Deduction', '${salary!.deduction}'),
              _infoRow('Net', '${salary!.basic + salary!.hra + salary!.allowance - salary!.deduction}'),
            ]
                : [const Text('No salary data.')]
            ),

            _sectionCard(title: 'Sponsor Info', children: sponsor != null
                ? [
              _infoRow('Sponsor Name', sponsor!.name),
              _infoRow('Industry', sponsor!.industry),
              _infoRow('Contact Person', sponsor!.contactPerson),
              _infoRow('Phone', sponsor!.phone),
              _infoRow('Address', sponsor!.address),
            ]
                : [const Text('No sponsor info found.')]
            ),

            _sectionCard(title: 'Assigned Tasks', children: [_buildTaskList()]),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
