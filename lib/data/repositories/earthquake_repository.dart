import '../models/earthquake.dart';
import '../models/filter_options.dart';
import '../services/cache_service.dart';
import '../services/earthquake_api_service.dart';

class EarthquakeRepository {
  final EarthquakeApiService _apiService;
  final CacheService _cacheService;

  EarthquakeRepository({
    required EarthquakeApiService apiService,
    required CacheService cacheService,
  })  : _apiService = apiService,
        _cacheService = cacheService;

  Future<EarthquakeResponse> getEarthquakes({
    MagnitudeFilter magnitude = MagnitudeFilter.m25,
    TimePeriod period = TimePeriod.day,
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cacheService.isCacheValid(magnitude, period)) {
      final cached = await _cacheService.getCachedEarthquakes(magnitude, period);
      if (cached != null) return cached;
    }

    try {
      final response = await _apiService.getRecentEarthquakes(
        magnitude: magnitude,
        period: period,
      );

      await _cacheService.cacheEarthquakes(response, magnitude, period);
      return response;
    } catch (e) {
      final cached = await _cacheService.getCachedEarthquakes(magnitude, period);
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<EarthquakeResponse> queryEarthquakes(QueryOptions options) {
    return _apiService.queryEarthquakes(options);
  }

  Future<EarthquakeFeature?> getEarthquakeById(String eventId) {
    return _apiService.getEarthquakeById(eventId);
  }

  Future<EarthquakeResponse> getNearbyEarthquakes({
    required double latitude,
    required double longitude,
    double radiusKm = 500,
    double minMagnitude = 2.5,
    int days = 7,
  }) {
    return _apiService.getEarthquakesNearLocation(
      latitude: latitude,
      longitude: longitude,
      radiusKm: radiusKm,
      minMagnitude: minMagnitude,
      days: days,
    );
  }

  DateTime? getLastUpdated(MagnitudeFilter magnitude, TimePeriod period) {
    return _cacheService.getLastUpdated(magnitude, period);
  }
}
