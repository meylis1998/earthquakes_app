import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/api_constants.dart';
import '../../../data/repositories/earthquake_repository.dart';
import '../../../data/services/location_service.dart';
import 'earthquake_event.dart';
import 'earthquake_state.dart';

class EarthquakeBloc extends Bloc<EarthquakeEvent, EarthquakeState> {
  final EarthquakeRepository _repository;
  final LocationService _locationService;
  Timer? _autoRefreshTimer;

  EarthquakeBloc({
    required EarthquakeRepository repository,
    required LocationService locationService,
  })  : _repository = repository,
        _locationService = locationService,
        super(const EarthquakeState()) {
    on<LoadEarthquakes>(_onLoadEarthquakes);
    on<RefreshEarthquakes>(_onRefreshEarthquakes);
    on<LoadEarthquakeById>(_onLoadEarthquakeById);
    on<LoadNearbyEarthquakes>(_onLoadNearbyEarthquakes);
    on<SelectEarthquake>(_onSelectEarthquake);
    on<StartAutoRefresh>(_onStartAutoRefresh);
    on<StopAutoRefresh>(_onStopAutoRefresh);
    // Location events
    on<InitializeWithLocation>(_onInitializeWithLocation);
    on<RequestLocationPermission>(_onRequestLocationPermission);
    on<SwitchToGlobalMode>(_onSwitchToGlobalMode);
    on<SwitchToNearbyMode>(_onSwitchToNearbyMode);
    on<UpdateSearchRadius>(_onUpdateSearchRadius);
  }

