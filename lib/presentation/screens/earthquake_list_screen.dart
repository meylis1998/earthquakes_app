import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../app/theme/app_colors.dart';
import '../../app/theme/design_tokens.dart';
import '../../data/models/filter_options.dart';
import '../../data/services/location_service.dart';
import '../bloc/bloc_exports.dart';
import '../widgets/earthquake_card.dart';
import '../widgets/error_view.dart';
import '../widgets/filter_sheet.dart';
import '../widgets/skeleton_loading.dart';

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
      body: BlocConsumer<EarthquakeBloc, EarthquakeState>(
        listener: (context, state) {
          if (state.locationErrorMessage != null &&
              state.locationStatus != LocationPermissionStatus.granted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.locationErrorMessage!),
                behavior: SnackBarBehavior.floating,
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
            child: CustomScrollView(
              slivers: [
                // App Bar with collapsible title
                _buildAppBar(context, state),
                // Header with mode toggle and filters
                SliverToBoxAdapter(
                  child: _buildHeader(context, state),
                ),
                // Content
                ..._buildContent(context, state),
                // Bottom padding for navigation bar
                SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.xl),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, EarthquakeState state) {
    final theme = Theme.of(context);

    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      stretch: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(
          left: AppSpacing.lg,
          bottom: AppSpacing.lg,
        ),
        title: Text(
          'Earthquakes',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        expandedTitleScale: 1.2,
      ),
      actions: [
        // Auto-refresh toggle
        IconButton(
          icon: Icon(
            state.isAutoRefreshing
                ? Icons.sync_rounded
                : Icons.sync_disabled_rounded,
            color: state.isAutoRefreshing
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
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
        ),
        // Filter button
        IconButton(
          icon: const Icon(Icons.tune_rounded),
          tooltip: 'Filter',
          onPressed: () => _showFilterSheet(context),
        ),
        SizedBox(width: AppSpacing.sm),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, EarthquakeState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mode toggle segment
          _buildModeToggle(context, state),
          SizedBox(height: AppSpacing.lg),

          // Location banner (nearby mode)
          if (state.isNearbyMode && state.hasUserLocation)
            _buildLocationBanner(context, state),

          // Location error banner
          if (!state.isNearbyMode &&
              state.locationStatus != LocationPermissionStatus.granted &&
              state.locationStatus != LocationPermissionStatus.unknown)
            _buildLocationErrorBanner(context, state),

          // Filter chips (global mode)
          if (!state.isNearbyMode) ...[
            _buildFilterChips(context),
            SizedBox(height: AppSpacing.md),
          ],

          // Stats row
          _buildStatsRow(context, state),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildModeToggle(BuildContext context, EarthquakeState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray100,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      child: Row(
        children: [
          Expanded(
            child: _ModeButton(
              icon: Icons.public_rounded,
              label: 'Global',
              isSelected: !state.isNearbyMode,
              onTap: () {
                if (state.isNearbyMode) {
                  context.read<EarthquakeBloc>().add(const SwitchToGlobalMode());
                }
              },
            ),
          ),
          Expanded(
            child: _ModeButton(
              icon: Icons.my_location_rounded,
              label: 'Nearby',
              isSelected: state.isNearbyMode,
              onTap: () {
                if (!state.isNearbyMode) {
                  context.read<EarthquakeBloc>().add(const SwitchToNearbyMode());
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationBanner(BuildContext context, EarthquakeState state) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primary900.withAlpha((0.3 * 255).round())
            : AppColors.primary50,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: theme.colorScheme.primary.withAlpha((0.2 * 255).round()),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.my_location_rounded,
              color: theme.colorScheme.primary,
              size: AppIconSize.md,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Searching nearby',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${state.searchRadius.toInt()} km radius',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<double>(
            icon: Icon(
              Icons.expand_more_rounded,
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
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.warning.withAlpha((0.15 * 255).round())
            : AppColors.warningLight,
        borderRadius: AppRadius.borderRadiusSm,
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_off_rounded,
            color: AppColors.warning,
            size: AppIconSize.sm,
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              'Location unavailable',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.warning : AppColors.gray700,
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
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
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

  Widget _buildFilterChips(BuildContext context) {
    return BlocBuilder<FilterCubit, FilterOptions>(
      builder: (context, filters) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                icon: Icons.speed_rounded,
                label: filters.magnitude.label,
                onTap: () => _showFilterSheet(context),
              ),
              SizedBox(width: AppSpacing.sm),
              _FilterChip(
                icon: Icons.schedule_rounded,
                label: filters.period.label,
                onTap: () => _showFilterSheet(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsRow(BuildContext context, EarthquakeState state) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Text(
          '${state.metadata?.count ?? state.earthquakes.length} earthquakes',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        if (state.lastUpdated != null)
          Text(
            timeago.format(state.lastUpdated!),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }

  List<Widget> _buildContent(BuildContext context, EarthquakeState state) {
    // Loading state with skeleton
    if (state.isLoadingLocation && state.earthquakes.isEmpty) {
      return [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: AppSpacing.xxl),
            child: const LoadingView(message: 'Finding your location...'),
          ),
        ),
      ];
    }

    switch (state.status) {
      case EarthquakeStatus.initial:
      case EarthquakeStatus.loading:
        if (state.earthquakes.isEmpty) {
          return [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 400,
                child: const SkeletonList(itemCount: 5),
              ),
            ),
          ];
        }
        return _buildEarthquakeList(context, state, isLoading: true);

      case EarthquakeStatus.failure:
        if (state.earthquakes.isEmpty) {
          return [
            SliverFillRemaining(
              child: ErrorView(
                message: state.errorMessage ?? 'Failed to load earthquakes',
                onRetry: state.isNearbyMode
                    ? () => context
                        .read<EarthquakeBloc>()
                        .add(const SwitchToNearbyMode())
                    : _loadGlobalEarthquakes,
              ),
            ),
          ];
        }
        return _buildEarthquakeList(context, state);

      case EarthquakeStatus.success:
        if (state.earthquakes.isEmpty) {
          return [
            SliverFillRemaining(
              child: EmptyView.noEarthquakes(
                subtitle: state.isNearbyMode
                    ? 'No seismic activity within ${state.searchRadius.toInt()} km'
                    : null,
              ),
            ),
          ];
        }
        return _buildEarthquakeList(context, state);
    }
  }

  List<Widget> _buildEarthquakeList(
    BuildContext context,
    EarthquakeState state, {
    bool isLoading = false,
  }) {
    return [
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
              animationIndex: index,
            );
          },
          childCount: state.earthquakes.length,
        ),
      ),
    ];
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

/// Mode toggle button widget.
class _ModeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: AppCurves.standard,
        padding: EdgeInsets.symmetric(
          vertical: AppSpacing.sm,
          horizontal: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primary800 : Colors.white)
              : Colors.transparent,
          borderRadius: AppRadius.borderRadiusSm,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.gray900.withAlpha(isDark ? 30 : 10),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppIconSize.sm,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Filter chip widget.
class _FilterChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _FilterChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isDark ? AppColors.gray800 : AppColors.gray100,
          borderRadius: AppRadius.borderRadiusSm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppIconSize.sm,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
