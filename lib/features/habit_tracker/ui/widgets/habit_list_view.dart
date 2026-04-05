import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mubit/core/theme/app_theme.dart';
import 'package:mubit/features/habit_tracker/providers/habit_provider.dart';
import 'package:mubit/features/prayer_times/providers/prayer_provider.dart';
import 'package:mubit/features/habit_tracker/providers/puasa_provider.dart';
import 'package:collection/collection.dart';

class HabitListView extends ConsumerWidget {
  final DateTime date;
  final String category;

  const HabitListView({
    super.key, 
    required this.date, 
    required this.category,
    this.onSetLocation,
  });

  final VoidCallback? onSetLocation;


  String _getCountdownText(DateTime habitDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final diffDate = DateTime(habitDate.year, habitDate.month, habitDate.day);
    final difference = diffDate.difference(today).inDays;

    if (difference == 0) return 'Hari Ini';
    if (difference == 1) return 'Besok';
    if (difference == -1) return 'Kemarin';
    if (difference < 0) return '${difference.abs()} Hari Lalu';
    return '$difference Hari Lagi';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (category == 'Shalat') {
      return _buildShalatList(context, ref);
    } else {
      return _buildPuasaView(context, ref);
    }
  }

  Widget _buildShalatList(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitListProvider(date));
    final prayerTimes = ref.watch(dailyPrayerTimesProvider);

