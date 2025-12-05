import 'package:dio/dio.dart';

import '../../core/constants/api_constants.dart';
import '../../core/exceptions/api_exception.dart';
import '../models/earthquake.dart';
import '../models/filter_options.dart';

class EarthquakeApiService {
  final Dio _dio;

  EarthquakeApiService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: ApiConstants.connectTimeout,
              receiveTimeout: ApiConstants.receiveTimeout,
            ));

  Future<EarthquakeResponse> getRecentEarthquakes({
    MagnitudeFilter magnitude = MagnitudeFilter.m25,
    TimePeriod period = TimePeriod.day,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.feedPath}/${magnitude.value}_${period.value}.geojson',
      );
      return EarthquakeResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<EarthquakeResponse> queryEarthquakes(QueryOptions options) async {
    try {
      final params = <String, dynamic>{
        'format': 'geojson',
        if (options.startTime != null)
          'starttime': options.startTime!.toIso8601String(),
        if (options.endTime != null)
          'endtime': options.endTime!.toIso8601String(),
        if (options.minMagnitude != null) 'minmagnitude': options.minMagnitude,
        if (options.maxMagnitude != null) 'maxmagnitude': options.maxMagnitude,
        if (options.minLatitude != null) 'minlatitude': options.minLatitude,
        if (options.maxLatitude != null) 'maxlatitude': options.maxLatitude,
        if (options.minLongitude != null) 'minlongitude': options.minLongitude,
        if (options.maxLongitude != null) 'maxlongitude': options.maxLongitude,
        if (options.latitude != null) 'latitude': options.latitude,
        if (options.longitude != null) 'longitude': options.longitude,
        if (options.maxRadiusKm != null) 'maxradiuskm': options.maxRadiusKm,
        if (options.limit != null) 'limit': options.limit,
        'orderby': options.orderBy,
        if (options.alertLevel != null) 'alertlevel': options.alertLevel,
      };

      final response = await _dio.get(
        ApiConstants.queryPath,
        queryParameters: params,
      );
      return EarthquakeResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<EarthquakeFeature?> getEarthquakeById(String eventId) async {
    try {
      final response = await _dio.get(
        ApiConstants.queryPath,
        queryParameters: {
          'format': 'geojson',
          'eventid': eventId,
        },
      );
      final data = EarthquakeResponse.fromJson(response.data);
      return data.features.isNotEmpty ? data.features.first : null;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<EarthquakeResponse> getEarthquakesNearLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 500,
    double minMagnitude = 2.5,
    int days = 7,
  }) async {
    final now = DateTime.now().toUtc();
    return queryEarthquakes(QueryOptions(
      latitude: latitude,
      longitude: longitude,
      maxRadiusKm: radiusKm,
      minMagnitude: minMagnitude,
      startTime: now.subtract(Duration(days: days)),
      endTime: now,
      orderBy: 'time',
    ));
  }

  ApiException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Connection timed out. Please try again.',
          originalError: e,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection. Please check your network.',
          originalError: e,
        );
      case DioExceptionType.badResponse:
        return ApiException(
          message: 'Server error: ${e.response?.statusMessage}',
          statusCode: e.response?.statusCode,
          originalError: e,
        );
      default:
        return ApiException(
          message: 'An unexpected error occurred: ${e.message}',
          originalError: e,
        );
    }
  }
}
