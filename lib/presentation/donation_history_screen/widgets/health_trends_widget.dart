import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class HealthTrendsWidget extends StatefulWidget {
  final List<Map<String, dynamic>> donationData;

  const HealthTrendsWidget({
    Key? key,
    required this.donationData,
  }) : super(key: key);

  @override
  State<HealthTrendsWidget> createState() => _HealthTrendsWidgetState();
}

class _HealthTrendsWidgetState extends State<HealthTrendsWidget> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Header
              Text('স্বাস্থ্য ট্রেন্ড',
                  style: AppTheme.lightTheme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 2.h),

              // Tab selector
              Container(
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [
                    Expanded(
                        child: _buildTabButton(
                            title: 'দানের ফ্রিকুয়েন্সি',
                            index: 0,
                            isSelected: _selectedTabIndex == 0)),
                    Expanded(
                        child: _buildTabButton(
                            title: 'পুনরুদ্ধার সময়',
                            index: 1,
                            isSelected: _selectedTabIndex == 1)),
                  ])),
              SizedBox(height: 3.h),

              // Chart content
              SizedBox(
                  height: 25.h,
                  child: _selectedTabIndex == 0
                      ? _buildDonationFrequencyChart()
                      : _buildRecoveryTimeChart()),
              SizedBox(height: 2.h),

              // Health insights
              _buildHealthInsights(),
            ])));
  }

  Widget _buildTabButton({
    required String title,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
        onTap: () {
          setState(() {
            _selectedTabIndex = index;
          });
        },
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.5.h),
            decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.primaryColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6)),
            child: Text(title,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
                textAlign: TextAlign.center)));
  }

  Widget _buildDonationFrequencyChart() {
    final List<FlSpot> spots = [];
    final monthlyData = _getMonthlyDonationData();

    for (int i = 0; i < monthlyData.length; i++) {
      spots.add(FlSpot(i.toDouble(), monthlyData[i]['count'].toDouble()));
    }

    return LineChart(LineChartData(
        lineBarsData: [
          LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppTheme.lightTheme.primaryColor,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                        radius: 4,
                        color: AppTheme.lightTheme.primaryColor,
                        strokeWidth: 2,
                        strokeColor: Colors.white);
                  }),
              belowBarData: BarAreaData(
                  show: true,
                  color: AppTheme.lightTheme.primaryColor.withAlpha(26))),
        ],
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text(value.toInt().toString(),
                          style: AppTheme.lightTheme.textTheme.labelSmall);
                    })),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final months = [
                        'জানু',
                        'ফেব',
                        'মার্চ',
                        'এপ্রিল',
                        'মে',
                        'জুন'
                      ];
                      if (value.toInt() >= 0 && value.toInt() < months.length) {
                        return Text(months[value.toInt()],
                            style: AppTheme.lightTheme.textTheme.labelSmall);
                      }
                      return const Text('');
                    })),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: AppTheme.lightTheme.dividerColor, strokeWidth: 1);
            }),
        borderData: FlBorderData(show: false),
        lineTouchData: LineTouchData(touchTooltipData:
            LineTouchTooltipData(getTooltipItems: (touchedSpots) {
          return touchedSpots.map((spot) {
            return LineTooltipItem('${spot.y.toInt()} টি দান',
                const TextStyle(color: Colors.white));
          }).toList();
        }))));
  }

  Widget _buildRecoveryTimeChart() {
    final List<BarChartGroupData> barGroups = [];
    final recoveryData = _getRecoveryTimeData();

    for (int i = 0; i < recoveryData.length; i++) {
      barGroups.add(BarChartGroupData(x: i, barRods: [
        BarChartRodData(
            toY: recoveryData[i]['days'].toDouble(),
            color: AppTheme.lightTheme.primaryColor,
            width: 8.w,
            borderRadius: BorderRadius.circular(4)),
      ]));
    }

    return BarChart(BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
            leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) {
                      return Text('${value.toInt()} দিন',
                          style: AppTheme.lightTheme.textTheme.labelSmall);
                    })),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) {
                      final donations = ['১ম', '২য়', '৩য়', '৪র্থ', '৫ম'];
                      if (value.toInt() >= 0 &&
                          value.toInt() < donations.length) {
                        return Text(donations[value.toInt()],
                            style: AppTheme.lightTheme.textTheme.labelSmall);
                      }
                      return const Text('');
                    })),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false))),
        gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                  color: AppTheme.lightTheme.dividerColor, strokeWidth: 1);
            }),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
          return BarTooltipItem(
              '${rod.toY.toInt()} দিন', const TextStyle(color: Colors.white));
        }))));
  }

  Widget _buildHealthInsights() {
    return Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(Icons.health_and_safety,
                size: 20, color: AppTheme.getSuccessColor(true)),
            SizedBox(width: 2.w),
            Text('স্বাস্থ্য পরামর্শ',
                style: AppTheme.lightTheme.textTheme.titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ]),
          SizedBox(height: 1.h),
          Text(
              'আপনার সর্বশেষ দানের পর ${_getDaysSinceLastDonation()} দিন অতিবাহিত হয়েছে। '
              'পরবর্তী দানের জন্য আরও ${_getDaysUntilNextDonation()} দিন অপেক্ষা করুন।',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
        ]));
  }

  List<Map<String, dynamic>> _getMonthlyDonationData() {
    // Mock data for monthly donations
    return [
      {'month': 'জানু', 'count': 1},
      {'month': 'ফেব', 'count': 0},
      {'month': 'মার্চ', 'count': 1},
      {'month': 'এপ্রিল', 'count': 2},
      {'month': 'মে', 'count': 1},
      {'month': 'জুন', 'count': 1},
    ];
  }

  List<Map<String, dynamic>> _getRecoveryTimeData() {
    // Mock data for recovery times
    return [
      {'donation': '১ম', 'days': 56},
      {'donation': '২য়', 'days': 60},
      {'donation': '৩য়', 'days': 58},
      {'donation': '৪র্থ', 'days': 55},
      {'donation': '৫ম', 'days': 57},
    ];
  }

  int _getDaysSinceLastDonation() {
    // Mock calculation
    return 45;
  }

  int _getDaysUntilNextDonation() {
    // Mock calculation (56 days minimum between donations)
    return 11;
  }
}
