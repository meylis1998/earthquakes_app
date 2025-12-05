class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://earthquake.usgs.gov';
  static const String feedPath = '/earthquakes/feed/v1.0/summary';
  static const String queryPath = '/fdsnws/event/1/query';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const Duration cacheValidity = Duration(minutes: 5);
  static const Duration refreshInterval = Duration(minutes: 5);
  static const Duration minRefreshCooldown = Duration(seconds: 30);

  static String getFeedUrl(String magnitude, String period) =>
      '$baseUrl$feedPath/${magnitude}_$period.geojson';
}
