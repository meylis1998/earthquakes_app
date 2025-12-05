import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../app/theme/app_colors.dart';
import '../../app/theme/design_tokens.dart';
import '../../core/config/map_config.dart';
import '../../core/utils/earthquake_utils.dart';
import '../../data/models/earthquake.dart';
import '../animations/animation_utils.dart';
import '../bloc/bloc_exports.dart';
import '../widgets/animated_marker.dart';
import '../widgets/error_view.dart';
import '../widgets/gradient_legend.dart';
import '../widgets/magnitude_badge.dart';

class EarthquakeMapScreen extends StatefulWidget {
  const EarthquakeMapScreen({super.key});

  @override
  State<EarthquakeMapScreen> createState() => _EarthquakeMapScreenState();
}

class _EarthquakeMapScreenState extends State<EarthquakeMapScreen>
    with SingleTickerProviderStateMixin {
  final MapController _mapController = MapController();
  EarthquakeFeature? _selectedEarthquake;
  bool _showLegend = true;
  // Default to CARTO Positron
  MapStyleConfig _currentStyle = MapConfig.styles[MapStyle.cartoPositron]!;

  late final AnimationController _cardAnimationController;
  late final Animation<double> _cardSlideAnimation;

  @override
  void initState() {
    super.initState();
    _cardAnimationController = AnimationController(
      vsync: this,
      duration: AppDurations.normal,
    );
    _cardSlideAnimation = CurvedAnimation(
      parent: _cardAnimationController,
      curve: AppCurves.enter,
    );
  }

  @override
  void dispose() {
    _cardAnimationController.dispose();
    super.dispose();
  }

  void _selectEarthquake(EarthquakeFeature? eq) {
    setState(() {
      _selectedEarthquake = eq;
    });

    if (eq != null) {
      _cardAnimationController.forward(from: 0);
      _animateToLocation(eq.latitude, eq.longitude);
    } else {
      _cardAnimationController.reverse();
    }
  }

  void _animateToLocation(double lat, double lng) {
    final currentZoom = _mapController.camera.zoom;
    final targetZoom = currentZoom < 5 ? 6.0 : currentZoom;

    _mapController.move(
      LatLng(lat, lng),
      targetZoom,
    );
  }

  void _showStylePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MapStylePicker(
        currentStyle: _currentStyle,
        onStyleSelected: (style) {
          setState(() {
            _currentStyle = style;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EarthquakeBloc, EarthquakeState>(
        builder: (context, state) {
          if (state.earthquakes.isEmpty && state.status != EarthquakeStatus.loading) {
            return EmptyView.noEarthquakes();
          }

          return Stack(
            children: [
              // Full bleed map
              Positioned.fill(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _getInitialCenter(state.earthquakes),
                    initialZoom: 2,
                    minZoom: 1,
                    maxZoom: _currentStyle.maxZoom.toDouble(),
                    onTap: (_, _) => _selectEarthquake(null),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: _currentStyle.getUrl(retina: true),
                      subdomains: _currentStyle.subdomains,
                      userAgentPackageName: 'com.example.earthquakes',
                      maxZoom: _currentStyle.maxZoom.toDouble(),
                      retinaMode: _currentStyle.supportsRetina,
                    ),
                    MarkerLayer(
                      markers: _buildMarkers(state.earthquakes),
                    ),
                  ],
                ),
              ),

              // Top controls row
              Positioned(
                top: MediaQuery.of(context).padding.top + AppSpacing.md,
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                child: Row(
                  children: [
                    // Gradient legend toggle
                    _FloatingControl(
                      icon: _showLegend
                          ? Icons.legend_toggle_rounded
                          : Icons.legend_toggle_outlined,
                      onPressed: () {
                        setState(() {
                          _showLegend = !_showLegend;
                        });
                      },
                    ),
                    SizedBox(width: AppSpacing.sm),
                    // Map style picker
                    _FloatingControl(
                      icon: Icons.layers_rounded,
                      onPressed: _showStylePicker,
                    ),
                    const Spacer(),
                    // Fit all button
                    _FloatingControl(
                      icon: Icons.fit_screen_rounded,
                      onPressed: _fitAllMarkers,
                    ),
                  ],
                ),
              ),

              // Gradient legend
              if (_showLegend)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 64,
                  left: AppSpacing.lg,
                  child: SlideUpFadeIn(
                    child: FloatingLegend(),
                  ),
                ),

              // Earthquake count badge
              Positioned(
                top: MediaQuery.of(context).padding.top + 64,
                right: AppSpacing.lg,
                child: _EarthquakeCountBadge(
                  count: state.earthquakes.length,
                ),
              ),

              // Current style indicator
              Positioned(
                bottom: _selectedEarthquake != null
                    ? 200 + MediaQuery.of(context).padding.bottom
                    : MediaQuery.of(context).padding.bottom + AppSpacing.lg,
                left: AppSpacing.lg,
                child: _MapStyleBadge(style: _currentStyle),
              ),

              // Selected earthquake info card
              if (_selectedEarthquake != null)
                Positioned(
                  left: AppSpacing.lg,
                  right: AppSpacing.lg,
                  bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 1),
                      end: Offset.zero,
                    ).animate(_cardSlideAnimation),
                    child: FadeTransition(
                      opacity: _cardSlideAnimation,
                      child: _GlassInfoCard(
                        earthquake: _selectedEarthquake!,
                        onClose: () => _selectEarthquake(null),
                        onTap: () {
                          context.push('/detail/${_selectedEarthquake!.id}');
                        },
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  LatLng _getInitialCenter(List<EarthquakeFeature> earthquakes) {
    if (earthquakes.isEmpty) {
      return const LatLng(20, 0);
    }

    double sumLat = 0;
    double sumLng = 0;

    for (final eq in earthquakes) {
      sumLat += eq.latitude;
      sumLng += eq.longitude;
    }

    return LatLng(sumLat / earthquakes.length, sumLng / earthquakes.length);
  }

  List<Marker> _buildMarkers(List<EarthquakeFeature> earthquakes) {
    return earthquakes.map((eq) {
      final mag = eq.properties.mag ?? 0;
      final size = EarthquakeUtils.getMarkerSize(mag);
      final isSelected = _selectedEarthquake?.id == eq.id;

      return Marker(
        point: LatLng(eq.latitude, eq.longitude),
        width: isSelected ? size + 16 : size + 8,
        height: isSelected ? size + 16 : size + 8,
        child: AnimatedMarker(
          magnitude: mag,
          isSelected: isSelected,
          enablePulse: mag >= 5.0,
          onTap: () => _selectEarthquake(eq),
        ),
      );
    }).toList();
  }

  void _fitAllMarkers() {
    final state = context.read<EarthquakeBloc>().state;
    if (state.earthquakes.isEmpty) return;

    final bounds = LatLngBounds.fromPoints(
      state.earthquakes.map((e) => LatLng(e.latitude, e.longitude)).toList(),
    );

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.all(AppSpacing.xxl * 2),
      ),
    );
  }
}

/// Floating control button with blur effect.
class _FloatingControl extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _FloatingControl({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusMd,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Material(
          color: isDark
              ? AppColors.gray900.withAlpha((0.7 * 255).round())
              : Colors.white.withAlpha((0.85 * 255).round()),
          borderRadius: AppRadius.borderRadiusMd,
          child: InkWell(
            onTap: onPressed,
            borderRadius: AppRadius.borderRadiusMd,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(
                  color: isDark
                      ? AppColors.gray700.withAlpha((0.3 * 255).round())
                      : AppColors.gray200.withAlpha((0.5 * 255).round()),
                ),
                borderRadius: AppRadius.borderRadiusMd,
              ),
              child: Icon(
                icon,
                size: AppIconSize.md,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Earthquake count badge.
class _EarthquakeCountBadge extends StatelessWidget {
  final int count;

  const _EarthquakeCountBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusSm,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.gray900.withAlpha((0.7 * 255).round())
                : Colors.white.withAlpha((0.85 * 255).round()),
            borderRadius: AppRadius.borderRadiusSm,
            border: Border.all(
              color: isDark
                  ? AppColors.gray700.withAlpha((0.3 * 255).round())
                  : AppColors.gray200.withAlpha((0.5 * 255).round()),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.public_rounded,
                size: AppIconSize.sm,
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                '$count',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Map style badge showing current style.
class _MapStyleBadge extends StatelessWidget {
  final MapStyleConfig style;

  const _MapStyleBadge({required this.style});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusSm,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.gray900.withAlpha((0.6 * 255).round())
                : Colors.white.withAlpha((0.8 * 255).round()),
            borderRadius: AppRadius.borderRadiusSm,
            border: Border.all(
              color: isDark
                  ? AppColors.gray700.withAlpha((0.3 * 255).round())
                  : AppColors.gray200.withAlpha((0.5 * 255).round()),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.map_rounded,
                size: 12,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: AppSpacing.xs),
              Text(
                style.name,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Map style picker bottom sheet.
class _MapStylePicker extends StatelessWidget {
  final MapStyleConfig currentStyle;
  final ValueChanged<MapStyleConfig> onStyleSelected;

  const _MapStylePicker({
    required this.currentStyle,
    required this.onStyleSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final styles = MapConfig.earthquakeStyles;

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusTopXl,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.xl + MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.surfaceContainerDark.withAlpha((0.95 * 255).round())
                : Colors.white.withAlpha((0.98 * 255).round()),
            borderRadius: AppRadius.borderRadiusTopXl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.gray600 : AppColors.gray300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // Header
              Row(
                children: [
                  Icon(
                    Icons.layers_rounded,
                    size: AppIconSize.lg,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: AppSpacing.md),
                  Text(
                    'Map Style',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                'Choose a professional map style for earthquake visualization',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.xl),

              // Style grid
              ...styles.map((style) => _StyleOption(
                    style: style,
                    isSelected: style.style == currentStyle.style,
                    onTap: () => onStyleSelected(style),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

/// Individual style option.
class _StyleOption extends StatelessWidget {
  final MapStyleConfig style;
  final bool isSelected;
  final VoidCallback onTap;

  const _StyleOption({
    required this.style,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Material(
        color: isSelected
            ? theme.colorScheme.primary.withAlpha((0.1 * 255).round())
            : (isDark ? AppColors.gray800.withAlpha((0.5 * 255).round()) : AppColors.gray50),
        borderRadius: AppRadius.borderRadiusMd,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.borderRadiusMd,
          child: Container(
            padding: EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: AppRadius.borderRadiusMd,
              border: Border.all(
                color: isSelected
                    ? theme.colorScheme.primary
                    : (isDark
                        ? AppColors.gray700.withAlpha((0.3 * 255).round())
                        : AppColors.gray200.withAlpha((0.5 * 255).round())),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Style preview
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: style.isDark ? AppColors.gray800 : AppColors.gray100,
                    borderRadius: AppRadius.borderRadiusSm,
                    border: Border.all(
                      color: isDark ? AppColors.gray600 : AppColors.gray300,
                    ),
                  ),
                  child: Icon(
                    style.isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    color: style.isDark ? AppColors.gray400 : AppColors.gray600,
                  ),
                ),
                SizedBox(width: AppSpacing.md),
                // Style info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        style.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? theme.colorScheme.primary : null,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        style.description,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Check mark
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: theme.colorScheme.primary,
                    size: AppIconSize.lg,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass morphism info card for selected earthquake.
class _GlassInfoCard extends StatelessWidget {
  final EarthquakeFeature earthquake;
  final VoidCallback onClose;
  final VoidCallback onTap;

  const _GlassInfoCard({
    required this.earthquake,
    required this.onClose,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final props = earthquake.properties;
    final mag = props.mag ?? 0;
    final magColor = EarthquakeUtils.getMagnitudeColor(mag);

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusLg,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: AppRadius.borderRadiusLg,
            child: Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceContainerDark.withAlpha((0.85 * 255).round())
                    : Colors.white.withAlpha((0.9 * 255).round()),
                borderRadius: AppRadius.borderRadiusLg,
                border: Border.all(
                  color: isDark
                      ? AppColors.gray700.withAlpha((0.3 * 255).round())
                      : AppColors.gray200.withAlpha((0.5 * 255).round()),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gray900.withAlpha(isDark ? 40 : 20),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      // Magnitude badge
                      MagnitudeBadge(
                        magnitude: mag,
                        size: 56,
                        heroTag: 'map_magnitude_${earthquake.id}',
                      ),
                      SizedBox(width: AppSpacing.lg),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              props.place ?? 'Unknown Location',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSpacing.xs),
                            Row(
                              children: [
                                Text(
                                  earthquake.magnitudeClass,
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: magColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.sm),
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.sm),
                                Text(
                                  timeago.format(earthquake.time),
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Close button
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          size: AppIconSize.md,
                        ),
                        onPressed: onClose,
                        style: IconButton.styleFrom(
                          backgroundColor: isDark
                              ? AppColors.gray800.withAlpha((0.5 * 255).round())
                              : AppColors.gray100,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.md),
                  // Stats row
                  Row(
                    children: [
                      _QuickStat(
                        icon: Icons.vertical_align_bottom_rounded,
                        label: 'Depth',
                        value: EarthquakeUtils.formatDepth(earthquake.depth),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      _QuickStat(
                        icon: Icons.my_location_rounded,
                        label: 'Location',
                        value: EarthquakeUtils.formatCoordinates(
                          earthquake.latitude,
                          earthquake.longitude,
                        ),
                      ),
                      const Spacer(),
                      // View details arrow
                      Container(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: AppRadius.borderRadiusSm,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          size: AppIconSize.sm,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  // Tsunami/Alert badges
                  if (earthquake.hasTsunamiWarning || props.alert != null) ...[
                    SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        if (earthquake.hasTsunamiWarning)
                          _WarningBadge(
                            icon: Icons.waves_rounded,
                            label: 'Tsunami',
                            color: EarthquakeUtils.tsunamiColor,
                          ),
                        if (earthquake.hasTsunamiWarning && props.alert != null)
                          SizedBox(width: AppSpacing.sm),
                        if (props.alert != null)
                          _WarningBadge(
                            icon: Icons.warning_amber_rounded,
                            label: props.alert!.toUpperCase(),
                            color: EarthquakeUtils.getAlertColor(props.alert),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Quick stat display for info card.
class _QuickStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _QuickStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: AppIconSize.xs,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: AppSpacing.xs),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              value,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Warning badge for tsunami/alert.
class _WarningBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _WarningBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha((0.12 * 255).round()),
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(
          color: color.withAlpha((0.3 * 255).round()),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
