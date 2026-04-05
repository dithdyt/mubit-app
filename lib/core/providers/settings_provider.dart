import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mubit/core/services/shared_prefs_service.dart';

class PrayerSettingsState {
  final String calculationMethod;
  final String madhab;

  PrayerSettingsState({
    required this.calculationMethod,
    required this.madhab,
  });

  factory PrayerSettingsState.fromPrefs(SharedPrefsService prefs) {
    return PrayerSettingsState(
      calculationMethod: prefs.calculationMethod,
      madhab: prefs.madhab,
    );
  }
}

class PrayerSettingsNotifier extends Notifier<PrayerSettingsState> {
  @override
  PrayerSettingsState build() {
    final prefs = ref.watch(sharedPrefsServiceProvider);
    return PrayerSettingsState.fromPrefs(prefs);
  }

  Future<void> updateCalculationMethod(String method) async {
    await ref.read(sharedPrefsServiceProvider).saveCalculationMethod(method);
    state = PrayerSettingsState.fromPrefs(ref.read(sharedPrefsServiceProvider));
  }

  Future<void> updateMadhab(String madhab) async {
    await ref.read(sharedPrefsServiceProvider).saveMadhab(madhab);
    state = PrayerSettingsState.fromPrefs(ref.read(sharedPrefsServiceProvider));
  }
}

final prayerSettingsProvider = NotifierProvider<PrayerSettingsNotifier, PrayerSettingsState>(() {
  return PrayerSettingsNotifier();
});
