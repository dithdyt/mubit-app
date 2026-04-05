import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider not initialized');
});

class SharedPrefsService {
  final SharedPreferences _prefs;

  SharedPrefsService(this._prefs);

  static const String keyLatitude = 'latitude';
  static const String keyLongitude = 'longitude';
  static const String keyCityName = 'city_name';
  static const String keyCalculationMethod = 'calculation_method';
  static const String keyMadhab = 'madhab';
  static const String keyIncludePuasa = 'include_puasa_in_target';

  // Location
  Future<void> saveLocation(double lat, double lng, String city) async {
    await _prefs.setDouble(keyLatitude, lat);
    await _prefs.setDouble(keyLongitude, lng);
    await _prefs.setString(keyCityName, city);
  }

  double? get latitude => _prefs.getDouble(keyLatitude);
  double? get longitude => _prefs.getDouble(keyLongitude);
  String? get cityName => _prefs.getString(keyCityName);

  // Settings
  Future<void> saveCalculationMethod(String method) async {
    await _prefs.setString(keyCalculationMethod, method);
  }

  String get calculationMethod =>
      _prefs.getString(keyCalculationMethod) ?? 'Kemenag'; // Default Kemenag

  Future<void> saveMadhab(String madhab) async {
    await _prefs.setString(keyMadhab, madhab);
  }

  String get madhab => _prefs.getString(keyMadhab) ?? 'Syafii'; // Default Syafii

  // Habit Target
  Future<void> saveIncludePuasa(bool value) async {
    await _prefs.setBool(keyIncludePuasa, value);
  }

  bool get includePuasaInTarget => _prefs.getBool(keyIncludePuasa) ?? false;

  // Notification Toggles
  Future<void> saveNotificationToggle(String prayerName, bool isOn) async {
    await _prefs.setBool('notif_$prayerName', isOn);
  }

  bool getNotificationToggle(String prayerName) {
    return _prefs.getBool('notif_$prayerName') ?? true; // Default ON
  }

  bool get isSubuhNotifEnabled => getNotificationToggle('Subuh');
  bool get isDzuhurNotifEnabled => getNotificationToggle('Dzuhur');
  bool get isAsharNotifEnabled => getNotificationToggle('Ashar');
  bool get isMaghribNotifEnabled => getNotificationToggle('Maghrib');
  bool get isIsyaNotifEnabled => getNotificationToggle('Isya');
}

final sharedPrefsServiceProvider = Provider<SharedPrefsService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SharedPrefsService(prefs);
});
