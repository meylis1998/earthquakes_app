import 'package:equatable/equatable.dart';

import '../../../data/models/filter_options.dart';

abstract class EarthquakeEvent extends Equatable {
  const EarthquakeEvent();

  @override
  List<Object?> get props => [];
}

class LoadEarthquakes extends EarthquakeEvent {
  final MagnitudeFilter magnitude;
  final TimePeriod period;
  final bool forceRefresh;

  const LoadEarthquakes({
    this.magnitude = MagnitudeFilter.m25,
    this.period = TimePeriod.day,
    this.forceRefresh = false,
  });

  @override
  List<Object?> get props => [magnitude, period, forceRefresh];
}

class RefreshEarthquakes extends EarthquakeEvent {
  const RefreshEarthquakes();
}

class LoadEarthquakeById extends EarthquakeEvent {
  final String eventId;

  const LoadEarthquakeById(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class LoadNearbyEarthquakes extends EarthquakeEvent {
  final double latitude;
  final double longitude;
  final double radiusKm;
  final double minMagnitude;
  final int days;

  const LoadNearbyEarthquakes({
    required this.latitude,
    required this.longitude,
    this.radiusKm = 500,
    this.minMagnitude = 2.5,
    this.days = 7,
  });

  @override
  List<Object?> get props => [latitude, longitude, radiusKm, minMagnitude, days];
}

class SelectEarthquake extends EarthquakeEvent {
  final String? earthquakeId;

  const SelectEarthquake(this.earthquakeId);

  @override
  List<Object?> get props => [earthquakeId];
}

class StartAutoRefresh extends EarthquakeEvent {
  const StartAutoRefresh();
}

class StopAutoRefresh extends EarthquakeEvent {
  const StopAutoRefresh();
}

/// Initialize app with automatic geolocation detection
class InitializeWithLocation extends EarthquakeEvent {
  final double searchRadius;
  final double minMagnitude;
  final int days;

  const InitializeWithLocation({
    this.searchRadius = 500,
    this.minMagnitude = 2.5,
    this.days = 30,
  });

  @override
  List<Object?> get props => [searchRadius, minMagnitude, days];
}

/// Request location permission and load nearby earthquakes
class RequestLocationPermission extends EarthquakeEvent {
  const RequestLocationPermission();
}

/// Switch to global mode (load all earthquakes)
class SwitchToGlobalMode extends EarthquakeEvent {
  const SwitchToGlobalMode();
}

/// Switch to nearby mode with current/last known location
class SwitchToNearbyMode extends EarthquakeEvent {
  const SwitchToNearbyMode();
}

/// Update search radius for nearby mode
class UpdateSearchRadius extends EarthquakeEvent {
  final double radius;

  const UpdateSearchRadius(this.radius);

  @override
  List<Object?> get props => [radius];
}
