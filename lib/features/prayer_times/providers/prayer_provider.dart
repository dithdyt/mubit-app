import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:mubit/core/providers/date_provider.dart';
import 'package:mubit/core/providers/location_provider.dart';

import 'package:mubit/core/providers/settings_provider.dart';
import '../services/prayer_time_service.dart';

/// Converts a UTC DateTime from the Adhan engine to the display time
/// for the specified IANA timezone (e.g., "America/New_York").
/// Falls back to device local time if the timezone name is invalid.
DateTime _convertUtcToLocationTime(DateTime utcTime, String timezoneName) {
  if (timezoneName.isEmpty) return utcTime.toLocal();
  try {
    final location = tz.getLocation(timezoneName);
    final tzTime = tz.TZDateTime.from(utcTime, location);
    // Return a plain DateTime with the correct h/m/s for that location
    return DateTime(
      tzTime.year, tzTime.month, tzTime.day,
      tzTime.hour, tzTime.minute, tzTime.second,
    );
  } catch (_) {
    return utcTime.toLocal();
  }
}

String _prayerName(Prayer prayer) {
  switch (prayer) {
    case Prayer.fajr: return 'Subuh';
    case Prayer.sunrise: return 'Terbit';
    case Prayer.dhuhr: return 'Dzuhur';
    case Prayer.asr: return 'Ashar';
    case Prayer.maghrib: return 'Maghrib';
    case Prayer.isha: return 'Isya';
    default: return '';
  }
}

// Wrapper class for easier UI consumption
class DailyPrayerTimes {
  final PrayerTimes _prayerTimes;
  final String _timezoneName;

  DailyPrayerTimes(this._prayerTimes, this._timezoneName);

  DateTime _convert(DateTime utcTime) =>
      _convertUtcToLocationTime(utcTime, _timezoneName);

  // Helper for 24h formatting
  String _format(DateTime time) => DateFormat.Hm().format(time);

  String get imsak {
    final fajrTime = _convert(_prayerTimes.fajr);
    final imsakTime = fajrTime.subtract(const Duration(minutes: 10));
    return _format(imsakTime);
  }

  String get fajr => _format(_convert(_prayerTimes.fajr));
  String get sunrise => _format(_convert(_prayerTimes.sunrise));
  String get dhuhr => _format(_convert(_prayerTimes.dhuhr));
  String get asr => _format(_convert(_prayerTimes.asr));
  String get maghrib => _format(_convert(_prayerTimes.maghrib));
  String get isha => _format(_convert(_prayerTimes.isha));

  Prayer get currentPrayer => _prayerTimes.currentPrayer();
  Prayer get nextPrayer => _prayerTimes.nextPrayer();

  /// Returns the name string of the next prayer (in Bahasa Indonesia).
  String get nextPrayerName => _prayerName(_prayerTimes.nextPrayer());

  /// Returns the next prayer's time as a plain DateTime in the location's timezone.
  DateTime? getNextPrayerTime() {
    final next = _prayerTimes.nextPrayer();
    switch (next) {
      case Prayer.fajr: return _convert(_prayerTimes.fajr);
      case Prayer.sunrise: return _convert(_prayerTimes.sunrise);
      case Prayer.dhuhr: return _convert(_prayerTimes.dhuhr);
      case Prayer.asr: return _convert(_prayerTimes.asr);
      case Prayer.maghrib: return _convert(_prayerTimes.maghrib);
      case Prayer.isha: return _convert(_prayerTimes.isha);
      default: return null;
    }
  }
}

// Emits the prayer times for the currently selected date.
// Returns null if location has not been set yet.
final dailyPrayerTimesProvider = Provider<AsyncValue<DailyPrayerTimes>>((ref) {
  final date = ref.watch(selectedDateProvider);
  final location = ref.watch(locationProvider);
  final settings = ref.watch(prayerSettingsProvider);
  final service = ref.watch(prayerTimeServiceProvider);

  if (!location.isSet) {
    return const AsyncValue.error('LocationNotSet', StackTrace.empty);
  }

  try {
    // We use parameters from the reactive settings provider
    final coordinates = Coordinates(location.latitude!, location.longitude!);
    final dateComponents = DateComponents.from(date);
    
    // Create params manually to ensure it's reactive to the 'settings' object
    final params = service.getParametersFromSettings(settings.calculationMethod, settings.madhab);
    
    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);
    final timezoneName = service.getTimezoneForLocation() ?? '';
    
    return AsyncValue.data(DailyPrayerTimes(prayerTimes, timezoneName));
  } catch (e, st) {
    return AsyncValue.error(e, st);
  }
});