    return habitsAsync.when(
      data: (habits) {
        final filteredHabits = habits.where((h) => h.habitType.contains('Shalat')).toList();

        return prayerTimes.when(
          data: (times) {
            // Define the display sequence with Imsak and Syuruq
            final List<Widget> listItems = [];

            // 1. Imsak (Subtle)
            listItems.add(HabitCard(
              title: 'Imsak',
              subtitle: times.imsak,
              isCompleted: false,
              showCheckbox: false,
              isSubtle: true,
            ));

            // 2. Subuh (Fajr)
            final subuhHabit = filteredHabits.firstWhereOrNull((h) => h.habitType.contains('Shubuh'));
            if (subuhHabit != null) {
              listItems.add(HabitCard(
                title: subuhHabit.habitType,
                subtitle: times.fajr,
                isCompleted: subuhHabit.isCompleted,
                onToggle: () => ref.read(habitListProvider(date).notifier).toggleHabit(subuhHabit.habitType),
              ));
            }

            // 3. Terbit / Syuruq (Subtle)
            listItems.add(HabitCard(
              title: 'Terbit (Syuruq)',
              subtitle: times.sunrise,
              isCompleted: false,
              showCheckbox: false,
              isSubtle: true,
            ));

            // 4. Dzuhur
            final dzuhurHabit = filteredHabits.firstWhereOrNull((h) => h.habitType.contains('Dzuhur'));
            if (dzuhurHabit != null) {
              listItems.add(HabitCard(
                title: dzuhurHabit.habitType,
                subtitle: times.dhuhr,
                isCompleted: dzuhurHabit.isCompleted,
                onToggle: () => ref.read(habitListProvider(date).notifier).toggleHabit(dzuhurHabit.habitType),
              ));
            }

            // 5. Ashar
            final asharHabit = filteredHabits.firstWhereOrNull((h) => h.habitType.contains('Ashar'));
            if (asharHabit != null) {
              listItems.add(HabitCard(
                title: asharHabit.habitType,
                subtitle: times.asr,
                isCompleted: asharHabit.isCompleted,
                onToggle: () => ref.read(habitListProvider(date).notifier).toggleHabit(asharHabit.habitType),
              ));
            }

            // 6. Maghrib
            final maghribHabit = filteredHabits.firstWhereOrNull((h) => h.habitType.contains('Maghrib'));
            if (maghribHabit != null) {
              listItems.add(HabitCard(
                title: maghribHabit.habitType,
                subtitle: times.maghrib,
                isCompleted: maghribHabit.isCompleted,
                onToggle: () => ref.read(habitListProvider(date).notifier).toggleHabit(maghribHabit.habitType),
              ));
            }

            // 7. Isya
            final isyaHabit = filteredHabits.firstWhereOrNull((h) => h.habitType.contains('Isya'));
            if (isyaHabit != null) {
              listItems.add(HabitCard(
                title: isyaHabit.habitType,
                subtitle: times.isha,
                isCompleted: isyaHabit.isCompleted,
                onToggle: () => ref.read(habitListProvider(date).notifier).toggleHabit(isyaHabit.habitType),
              ));
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              children: listItems,
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) {
            if (err == 'LocationNotSet') {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_off_rounded, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 24),
                      Text(
                        'Jadwal shalat belum tersedia. Silakan aktifkan GPS atau pilih lokasi manual terlebih dahulu.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: onSetLocation,
                        icon: const Icon(Icons.location_on_rounded),
                        label: const Text('Set Lokasi'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return Center(child: Text('Gagal menghitung jadwal: $err'));
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Error: $e')),
    );
  }

  Widget _buildPuasaView(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _buildUpcomingCarousel(ref),
        Expanded(child: _buildSelectedDateList(ref)),
      ],
    );
  }

  Widget _buildUpcomingCarousel(WidgetRef ref) {
    final today = DateTime.now();
    // Get actual forecast from today
    final forecast = ref.watch(puasaForecastProvider(today));
    // Exclude today if it's already past noon? No, just show upcoming or today
    final upcomingList = forecast.where((e) => e.date.isAfter(today.subtract(const Duration(days: 1)))).take(5).toList();

    return Container(
      height: 100,
      margin: const EdgeInsets.only(top: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: upcomingList.length,
        itemBuilder: (context, index) {
          final item = upcomingList[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.2)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getCountdownText(item.date),
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedDateList(WidgetRef ref) {
    final searchDate = DateTime(date.year, date.month, date.day);
    // Find if the selected date has any fasts
    final forecastForSelectedDate = ref.watch(puasaForecastProvider(searchDate));
    final todayPuasa = forecastForSelectedDate.where((p) {
      final pDate = DateTime(p.date.year, p.date.month, p.date.day);
      return pDate.isAtSameMomentAs(searchDate);
    }).toList();

    if (todayPuasa.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy_rounded, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Tidak ada jadwal puasa sunnah', 
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    final today = DateTime.now();
    final realToday = DateTime(today.year, today.month, today.day);
    final isFuture = searchDate.isAfter(realToday);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todayPuasa.length,
      itemBuilder: (context, index) {
        final item = todayPuasa[index];

        final habitsForDate = ref.watch(habitListProvider(searchDate));
        bool isCompleted = false;
        habitsForDate.whenData((habits) {
          final habit = habits.firstWhereOrNull((h) => h.habitType == item.title);
          isCompleted = habit?.isCompleted ?? false;
        });

        return HabitCard(
          title: item.title,
          subtitle: isFuture ? 'Akan Datang' : 'Hari Ini',
          isCompleted: isCompleted,
          showCheckbox: !isFuture, // Only show checkbox for past/today
          onToggle: isFuture ? null : () {
            ref.read(habitListProvider(searchDate).notifier).toggleHabit(item.title);
          },
        );
      },
    );
  }
}

class HabitCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isCompleted;
  final bool showCheckbox;
  final bool isSubtle; // For informational items like Imsak/Syuruq
  final VoidCallback? onToggle;

  const HabitCard({
    super.key, 
    required this.title,
    this.subtitle,
    required this.isCompleted,
    this.showCheckbox = true,
    this.isSubtle = false,
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isSubtle ? Colors.transparent : Colors.white,
        borderRadius: BorderRadius.circular(isSubtle ? 12 : 20),
        child: InkWell(
          borderRadius: BorderRadius.circular(isSubtle ? 12 : 20),
          onTap: isSubtle ? null : onToggle,
          child: Container(
            padding: EdgeInsets.all(isSubtle ? 12 : 16),
            decoration: BoxDecoration(
              color: isSubtle ? AppTheme.primaryGreen.withValues(alpha: 0.08) : null,
              borderRadius: BorderRadius.circular(isSubtle ? 12 : 20),
              border: isSubtle 
                ? Border.all(color: AppTheme.primaryGreen.withValues(alpha: 0.1))
                : Border.all(color: Colors.grey.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isSubtle ? 14 : 16,
                          fontWeight: isSubtle ? FontWeight.w600 : FontWeight.bold,
                          color: isSubtle ? Colors.black87 : (isCompleted ? Colors.grey : Colors.black87),
                          decoration: isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: isSubtle ? 12 : 13,
                            color: isSubtle 
                                ? AppTheme.primaryGreen.withValues(alpha: 0.8) // Darker for better contrast
                                : AppTheme.primaryGreen.withValues(alpha: 0.7),
                            fontWeight: isSubtle ? FontWeight.w600 : FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                if (showCheckbox)
                  Checkbox(
                    value: isCompleted,
                    onChanged: onToggle != null ? (_) => onToggle!() : null,
                    activeColor: AppTheme.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
