import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../data/models/filter_options.dart';
import '../../data/services/location_service.dart';
import '../bloc/bloc_exports.dart';
import '../widgets/earthquake_card.dart';
import '../widgets/error_view.dart';
import '../widgets/filter_sheet.dart';

class EarthquakeListScreen extends StatefulWidget {
  const EarthquakeListScreen({super.key});

  @override
  State<EarthquakeListScreen> createState() => _EarthquakeListScreenState();
}

class _EarthquakeListScreenState extends State<EarthquakeListScreen> {
  @override
  void initState() {
    super.initState();
    _initializeWithLocation();
  }

  void _initializeWithLocation() {
    // Initialize with auto-location detection
    context.read<EarthquakeBloc>().add(const InitializeWithLocation());
  }

  void _loadGlobalEarthquakes() {
    final filters = context.read<FilterCubit>().state;
    context.read<EarthquakeBloc>().add(LoadEarthquakes(
          magnitude: filters.magnitude,
          period: filters.period,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquakes'),
        actions: [
          // Location mode toggle
          BlocBuilder<EarthquakeBloc, EarthquakeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isNearbyMode ? Icons.my_location : Icons.public,
                  color: state.isNearbyMode
                      ? Theme.of(context).colorScheme.primary
                      : null,
                ),
                tooltip: state.isNearbyMode ? 'Nearby Mode' : 'Global Mode',
                onPressed: () {
                  if (state.isNearbyMode) {
                    context.read<EarthquakeBloc>().add(const SwitchToGlobalMode());
                  } else {
                    context.read<EarthquakeBloc>().add(const SwitchToNearbyMode());
                  }
                },
              );
            },
          ),
          BlocBuilder<EarthquakeBloc, EarthquakeState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  state.isAutoRefreshing ? Icons.sync : Icons.sync_disabled,
                ),
                tooltip: state.isAutoRefreshing
                    ? 'Auto-refresh enabled'
                    : 'Auto-refresh disabled',
                onPressed: () {
                  if (state.isAutoRefreshing) {
                    context.read<EarthquakeBloc>().add(const StopAutoRefresh());
                  } else {
                    context.read<EarthquakeBloc>().add(const StartAutoRefresh());
                  }
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onPressed: () => _showFilterSheet(context),
          ),
          IconButton(
            icon: const Icon(Icons.star_outline),
            tooltip: 'Favorites',
            onPressed: () => context.push('/favorites'),
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined),
            tooltip: 'Map View',
            onPressed: () => context.push('/map'),
          ),
        ],
      ),
      body: BlocConsumer<EarthquakeBloc, EarthquakeState>(
        listener: (context, state) {
          // Show error snackbar for location errors
          if (state.locationErrorMessage != null &&
              state.locationStatus != LocationPermissionStatus.granted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.locationErrorMessage!),
                action: state.locationStatus ==
                        LocationPermissionStatus.deniedForever
                    ? SnackBarAction(
                        label: 'Settings',
                        onPressed: () => Geolocator.openAppSettings(),
                      )
                    : SnackBarAction(
                        label: 'Retry',
                        onPressed: () => context
                            .read<EarthquakeBloc>()
                            .add(const RequestLocationPermission()),
                      ),
              ),
            );
          }
        },
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<EarthquakeBloc>().add(const RefreshEarthquakes());
              await context.read<EarthquakeBloc>().stream.firstWhere(
                    (s) => s.status != EarthquakeStatus.loading,
                  );
            },
            child: _buildBody(context, state),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, EarthquakeState state) {
    // Show loading for location
    if (state.isLoadingLocation && state.earthquakes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Finding your location...'),
          ],
        ),
      );
    }

    switch (state.status) {
      case EarthquakeStatus.initial:
      case EarthquakeStatus.loading:
        if (state.earthquakes.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return _buildList(context, state, isLoading: true);

      case EarthquakeStatus.failure:
        if (state.earthquakes.isEmpty) {
          return ErrorView(
            message: state.errorMessage ?? 'Failed to load earthquakes',
            onRetry: state.isNearbyMode
                ? () => context
                    .read<EarthquakeBloc>()
                    .add(const SwitchToNearbyMode())
                : _loadGlobalEarthquakes,
          );
        }
        return _buildList(context, state);

      case EarthquakeStatus.success:
        if (state.earthquakes.isEmpty) {
          return EmptyView(
            title: state.isNearbyMode
                ? 'No Nearby Earthquakes'
                : 'No Earthquakes Found',
            subtitle: state.isNearbyMode
                ? 'No seismic activity within ${state.searchRadius.toInt()} km of your location'
                : 'Try adjusting your filters',
            icon: Icons.public_off_outlined,
          );
        }
        return _buildList(context, state);
    }
  }

  Widget _buildList(
      BuildContext context, EarthquakeState state, {bool isLoading = false}) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: _buildHeader(context, state),
        ),
        if (isLoading)
          const SliverToBoxAdapter(
            child: LinearProgressIndicator(),
          ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final earthquake = state.earthquakes[index];
              return EarthquakeCard(
                earthquake: earthquake,
                isSelected: state.selectedEarthquakeId == earthquake.id,
                onTap: () => context.push('/detail/${earthquake.id}'),
              );
            },
            childCount: state.earthquakes.length,
          ),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 16),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, EarthquakeState state) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location mode indicator
          if (state.isNearbyMode && state.hasUserLocation)
            _buildLocationBanner(context, state),

          // Global mode with location error banner
          if (!state.isNearbyMode &&
              state.locationStatus != LocationPermissionStatus.granted &&
              state.locationStatus != LocationPermissionStatus.unknown)
            _buildLocationErrorBanner(context, state),

          // Filter chips (only show in global mode)
          if (!state.isNearbyMode)
            BlocBuilder<FilterCubit, FilterOptions>(
              builder: (context, filters) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.show_chart, size: 18),
                      label: Text(filters.magnitude.label),
                      visualDensity: VisualDensity.compact,
                    ),
                    Chip(
                      avatar: const Icon(Icons.schedule, size: 18),
                      label: Text(filters.period.label),
                      visualDensity: VisualDensity.compact,
                    ),
                  ],
                );
              },
            ),

          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                '${state.metadata?.count ?? state.earthquakes.length} earthquakes',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              if (state.lastUpdated != null)
                Text(
                  'Updated ${timeago.format(state.lastUpdated!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBanner(BuildContext context, EarthquakeState state) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withAlpha((0.3 * 255).round()),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha((0.3 * 255).round()),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.my_location,
            color: theme.colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nearby Mode',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  '${state.userLatitude?.toStringAsFixed(2)}°N, ${state.userLongitude?.toStringAsFixed(2)}°E • ${state.searchRadius.toInt()} km radius',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          // Radius adjustment button
          PopupMenuButton<double>(
            icon: Icon(
              Icons.tune,
              color: theme.colorScheme.primary,
            ),
            tooltip: 'Adjust radius',
            onSelected: (radius) {
              context.read<EarthquakeBloc>().add(UpdateSearchRadius(radius));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 100, child: Text('100 km')),
              const PopupMenuItem(value: 250, child: Text('250 km')),
              const PopupMenuItem(value: 500, child: Text('500 km')),
              const PopupMenuItem(value: 1000, child: Text('1000 km')),
              const PopupMenuItem(value: 2000, child: Text('2000 km')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationErrorBanner(
      BuildContext context, EarthquakeState state) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withAlpha((0.3 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_off,
            color: theme.colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Location unavailable • Showing global earthquakes',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (state.locationStatus ==
                  LocationPermissionStatus.deniedForever) {
                Geolocator.openAppSettings();
              } else {
                context
                    .read<EarthquakeBloc>()
                    .add(const RequestLocationPermission());
              }
            },
            child: Text(
              state.locationStatus == LocationPermissionStatus.deniedForever
                  ? 'Settings'
                  : 'Enable',
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<FilterCubit>(),
        child: BlocProvider.value(
          value: context.read<EarthquakeBloc>(),
          child: const FilterSheet(),
        ),
      ),
    );
  }
}
