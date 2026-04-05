import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../providers/location_provider.dart';
import 'shared_prefs_service.dart';


class LocationService {
  final Ref ref;

  LocationService(this.ref);

  Future<bool> requestPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<void> determineAndSaveLocation() async {
    final hasPermission = await requestPermission();
    if (!hasPermission) {
      throw Exception('Location permissions are denied');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium); // Medium is enough for prayers

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    String city = 'Lokasi Ditemukan';
    if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      city = place.locality ?? 
             place.subAdministrativeArea ?? 
             place.administrativeArea ?? 
             'Lokasi Ditemukan';
    }

    // Save to SharedPrefs
    await ref.read(sharedPrefsServiceProvider).saveLocation(
          position.latitude,
          position.longitude,
          city,
        );
    
    // Refresh the reactive provider
    ref.read(locationProvider.notifier).refresh();
  }

  Future<void> saveManualLocation(String cityName) async {
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        final location = locations.first;
        
        String finalCityName = cityName;
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            finalCityName = place.locality ?? 
                           place.subAdministrativeArea ?? 
                           place.administrativeArea ?? 
                           cityName;
          }
        } catch (_) {
          // ignore
        }

        // Save to SharedPrefs
        await ref.read(sharedPrefsServiceProvider).saveLocation(
              location.latitude,
              location.longitude,
              finalCityName,
            );
        
        // Refresh the reactive provider
        ref.read(locationProvider.notifier).refresh();
      } else {
        throw Exception('Kota tidak ditemukan');
      }
    } catch (e) {
      throw Exception('Gagal mencari kota: $e');
    }
  }
}

final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(ref);
});
