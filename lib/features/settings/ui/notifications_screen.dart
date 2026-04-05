import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mubit/core/services/shared_prefs_service.dart';
import 'package:mubit/core/theme/app_theme.dart';
import 'package:mubit/core/services/notification_service.dart';
import 'package:mubit/features/prayer_times/services/prayer_time_service.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(sharedPrefsServiceProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundWhite,
        elevation: 0,
        title: Text(
          'Notifikasi',
          style: GoogleFonts.philosopher(
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryGreen,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationTile('Subuh', prefs.isSubuhNotifEnabled, prefs),
          _buildNotificationTile('Dzuhur', prefs.isDzuhurNotifEnabled, prefs),
          _buildNotificationTile('Ashar', prefs.isAsharNotifEnabled, prefs),
          _buildNotificationTile('Maghrib', prefs.isMaghribNotifEnabled, prefs),
          _buildNotificationTile('Isya', prefs.isIsyaNotifEnabled, prefs),
        ],
      ),
    );
  }

  Widget _buildNotificationTile(String prayer, bool value, SharedPrefsService prefs) {
    return SwitchListTile(
      title: Text(prayer),
      subtitle: Text('Ingatkan saat masuk waktu $prayer'),
      activeThumbColor: AppTheme.primaryGreen,
      value: value,
      onChanged: (bool newValue) async {
        await prefs.saveNotificationToggle(prayer, newValue);
        setState(() {});
        final prayerService = ref.read(prayerTimeServiceProvider);
        _reschedule(prayerService, prefs);
      },
    );
  }

  void _reschedule(PrayerTimeService prayerService, SharedPrefsService prefs) {
    NotificationService().schedulePrayerNotifications(
      prayerService: prayerService,
      prefs: prefs,
    );
  }
}
