import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/services/shared_prefs_service.dart';
import 'core/theme/app_theme.dart';
import 'features/habit_tracker/domain/habit_log.dart';

import 'features/splash/ui/splash_screen.dart';

import 'core/services/notification_service.dart';
import 'features/prayer_times/services/prayer_time_service.dart';

late Isar isar;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone database
  tz.initializeTimeZones();

  // Initialize Notification Service
  final notifService = NotificationService();
  await notifService.init();

  // Initialize Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  final sharedPrefs = SharedPrefsService(prefs);

  // Initialize Isar
  final dir = await getApplicationDocumentsDirectory();
  isar = await Isar.open(
    [HabitLogSchema],
    directory: dir.path,
  );

  // Initial scheduling (if location exists)
  final prayerService = PrayerTimeService(sharedPrefs);
  await notifService.schedulePrayerNotifications(
      prayerService: prayerService, 
      prefs: sharedPrefs
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MubitApp(),
    ),
  );
}

class MubitApp extends StatelessWidget {
  const MubitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mubit',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
