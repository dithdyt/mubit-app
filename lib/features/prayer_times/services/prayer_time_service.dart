import 'package:adhan/adhan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart' as tz_lookup;
import '../../../core/services/shared_prefs_service.dart';

class PrayerTimeService {
  final SharedPrefsService _prefs;

  PrayerTimeService(this._prefs);

  CalculationMethod _getCalculationMethod(String methodString) {
    switch (methodString) {
      case 'MWL':
        return CalculationMethod.muslim_world_league;
      case 'ISNA':
        return CalculationMethod.north_america;
      case 'Umm Al-Qura':
        return CalculationMethod.umm_al_qura;
      case 'Kemenag':
      default:
        return CalculationMethod.other;
    }
  }

  Madhab _getMadhab(String madhabString) {
    switch (madhabString) {
      case 'Hanafi':
        return Madhab.hanafi;
      case 'Syafii':
      default:
        return Madhab.shafi;
    }
  }

  CalculationParameters _getParameters() {
    return getParametersFromSettings(_prefs.calculationMethod, _prefs.madhab);
  }

  CalculationParameters getParametersFromSettings(String methodString, String madhabString) {
    var params = _getCalculationMethod(methodString).getParameters();

    if (methodString == 'Kemenag') {
      params.fajrAngle = 20.0;
      params.ishaAngle = 18.0;
    }

    params.madhab = _getMadhab(madhabString);
    return params;
  }

  /// Get the IANA timezone name for the stored coordinates.
  String? getTimezoneForLocation() {
    final lat = _prefs.latitude;
    final lng = _prefs.longitude;
    if (lat == null || lng == null) return null;
    try {
      return tz_lookup.latLngToTimezoneString(lat, lng);
    } catch (_) {
      return null;
    }
  }

  PrayerTimes? getPrayerTimes(DateTime date) {
    final lat = _prefs.latitude;
    final lng = _prefs.longitude;

    if (lat == null || lng == null) {
      return null;
    }

    final coordinates = Coordinates(lat, lng);
    final params = _getParameters();
    final dateComponents = DateComponents.from(date);

    return PrayerTimes(coordinates, dateComponents, params);
  }
}

final prayerTimeServiceProvider = Provider<PrayerTimeService>((ref) {
  final prefs = ref.watch(sharedPrefsServiceProvider);
  return PrayerTimeService(prefs);
});
