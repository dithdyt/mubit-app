import 'package:isar/isar.dart';
import 'package:hijri/hijri_calendar.dart';
import '../domain/habit_log.dart';

class HabitRepository {
  final Isar _isar;

  HabitRepository(this._isar);

  // Initialize habits for a given date if they don't exist
  Future<void> _ensureHabitsExistForDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    
    final existingHabits = await _isar.habitLogs
        .filter()
        .dateEqualTo(startOfDay)
        .findAll();

    if (existingHabits.isEmpty) {
      final List<String> shalatHabits = [
        'Shalat Shubuh',
        'Shalat Dzuhur',
        'Shalat Ashar',
        'Shalat Maghrib',
        'Shalat Isya',
      ];

      final List<String> puasaHabits = [];
      
      // Puasa Senin-Kamis
      if (startOfDay.weekday == DateTime.monday) {
        puasaHabits.add('Puasa Sunnah Senin');
      } else if (startOfDay.weekday == DateTime.thursday) {
        puasaHabits.add('Puasa Sunnah Kamis');
      }

      // Puasa Ayyamul Bidh (13, 14, 15 Hijri)
      // Apply the same -1 day adjustment as UI
      final adjustedDate = startOfDay.subtract(const Duration(days: 1));
      final hijriDate = HijriCalendar.fromDate(adjustedDate);
      if (hijriDate.hDay == 13 || hijriDate.hDay == 14 || hijriDate.hDay == 15) {
        puasaHabits.add('Puasa Ayyamul Bidh');
      }

      final allHabits = [...shalatHabits, ...puasaHabits];

      final newLogs = allHabits.map((type) => HabitLog()
        ..date = startOfDay
        ..habitType = type
        ..isCompleted = false).toList();

      await _isar.writeTxn(() async {
        await _isar.habitLogs.putAll(newLogs);
      });
    }
  }

  Future<List<HabitLog>> getHabitsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    await _ensureHabitsExistForDate(startOfDay);

    return await _isar.habitLogs
        .filter()
        .dateEqualTo(startOfDay)
        .findAll();
  }

  Future<void> toggleHabit(DateTime date, String type) async {
    final startOfDay = DateTime(date.year, date.month, date.day);

    final habitLog = await _isar.habitLogs
        .filter()
        .dateEqualTo(startOfDay)
        .and()
        .habitTypeEqualTo(type)
        .findFirst();

    await _isar.writeTxn(() async {
      if (habitLog != null) {
        habitLog.isCompleted = !habitLog.isCompleted;
        await _isar.habitLogs.put(habitLog);
      } else {
        // Create it on the fly if missing
        final newLog = HabitLog()
          ..date = startOfDay
          ..habitType = type
          ..isCompleted = true; // First toggle makes it completed
        await _isar.habitLogs.put(newLog);
      }
    });
  }

  Future<Map<DateTime, double>> getStatsForLastNDays(int days, bool includePuasa) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final Map<DateTime, double> stats = {};

    for (int i = 0; i < days; i++) {
      final date = today.subtract(Duration(days: i));
      final logs = await _isar.habitLogs.filter().dateEqualTo(date).findAll();
      
      if (logs.isEmpty) {
        stats[date] = 0.0;
      } else {
        if (includePuasa) {
          // Both Shalat and Puasa must be done
          final completed = logs.where((l) => l.isCompleted).length;
          stats[date] = completed / logs.length;
        } else {
          // Only Shalat counts for 100%
          final shalatLogs = logs.where((l) => l.habitType.contains('Shalat')).toList();
          if (shalatLogs.isEmpty) {
            stats[date] = 0.0;
          } else {
            final completedShalat = shalatLogs.where((l) => l.isCompleted).length;
            stats[date] = completedShalat / shalatLogs.length;
          }
        }
      }
    }
    return stats;
  }

  Future<int> getCurrentStreak(bool includePuasa) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    int streak = 0;
    int i = 0;

    // Check from today or yesterday onwards
    while (true) {
      final date = today.subtract(Duration(days: i));
      final logs = await _isar.habitLogs.filter().dateEqualTo(date).findAll();
      
      if (logs.isEmpty) {
        // If it's today and empty, maybe they haven't started yet, so check yesterday
        if (i == 0) {
          i++;
          continue;
        } else {
          break;
        }
      }

      double completion = 0.0;
      if (includePuasa) {
        completion = logs.where((l) => l.isCompleted).length / logs.length;
      } else {
        final shalatLogs = logs.where((l) => l.habitType.contains('Shalat')).toList();
        completion = shalatLogs.isEmpty ? 0.0 : (shalatLogs.where((l) => l.isCompleted).length / shalatLogs.length);
      }

      if (completion >= 1.0) {
        streak++;
        i++;
      } else {
        // If it's today and not yet 100%, but yesterday was 100%, streak continues (tentatively)
        // But for "current streak", usually we only count if today is 100% or they are still in the process.
        // Let's be strict: if today isn't 100%, but yesterday was, streak is still the one from yesterday.
        if (i == 0) {
          i++;
          continue;
        } else {
          break;
        }
      }
    }
    return streak;
  }

  // Keep for backward compatibility or refactor
  Future<Map<DateTime, double>> getStatsForLast7Days() async {
    return getStatsForLastNDays(7, false);
  }
}
