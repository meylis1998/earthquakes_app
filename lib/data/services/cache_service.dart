import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../core/constants/api_constants.dart';
import '../../core/exceptions/api_exception.dart';
import '../models/earthquake.dart';
import '../models/filter_options.dart';

class CacheService {
  static const String _boxName = 'earthquake_cache';
  static const String _timestampSuffix = '_timestamp';

  late Box<String> _box;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
    _initialized = true;
  }

  String _getCacheKey(MagnitudeFilter magnitude, TimePeriod period) =>
      '${magnitude.value}_${period.value}';

  Future<void> cacheEarthquakes(
    EarthquakeResponse response,
    MagnitudeFilter magnitude,
    TimePeriod period,
  ) async {
    if (!_initialized) {
      throw CacheException('Cache not initialized');
    }

    final key = _getCacheKey(magnitude, period);
    final jsonString = jsonEncode(response.toJson());

    await _box.put(key, jsonString);
    await _box.put(
      '$key$_timestampSuffix',
      DateTime.now().toIso8601String(),
    );
  }

  Future<EarthquakeResponse?> getCachedEarthquakes(
    MagnitudeFilter magnitude,
    TimePeriod period,
  ) async {
    if (!_initialized) {
      throw CacheException('Cache not initialized');
    }

    final key = _getCacheKey(magnitude, period);
    final jsonString = _box.get(key);

    if (jsonString == null) return null;

    final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
    return EarthquakeResponse.fromJson(jsonMap);
  }

  bool isCacheValid(MagnitudeFilter magnitude, TimePeriod period) {
    if (!_initialized) return false;

    final key = _getCacheKey(magnitude, period);
    final timestampStr = _box.get('$key$_timestampSuffix');

    if (timestampStr == null) return false;

    final timestamp = DateTime.parse(timestampStr);
    final age = DateTime.now().difference(timestamp);

    return age < ApiConstants.cacheValidity;
  }

  DateTime? getLastUpdated(MagnitudeFilter magnitude, TimePeriod period) {
    if (!_initialized) return null;

    final key = _getCacheKey(magnitude, period);
    final timestampStr = _box.get('$key$_timestampSuffix');

    if (timestampStr == null) return null;

    return DateTime.parse(timestampStr);
  }

  Future<void> clearCache() async {
    if (!_initialized) return;
    await _box.clear();
  }
}
