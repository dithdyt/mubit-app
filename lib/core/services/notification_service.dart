import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:mubit/features/prayer_times/services/prayer_time_service.dart';
import 'package:mubit/core/services/shared_prefs_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );
  }

  Future<void> schedulePrayerNotifications({
    required PrayerTimeService prayerService,
    required SharedPrefsService prefs,
  }) async {
    // 1. Cancel all existing notifications first to avoid duplicates
    await _notificationsPlugin.cancelAll();

    final lat = prefs.latitude;
    final lng = prefs.longitude;
    if (lat == null || lng == null) return;

    final timezoneName = prayerService.getTimezoneForLocation() ?? 'UTC';
    final location = tz.getLocation(timezoneName);

    // 2. Schedule for the next 7 days
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
     final date = now.add(Duration(days: i));
     final prayerTimes = prayerService.getPrayerTimes(date);

     if (prayerTimes != null) {
       _schedulePrayer(prayerTimes.fajr, 'Subuh', i * 6 + 1, location, prefs.isSubuhNotifEnabled);
       _schedulePrayer(prayerTimes.dhuhr, 'Dzuhur', i * 6 + 2, location, prefs.isDzuhurNotifEnabled);
       _schedulePrayer(prayerTimes.asr, 'Ashar', i * 6 + 3, location, prefs.isAsharNotifEnabled);
       _schedulePrayer(prayerTimes.maghrib, 'Maghrib', i * 6 + 4, location, prefs.isMaghribNotifEnabled);
       _schedulePrayer(prayerTimes.isha, 'Isya', i * 6 + 5, location, prefs.isIsyaNotifEnabled);
     }
    }
  }

  Future<void> _schedulePrayer(
    DateTime utcTime,
    String prayerName,
    int id,
    tz.Location location,
    bool isEnabled,
  ) async {
    if (!isEnabled) return;

    final scheduledDate = tz.TZDateTime.from(utcTime, location);

    // Don't schedule if the time has already passed
    if (scheduledDate.isBefore(tz.TZDateTime.now(location))) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'prayer_alerts',
      'Prayer Alerts',
      channelDescription: 'Notifications for prayer times',
      importance: Importance.max,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('adzan'), // Needs adzan.mp3 in res/raw
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'adzan.caf', // Needs adzan.caf in app bundle
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.zonedSchedule(
      id,
      'Waktunya Menuju Shalat',
      'Sudah masuk waktu shalat $prayerName. Mari tunaikan!',
      scheduledDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
