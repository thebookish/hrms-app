import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/core/services/salary_services.dart';
import 'package:hrms_app/features/salary/models/salary_model.dart';
import 'package:hrms_app/features/auth/controllers/user_provider.dart';

class SalaryInfoScreen extends ConsumerStatefulWidget {
  const SalaryInfoScreen({super.key});

  @override
  ConsumerState<SalaryInfoScreen> createState() => _SalaryInfoScreenState();
}

class _SalaryInfoScreenState extends ConsumerState<SalaryInfoScreen> {
  SalaryModel? salary;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadSalaryInfo();
  }

  Future<void> _loadSalaryInfo() async {
    final user = ref.read(loggedInUserProvider);
    if (user == null) return;

    try {
      final result = await SalaryService().getSalaryInfo(user.email);
      setState(() {
        salary = SalaryModel.fromJson(result);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  double get gross => (salary?.basic ?? 0) + (salary?.hra ?? 0) + (salary?.allowance ?? 0);
  double get net => gross - (salary?.deduction ?? 0);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        body: Center(child: Text('Error: $error')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Information'),
        backgroundColor: AppColors.brandColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Salary Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildRow('Basic Salary', salary!.basic),
            _buildRow('HRA', salary!.hra),
            _buildRow('Allowance', salary!.allowance),
            _buildRow('Deduction', salary!.deduction),
            const Divider(height: 32),
            _buildRow('Gross Salary', gross),
            _buildRow('Net Salary', net, bold: true),
            const SizedBox(height: 24),
            const Text('Payment History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...salary!.paymentHistory.map((p) => ListTile(
              title: Text(p.month),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('৳ ${p.amount.toStringAsFixed(2)}'),
                  Text(
                    p.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: p.status == 'Paid' ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 24),
            const Text('Upcoming Increments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...salary!.upcomingIncrements.map((i) => ListTile(
              leading: const Icon(Icons.trending_up, color: Colors.indigo),
              title: Text('New Salary: ৳ ${i.newSalary.toStringAsFixed(2)}'),
              subtitle: Text('Effective from: ${i.effectiveDate}'),
            )),
            _buildSalaryGrowthChart(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, double amount, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            '৳ ${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaryGrowthChart() {
    final spots = salary!.upcomingIncrements
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.newSalary))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Salary Growth Chart',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: true),
              borderData: FlBorderData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index < salary!.upcomingIncrements.length) {
                        return Text(
                          salary!.upcomingIncrements[index].effectiveDate.substring(5),
                          style: const TextStyle(fontSize: 10),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) =>
                        Text('৳${value.toInt()}', style: const TextStyle(fontSize: 10)),
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  barWidth: 3,
                  color: Colors.blueAccent,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
