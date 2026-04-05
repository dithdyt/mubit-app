import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mubit/core/services/shared_prefs_service.dart';

class LocationState {
  final double? latitude;
  final double? longitude;
  final String? cityName;

  LocationState({this.latitude, this.longitude, this.cityName});

  bool get isSet => latitude != null && longitude != null;

  factory LocationState.fromPrefs(SharedPrefsService prefs) {
    return LocationState(
      latitude: prefs.latitude,
      longitude: prefs.longitude,
      cityName: prefs.cityName,
    );
  }
}

class LocationNotifier extends Notifier<LocationState> {
  @override
  LocationState build() {
    final prefs = ref.watch(sharedPrefsServiceProvider);
    return LocationState.fromPrefs(prefs);
  }

  void refresh() {
    state = LocationState.fromPrefs(ref.read(sharedPrefsServiceProvider));
  }
}

final locationProvider = NotifierProvider<LocationNotifier, LocationState>(() {
  return LocationNotifier();
});
