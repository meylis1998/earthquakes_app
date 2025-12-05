import 'package:equatable/equatable.dart';

import '../../../data/models/earthquake.dart';
import '../../../data/models/filter_options.dart';
import '../../../data/services/location_service.dart';

enum EarthquakeStatus { initial, loading, success, failure }

enum EarthquakeLoadMode { global, nearby }

class EarthquakeState extends Equatable {
  final EarthquakeStatus status;
  final List<EarthquakeFeature> earthquakes;
  final EarthquakeMetadata? metadata;
  final String? selectedEarthquakeId;
  final EarthquakeFeature? selectedEarthquake;
  final MagnitudeFilter magnitude;
  final TimePeriod period;
  final DateTime? lastUpdated;
  final String? errorMessage;
  final bool isAutoRefreshing;

  // Location-related fields
  final EarthquakeLoadMode loadMode;
  final LocationPermissionStatus locationStatus;
  final bool isLoadingLocation;
  final double? userLatitude;
  final double? userLongitude;
  final double searchRadius;
  final String? locationErrorMessage;

  const EarthquakeState({
    this.status = EarthquakeStatus.initial,
    this.earthquakes = const [],
    this.metadata,
    this.selectedEarthquakeId,
    this.selectedEarthquake,
    this.magnitude = MagnitudeFilter.m25,
    this.period = TimePeriod.day,
    this.lastUpdated,
    this.errorMessage,
    this.isAutoRefreshing = false,
    // Location defaults
    this.loadMode = EarthquakeLoadMode.global,
    this.locationStatus = LocationPermissionStatus.unknown,
    this.isLoadingLocation = false,
    this.userLatitude,
    this.userLongitude,
    this.searchRadius = 500,
    this.locationErrorMessage,
  });

  bool get isNearbyMode => loadMode == EarthquakeLoadMode.nearby;
  bool get hasUserLocation => userLatitude != null && userLongitude != null;
  bool get canUseLocation => locationStatus == LocationPermissionStatus.granted;

  EarthquakeState copyWith({
    EarthquakeStatus? status,
    List<EarthquakeFeature>? earthquakes,
    EarthquakeMetadata? metadata,
    String? selectedEarthquakeId,
    EarthquakeFeature? selectedEarthquake,
    MagnitudeFilter? magnitude,
    TimePeriod? period,
    DateTime? lastUpdated,
    String? errorMessage,
    bool? isAutoRefreshing,
    // Location fields
    EarthquakeLoadMode? loadMode,
    LocationPermissionStatus? locationStatus,
    bool? isLoadingLocation,
    double? userLatitude,
    double? userLongitude,
    double? searchRadius,
    String? locationErrorMessage,
  }) {
    return EarthquakeState(
      status: status ?? this.status,
      earthquakes: earthquakes ?? this.earthquakes,
      metadata: metadata ?? this.metadata,
      selectedEarthquakeId: selectedEarthquakeId ?? this.selectedEarthquakeId,
      selectedEarthquake: selectedEarthquake ?? this.selectedEarthquake,
      magnitude: magnitude ?? this.magnitude,
      period: period ?? this.period,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      errorMessage: errorMessage,
      isAutoRefreshing: isAutoRefreshing ?? this.isAutoRefreshing,
      // Location fields
      loadMode: loadMode ?? this.loadMode,
      locationStatus: locationStatus ?? this.locationStatus,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      searchRadius: searchRadius ?? this.searchRadius,
      locationErrorMessage: locationErrorMessage,
    );
  }

  /// Create a copy with location cleared (for switching to global mode)
  EarthquakeState clearLocation() {
    return copyWith(
      loadMode: EarthquakeLoadMode.global,
      userLatitude: null,
      userLongitude: null,
      locationErrorMessage: null,
    );
  }

  @override
  List<Object?> get props => [
        status,
        earthquakes,
        metadata,
        selectedEarthquakeId,
        selectedEarthquake,
        magnitude,
        period,
        lastUpdated,
        errorMessage,
        isAutoRefreshing,
        // Location props
        loadMode,
        locationStatus,
        isLoadingLocation,
        userLatitude,
        userLongitude,
        searchRadius,
        locationErrorMessage,
      ];
}
