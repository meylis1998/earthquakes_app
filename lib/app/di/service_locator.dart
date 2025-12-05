import '../../data/repositories/earthquake_repository.dart';
import '../../data/services/cache_service.dart';
import '../../data/services/earthquake_api_service.dart';
import '../../data/services/favorites_service.dart';
import '../../data/services/location_service.dart';

class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator _instance = ServiceLocator._();
  static ServiceLocator get instance => _instance;

  late final CacheService cacheService;
  late final EarthquakeApiService apiService;
  late final EarthquakeRepository earthquakeRepository;
  late final FavoritesService favoritesService;
  late final LocationService locationService;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    cacheService = CacheService();
    await cacheService.init();

    favoritesService = FavoritesService();
    await favoritesService.init();

    locationService = LocationService();

    apiService = EarthquakeApiService();

    earthquakeRepository = EarthquakeRepository(
      apiService: apiService,
      cacheService: cacheService,
    );

    _initialized = true;
  }
}
