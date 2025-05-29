import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';
import 'package:hrms_app/features/salary/models/salary_model.dart';

class SalaryInfoScreen extends StatefulWidget {
  const SalaryInfoScreen({super.key});

  @override
  State<SalaryInfoScreen> createState() => _SalaryInfoScreenState();
}

class _SalaryInfoScreenState extends State<SalaryInfoScreen> {
  late SalaryModel salary;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSalaryInfo();
  }

  Future<void> _loadSalaryInfo() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      salary = SalaryModel(
        basic: 40000,
        hra: 15000,
        allowance: 5000,
        deduction: 3000,
        paymentHistory: [
          Payment(month: 'May 2025', amount: 57000, status: 'Paid'),
          Payment(month: 'April 2025', amount: 57000, status: 'Paid'),
          Payment(month: 'March 2025', amount: 57000, status: 'Paid'),
        ],
        upcomingIncrements: [
          Increment(effectiveDate: '2025-08-01', newSalary: 62000),
          Increment(effectiveDate: '2026-02-01', newSalary: 68000),
        ],
      );
      isLoading = false;
    });
  }

  double get gross => salary.basic + salary.hra + salary.allowance;
  double get net => gross - salary.deduction;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Information'),
        backgroundColor: AppColors.primary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Salary Breakdown',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildRow('Basic Salary', salary.basic),
            _buildRow('HRA', salary.hra),
            _buildRow('Allowance', salary.allowance),
            _buildRow('Deduction', salary.deduction),
            const Divider(height: 32),
            _buildRow('Gross Salary', gross),
            _buildRow('Net Salary', net, bold: true),
            const SizedBox(height: 24),

            const Text('Payment History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...salary.paymentHistory.map((p) => ListTile(
              title: Text(p.month),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('৳ ${p.amount.toStringAsFixed(2)}'),
                  Text(
                    p.status,
                    style: TextStyle(
                        fontSize: 12,
                        color: p.status == 'Paid' ? Colors.green : Colors.orange),
                  ),
                ],
              ),
            )),

            const SizedBox(height: 24),
            const Text('Upcoming Increments',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...salary.upcomingIncrements.map((i) => ListTile(
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
    final spots = salary.upcomingIncrements
        .asMap()
        .entries
        .map((entry) => FlSpot(
      entry.key.toDouble(),
      entry.value.newSalary,
    ))
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
                      if (index < salary.upcomingIncrements.length) {
                        return Text(
                          salary.upcomingIncrements[index].effectiveDate.substring(5),
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
