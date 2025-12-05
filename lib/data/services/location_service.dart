import 'package:geolocator/geolocator.dart';

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
  unknown,
}

class LocationResult {
  final double? latitude;
  final double? longitude;
  final LocationPermissionStatus status;
  final String? errorMessage;

  const LocationResult({
    this.latitude,
    this.longitude,
    required this.status,
    this.errorMessage,
  });

  bool get hasLocation => latitude != null && longitude != null;

  factory LocationResult.success(Position position) => LocationResult(
        latitude: position.latitude,
        longitude: position.longitude,
        status: LocationPermissionStatus.granted,
      );

  factory LocationResult.error(LocationPermissionStatus status, String message) =>
      LocationResult(
        status: status,
        errorMessage: message,
      );
}

class LocationService {
  static const Duration _timeout = Duration(seconds: 15);

  Future<LocationPermissionStatus> checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    return _mapPermission(permission);
  }

  Future<LocationPermissionStatus> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationPermissionStatus.serviceDisabled;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return _mapPermission(permission);
  }

  Future<LocationResult> getCurrentLocation() async {
    try {
      // Check if service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return LocationResult.error(
          LocationPermissionStatus.serviceDisabled,
          'Location services are disabled. Please enable GPS.',
        );
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return LocationResult.error(
            LocationPermissionStatus.denied,
            'Location permission denied. Please allow location access.',
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return LocationResult.error(
          LocationPermissionStatus.deniedForever,
          'Location permission permanently denied. Please enable in settings.',
        );
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      ).timeout(_timeout);

      return LocationResult.success(position);
    } catch (e) {
      return LocationResult.error(
        LocationPermissionStatus.unknown,
        'Failed to get location: ${e.toString()}',
      );
    }
  }

  Future<Position?> getLastKnownPosition() async {
    try {
      return await Geolocator.getLastKnownPosition();
    } catch (e) {
      return null;
    }
  }

  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  LocationPermissionStatus _mapPermission(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationPermissionStatus.granted;
      case LocationPermission.denied:
        return LocationPermissionStatus.denied;
      case LocationPermission.deniedForever:
        return LocationPermissionStatus.deniedForever;
      case LocationPermission.unableToDetermine:
        return LocationPermissionStatus.unknown;
    }
  }
}
