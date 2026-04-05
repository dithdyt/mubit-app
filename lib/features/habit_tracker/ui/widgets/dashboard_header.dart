import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mubit/core/providers/date_provider.dart';
import 'package:mubit/core/theme/app_theme.dart';
import 'package:mubit/features/prayer_times/providers/prayer_provider.dart';

class DashboardHeader extends ConsumerStatefulWidget {
  const DashboardHeader({super.key});

  @override
  ConsumerState<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends ConsumerState<DashboardHeader> {
  late Timer _timer;
  DateTime _currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final prayerTimes = ref.watch(dailyPrayerTimesProvider);
    
    // Masehi Formatting
    final masehiStr = DateFormat('EEEE, d MMMM yyyy').format(selectedDate);
    
    // Hijri Formatting
    // Adjusted by -1 day (shifted from previous +1 day) to fix 2-day gap
    final adjustedDate = selectedDate.subtract(const Duration(days: 1));
    final hDate = HijriCalendar.fromDate(adjustedDate);
    final hijriStr = '${hDate.hDay} ${hDate.longMonthName} ${hDate.hYear} H';

    // Clock Formatting
    final clockStr = DateFormat('HH:mm:ss').format(_currentTime);

    // Countdown Logic
    String countdownStr = prayerTimes.when(
      data: (times) {
        final nextTime = times.getNextPrayerTime();
        if (nextTime != null) {
          final diff = nextTime.difference(DateTime.now());
          if (diff.isNegative) {
            return 'Waktu shalat tiba';
          } else {
            return 'Menuju shalat ${times.nextPrayerName} - ${_formatDuration(diff)}';
          }
        }
        return 'Jadwal selesai hari ini';
      },
      error: (err, _) => err == 'LocationNotSet' ? 'Lokasi belum diatur' : 'Gagal memuat jadwal',
      loading: () => 'Menghitung jadwal...',
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8), // Snug bottom margin
      padding: const EdgeInsets.all(20), // More symmetric padding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryGreen,
            AppTheme.primaryGreen.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Centered
        children: [
          // Live Clock
          Text(
            clockStr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 36, // Slightly larger for center focus
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 2), // Very tight
          // Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centered
            children: [
              const Icon(Icons.calendar_today_rounded, size: 12, color: Colors.white),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '$masehiStr • $hijriStr',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Balanced gap to countdown
          // Countdown Feature
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1), // Slightly darker for contrast
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, size: 13, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  countdownStr,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
