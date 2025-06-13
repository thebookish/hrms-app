import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hrms_app/core/constants/app_colors.dart';

class SalaryChartCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(child: Text("Salary Statistics", style: TextStyle(fontWeight: FontWeight.w600))),
              const SizedBox(width: 8),
              ToggleButtons(
                isSelected: const [true, false, false],
                children: const [Text("D"), Text("M"), Text("Y")],
                onPressed: (_) {}, // You can implement logic later
              ),

            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (val, _) {
                    const months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
                    return Text(months[val.toInt() % 12]);
                  })),
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      FlSpot(0, 30),
                      FlSpot(1, 45),
                      FlSpot(2, 40),
                      FlSpot(3, 60),
                      FlSpot(4, 80),
                      FlSpot(5, 50),
                      FlSpot(6, 90),
                      FlSpot(7, 70),
                      FlSpot(8, 85),
                      FlSpot(9, 100),
                      FlSpot(10, 90),
                      FlSpot(11, 60),
                    ],
                    isCurved: true,
                    color: AppColors.brandColor,
                    barWidth: 2,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.brandColor.withOpacity(0.2),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
