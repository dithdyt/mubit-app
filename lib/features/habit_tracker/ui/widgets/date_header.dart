import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mubit/core/providers/date_provider.dart';
import 'package:mubit/core/theme/app_theme.dart';

class DateHeader extends ConsumerWidget {
  const DateHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    
    // Masehi Formatting
    final masehiStr = DateFormat('EEEE, d MMMM yyyy').format(selectedDate);
    
    // Hijri Formatting
    final hDate = HijriCalendar.fromDate(selectedDate);
    final hijriStr = '${hDate.hDay} ${hDate.longMonthName} ${hDate.hYear} H';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundWhite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                masehiStr,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('•', style: TextStyle(color: Colors.grey)),
              ),
              Text(
                hijriStr,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryGreen.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Divider(color: Colors.grey.withValues(alpha: 0.05), thickness: 1),
        ],
      ),
    );
  }
}
