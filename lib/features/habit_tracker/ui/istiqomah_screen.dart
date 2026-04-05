import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mubit/core/theme/app_theme.dart';
import 'package:mubit/core/services/shared_prefs_service.dart';
import 'package:mubit/features/habit_tracker/providers/habit_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class IstiqomahScreen extends ConsumerWidget {
  const IstiqomahScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(habitRepositoryProvider);
    final prefs = ref.watch(sharedPrefsServiceProvider);
    final includePuasa = prefs.includePuasaInTarget;

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        title: Text(
          'Grafik Istiqomah',
          style: GoogleFonts.philosopher(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
      ),
      body: FutureBuilder<Map<DateTime, double>>(
        future: repository.getStatsForLastNDays(20, includePuasa),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final stats = snapshot.data ?? {};
          final sortedDates = stats.keys.toList()..sort();
          
          return FutureBuilder<int>(
            future: repository.getCurrentStreak(includePuasa),
            builder: (context, streakSnapshot) {
              final streak = streakSnapshot.data ?? 0;
              final average = stats.isEmpty 
                ? 0.0 
                : (stats.values.reduce((a, b) => a + b) / stats.length);

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildSummaryCards(streak, average),
                  const SizedBox(height: 32),
                  const Text(
                    'Performa 20 Hari Terakhir',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  _buildBarChart(sortedDates, stats),
                  const SizedBox(height: 32),
                  _buildHistoryList(sortedDates, stats),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards(int streak, double average) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Current Streak',
            value: '$streak',
            unit: 'Hari',
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            label: 'Rata-rata',
            value: '${(average * 100).toInt()}',
            unit: '%',
            icon: Icons.analytics_rounded,
            color: AppTheme.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List<DateTime> sortedDates, Map<DateTime, double> stats) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 1.0,
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index % 4 == 0 && index < sortedDates.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        DateFormat('d/M').format(sortedDates[index]),
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: sortedDates.asMap().entries.map((entry) {
            final index = entry.key;
            final date = entry.value;
            final val = stats[date] ?? 0.0;
            final isToday = DateUtils.isSameDay(date, DateTime.now());

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: val.clamp(0.05, 1.0),
                  color: isToday ? Colors.orange : AppTheme.primaryGreen.withValues(alpha: val >= 1.0 ? 1.0 : 0.4),
                  width: 8,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildHistoryList(List<DateTime> sortedDates, Map<DateTime, double> stats) {
    final reversedDates = sortedDates.reversed.toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Harian',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...reversedDates.take(10).map((date) {
          final val = stats[date] ?? 0.0;
          final percentage = (val * 100).toInt();
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryGreen.withValues(alpha: 0.1),
              child: Text('$percentage%', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.primaryGreen)),
            ),
            title: Text(
              DateUtils.isSameDay(date, DateTime.now()) ? 'Hari Ini' : DateFormat('EEEE, d MMMM').format(date),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            trailing: Icon(
              percentage >= 100 ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: percentage >= 100 ? AppTheme.primaryGreen : Colors.grey.withValues(alpha: 0.3),
            ),
          );
        }),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.unit,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.7)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