  /// Initialize app with automatic geolocation detection
  Future<void> _onInitializeWithLocation(
    InitializeWithLocation event,
    Emitter<EarthquakeState> emit,
  ) async {
    emit(state.copyWith(
      status: EarthquakeStatus.loading,
      isLoadingLocation: true,
      searchRadius: event.searchRadius,
    ));

    // Try to get location
    final locationResult = await _locationService.getCurrentLocation();

    if (locationResult.hasLocation) {
      // Success - load nearby earthquakes
      emit(state.copyWith(
        locationStatus: LocationPermissionStatus.granted,
        isLoadingLocation: false,
        userLatitude: locationResult.latitude,
        userLongitude: locationResult.longitude,
        loadMode: EarthquakeLoadMode.nearby,
      ));

      // Load nearby earthquakes
      try {
        final response = await _repository.getNearbyEarthquakes(
          latitude: locationResult.latitude!,
          longitude: locationResult.longitude!,
          radiusKm: event.searchRadius,
          minMagnitude: event.minMagnitude,
          days: event.days,
        );

        emit(state.copyWith(
          status: EarthquakeStatus.success,
          earthquakes: response.features,
          metadata: response.metadata,
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(state.copyWith(
          status: EarthquakeStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    } else {
      // Location failed - fallback to global mode
      emit(state.copyWith(
        locationStatus: locationResult.status,
        isLoadingLocation: false,
        loadMode: EarthquakeLoadMode.global,
        locationErrorMessage: locationResult.errorMessage,
      ));

      // Load global earthquakes as fallback
      add(const LoadEarthquakes());
    }
  }

  /// Request location permission explicitly
  Future<void> _onRequestLocationPermission(
    RequestLocationPermission event,
    Emitter<EarthquakeState> emit,
  ) async {
    emit(state.copyWith(isLoadingLocation: true));

    final status = await _locationService.requestPermission();

    emit(state.copyWith(
      locationStatus: status,
      isLoadingLocation: false,
    ));

    if (status == LocationPermissionStatus.granted) {
      // Permission granted - try to switch to nearby mode
      add(const SwitchToNearbyMode());
    }
  }

  /// Switch to global mode
  Future<void> _onSwitchToGlobalMode(
    SwitchToGlobalMode event,
    Emitter<EarthquakeState> emit,
  ) async {
    emit(state.copyWith(
      loadMode: EarthquakeLoadMode.global,
      locationErrorMessage: null,
    ));

    add(LoadEarthquakes(
      magnitude: state.magnitude,
      period: state.period,
    ));
  }

  /// Switch to nearby mode
  Future<void> _onSwitchToNearbyMode(
    SwitchToNearbyMode event,
    Emitter<EarthquakeState> emit,
  ) async {
    emit(state.copyWith(
      status: EarthquakeStatus.loading,
      isLoadingLocation: true,
    ));

    final locationResult = await _locationService.getCurrentLocation();

    if (locationResult.hasLocation) {
      emit(state.copyWith(
        locationStatus: LocationPermissionStatus.granted,
        isLoadingLocation: false,
        userLatitude: locationResult.latitude,
        userLongitude: locationResult.longitude,
        loadMode: EarthquakeLoadMode.nearby,
      ));

      // Load nearby earthquakes
      try {
        final response = await _repository.getNearbyEarthquakes(
          latitude: locationResult.latitude!,
          longitude: locationResult.longitude!,
          radiusKm: state.searchRadius,
          minMagnitude: 2.5,
          days: 30,
        );

        emit(state.copyWith(
          status: EarthquakeStatus.success,
          earthquakes: response.features,
          metadata: response.metadata,
          lastUpdated: DateTime.now(),
        ));
      } catch (e) {
        emit(state.copyWith(
          status: EarthquakeStatus.failure,
          errorMessage: e.toString(),
        ));
      }
    } else {
      emit(state.copyWith(
        locationStatus: locationResult.status,
        isLoadingLocation: false,
        locationErrorMessage: locationResult.errorMessage,
      ));
    }
  }

  /// Update search radius
  Future<void> _onUpdateSearchRadius(
    UpdateSearchRadius event,
    Emitter<EarthquakeState> emit,
  ) async {
    emit(state.copyWith(searchRadius: event.radius));

    // If in nearby mode with location, reload with new radius
    if (state.isNearbyMode && state.hasUserLocation) {
      add(LoadNearbyEarthquakes(
        latitude: state.userLatitude!,
        longitude: state.userLongitude!,
        radiusKm: event.radius,
      ));
    }
  }

  Future<void> _onLoadEarthquakes(
    LoadEarthquakes event,
    Emitter<EarthquakeState> emit,
  ) async {
    emit(state.copyWith(
      status: EarthquakeStatus.loading,
      magnitude: event.magnitude,
      period: event.period,
      loadMode: EarthquakeLoadMode.global,
    ));

    try {
      final response = await _repository.getEarthquakes(
        magnitude: event.magnitude,
        period: event.period,
        forceRefresh: event.forceRefresh,
      );

      emit(state.copyWith(
        status: EarthquakeStatus.success,
        earthquakes: response.features,
        metadata: response.metadata,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EarthquakeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRefreshEarthquakes(
    RefreshEarthquakes event,
    Emitter<EarthquakeState> emit,
  ) async {
    try {
      if (state.isNearbyMode && state.hasUserLocation) {
        // Refresh nearby earthquakes
        final response = await _repository.getNearbyEarthquakes(
          latitude: state.userLatitude!,
          longitude: state.userLongitude!,
          radiusKm: state.searchRadius,
          minMagnitude: 2.5,
          days: 30,
        );

        emit(state.copyWith(
          status: EarthquakeStatus.success,
          earthquakes: response.features,
          metadata: response.metadata,
          lastUpdated: DateTime.now(),
        ));
      } else {
        // Refresh global earthquakes
        final response = await _repository.getEarthquakes(
          magnitude: state.magnitude,
          period: state.period,
          forceRefresh: true,
        );

        emit(state.copyWith(
          status: EarthquakeStatus.success,
          earthquakes: response.features,
          metadata: response.metadata,
          lastUpdated: DateTime.now(),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: EarthquakeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLoadEarthquakeById(
    LoadEarthquakeById event,
    Emitter<EarthquakeState> emit,
  ) async {
    emit(state.copyWith(selectedEarthquakeId: event.eventId));

    try {
      final earthquake = await _repository.getEarthquakeById(event.eventId);
      emit(state.copyWith(selectedEarthquake: earthquake));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Failed to load earthquake details: ${e.toString()}',
      ));
    }
  }

  Future<void> _onLoadNearbyEarthquakes(
    LoadNearbyEarthquakes event,
    Emitter<EarthquakeState> emit,
  ) async {
    emit(state.copyWith(
      status: EarthquakeStatus.loading,
      loadMode: EarthquakeLoadMode.nearby,
      userLatitude: event.latitude,
      userLongitude: event.longitude,
      searchRadius: event.radiusKm,
    ));

    try {
      final response = await _repository.getNearbyEarthquakes(
        latitude: event.latitude,
        longitude: event.longitude,
        radiusKm: event.radiusKm,
        minMagnitude: event.minMagnitude,
        days: event.days,
      );

      emit(state.copyWith(
        status: EarthquakeStatus.success,
        earthquakes: response.features,
        metadata: response.metadata,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EarthquakeStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onSelectEarthquake(
    SelectEarthquake event,
    Emitter<EarthquakeState> emit,
  ) {
    if (event.earthquakeId == null) {
      emit(state.copyWith(
        selectedEarthquakeId: null,
        selectedEarthquake: null,
      ));
      return;
    }

    final earthquake = state.earthquakes.firstWhere(
      (e) => e.id == event.earthquakeId,
      orElse: () => state.earthquakes.first,
    );

    emit(state.copyWith(
      selectedEarthquakeId: event.earthquakeId,
      selectedEarthquake: earthquake,
    ));
  }

  void _onStartAutoRefresh(
    StartAutoRefresh event,
    Emitter<EarthquakeState> emit,
  ) {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = Timer.periodic(
      ApiConstants.refreshInterval,
      (_) => add(const RefreshEarthquakes()),
    );
    emit(state.copyWith(isAutoRefreshing: true));
  }

  void _onStopAutoRefresh(
    StopAutoRefresh event,
    Emitter<EarthquakeState> emit,
  ) {
    _autoRefreshTimer?.cancel();
    _autoRefreshTimer = null;
    emit(state.copyWith(isAutoRefreshing: false));
  }

  @override
  Future<void> close() {
    _autoRefreshTimer?.cancel();
    return super.close();
  }
}
