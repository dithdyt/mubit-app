import 'package:flutter/material.dart';
import 'package:mubit/core/theme/app_theme.dart';
import 'package:intl/intl.dart';

class IstiqomahChart extends StatelessWidget {
  final Map<DateTime, double> stats;

  const IstiqomahChart({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return const Center(child: Text('Belum ada data statistik.'));

    final sortedDates = stats.keys.toList()..sort();
    
    return Container(
      padding: const EdgeInsets.all(20),
      height: 250,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: sortedDates.map((date) {
                final percentage = stats[date] ?? 0.0;
                return _Bar(
                  percentage: percentage,
                  label: DateFormat('E').format(date).toUpperCase(),
                  isToday: DateUtils.isSameDay(date, DateTime.now()),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double percentage;
  final String label;
  final bool isToday;

  const _Bar({
    required this.percentage,
    required this.label,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final heightFactor = percentage.clamp(0.05, 1.0); // Minimum height for visibility

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 14,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              FractionallySizedBox(
                heightFactor: heightFactor,
                child: Container(
                  width: 14,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primaryGreen,
                        AppTheme.primaryGreen.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      if (isToday)
                        BoxShadow(
                          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isToday ? FontWeight.bold : FontWeight.w500,
            color: isToday ? AppTheme.primaryGreen : Colors.grey,
          ),
        ),
      ],
    );
  }
}
