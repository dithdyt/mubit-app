import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mubit/features/habit_tracker/domain/puasa_forecast.dart';

final puasaForecastProvider = Provider.family<List<PuasaForecast>, DateTime>((ref, startDate) {
  final List<PuasaForecast> forecast = [];
  
  // Forecast for the next 30 days starting from startDate
  for (int i = 0; i < 30; i++) {
    final date = startDate.add(Duration(days: i));
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    // 1. Check for Monday/Thursday
    if (normalizedDate.weekday == DateTime.monday) {
      forecast.add(PuasaForecast(
        date: normalizedDate,
        title: 'Puasa Sunnah Senin',
        type: 'Senin-Kamis',
      ));
    } else if (normalizedDate.weekday == DateTime.thursday) {
      forecast.add(PuasaForecast(
        date: normalizedDate,
        title: 'Puasa Sunnah Kamis',
        type: 'Senin-Kamis',
      ));
    }
    
    // 2. Check for Ayyamul Bidh (13, 14, 15 Hijri)
    // Synchronized with -1 day adjustment from header/header
    final hDate = HijriCalendar.fromDate(normalizedDate.subtract(const Duration(days: 1)));
    if (hDate.hDay == 13 || hDate.hDay == 14 || hDate.hDay == 15) {
      forecast.add(PuasaForecast(
        date: normalizedDate,
        title: 'Puasa Ayyamul Bidh',
        type: 'Ayyamul Bidh',
      ));
    }
  }
  
  return forecast;
});
