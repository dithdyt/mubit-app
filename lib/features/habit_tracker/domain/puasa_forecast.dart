class PuasaForecast {
  final DateTime date;
  final String title;
  final String type; // e.g., 'Senin-Kamis', 'Ayyamul Bidh'

  PuasaForecast({
    required this.date,
    required this.title,
    required this.type,
  });
}
