import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/design_tokens.dart';
import '../../core/config/map_config.dart';
import '../../core/utils/earthquake_utils.dart';
import '../../data/models/earthquake.dart';
import '../animations/animation_utils.dart';
import '../bloc/bloc_exports.dart';
import '../widgets/error_view.dart';
import '../widgets/magnitude_badge.dart';
import '../widgets/stat_card.dart';
import '../widgets/skeleton_loading.dart';

class EarthquakeDetailScreen extends StatefulWidget {
  final String earthquakeId;

  const EarthquakeDetailScreen({
    super.key,
    required this.earthquakeId,
  });

  @override
  State<EarthquakeDetailScreen> createState() => _EarthquakeDetailScreenState();
}

class _EarthquakeDetailScreenState extends State<EarthquakeDetailScreen> {
  @override
  void initState() {
    super.initState();
    _loadEarthquake();
  }

  void _loadEarthquake() {
    final bloc = context.read<EarthquakeBloc>();
    final existing = bloc.state.earthquakes.where((e) => e.id == widget.earthquakeId);

    if (existing.isNotEmpty) {
      bloc.add(SelectEarthquake(widget.earthquakeId));
    } else {
      bloc.add(LoadEarthquakeById(widget.earthquakeId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EarthquakeBloc, EarthquakeState>(
        builder: (context, state) {
          final earthquake = state.selectedEarthquake ??
              state.earthquakes.where((e) => e.id == widget.earthquakeId).firstOrNull;

          if (earthquake == null) {
            if (state.status == EarthquakeStatus.loading) {
              return const _DetailSkeleton();
            }
            return Scaffold(
              appBar: AppBar(),
              body: ErrorView(
                message: 'Earthquake not found',
                onRetry: _loadEarthquake,
              ),
            );
          }

          return _DetailContent(earthquake: earthquake);
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  final EarthquakeFeature earthquake;

  const _DetailContent({required this.earthquake});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final props = earthquake.properties;
    final mag = props.mag ?? 0;

    return CustomScrollView(
      slivers: [
        // Map with floating back button
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          stretch: true,
          backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
          leading: Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: _FloatingBackButton(),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: AppSpacing.sm),
              child: _FloatingActionButton(
                icon: Icons.share_rounded,
                onPressed: () => _shareEarthquake(context),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _buildMap(context),
          ),
        ),

        // Content with overlapping magnitude badge
        SliverToBoxAdapter(
          child: Transform.translate(
            offset: const Offset(0, -40),
            child: Column(
              children: [
                // Floating magnitude badge with Hero
                Hero(
                  tag: 'magnitude_${earthquake.id}',
                  child: LargeMagnitudeBadge(
                    magnitude: mag,
                  ),
                ),
                SizedBox(height: AppSpacing.lg),

                // Content sections
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: AppRadius.borderRadiusTopXl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSpacing.xl),
                      _buildHeader(context),
                      SizedBox(height: AppSpacing.xxl),
                      _buildLocationTimeSection(context),
                      SizedBox(height: AppSpacing.xxl),
                      _buildStatsSection(context),
                      SizedBox(height: AppSpacing.xxl),
                      _buildActionsSection(context),
                      SizedBox(height: AppSpacing.xxl + MediaQuery.of(context).padding.bottom),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final magColor = EarthquakeUtils.getMagnitudeColor(earthquake.properties.mag);
    // Use CARTO maps
    final mapStyle = isDark
        ? MapConfig.styles[MapStyle.cartoDarkMatter]!
        : MapConfig.styles[MapStyle.cartoPositron]!;

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(earthquake.latitude, earthquake.longitude),
            initialZoom: 7,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.none,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: mapStyle.getUrl(retina: mapStyle.supportsRetina),
              subdomains: mapStyle.subdomains,
              userAgentPackageName: 'com.example.earthquakes',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(earthquake.latitude, earthquake.longitude),
                  width: 56,
                  height: 56,
                  child: Container(
                    decoration: BoxDecoration(
                      color: magColor.withAlpha((0.3 * 255).round()),
                      shape: BoxShape.circle,
                      border: Border.all(color: magColor, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: magColor.withAlpha((0.4 * 255).round()),
                          blurRadius: 12,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: magColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        // Gradient overlay at bottom
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 80,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  theme.colorScheme.surface.withAlpha((0.8 * 255).round()),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final props = earthquake.properties;
    final magColor = EarthquakeUtils.getMagnitudeColor(props.mag);

    return SlideUpFadeIn(
      delay: const Duration(milliseconds: 100),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Location
            Text(
              props.place ?? 'Unknown Location',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.sm),
            // Magnitude class
            Text(
              earthquake.magnitudeClass,
              style: theme.textTheme.titleMedium?.copyWith(
                color: magColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            // Badges row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (earthquake.hasTsunamiWarning) ...[
                  _InfoBadge(
                    icon: Icons.waves_rounded,
                    label: 'Tsunami Warning',
                    color: EarthquakeUtils.tsunamiColor,
                  ),
                  SizedBox(width: AppSpacing.sm),
                ],
                if (props.alert != null)
                  _InfoBadge(
                    icon: Icons.warning_amber_rounded,
                    label: '${props.alert!.toUpperCase()} Alert',
                    color: EarthquakeUtils.getAlertColor(props.alert),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTimeSection(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateFormat = DateFormat('EEEE, MMMM d, yyyy');
    final timeFormat = DateFormat('HH:mm:ss');

    return SlideUpFadeIn(
      delay: const Duration(milliseconds: 200),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Location & Time',
              icon: Icons.schedule_rounded,
            ),
            SizedBox(height: AppSpacing.lg),
            // Glass card for location info
            Container(
              padding: EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.gray800.withAlpha((0.5 * 255).round())
                    : AppColors.gray50,
                borderRadius: AppRadius.borderRadiusMd,
                border: Border.all(
                  color: isDark
                      ? AppColors.gray700.withAlpha((0.3 * 255).round())
                      : AppColors.gray200.withAlpha((0.5 * 255).round()),
                ),
              ),
              child: Column(
                children: [
                  _DetailRow(
                    icon: Icons.calendar_today_rounded,
                    label: 'Date',
                    value: dateFormat.format(earthquake.time.toLocal()),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _DetailRow(
                    icon: Icons.access_time_rounded,
                    label: 'Local Time',
                    value: timeFormat.format(earthquake.time.toLocal()),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _DetailRow(
                    icon: Icons.my_location_rounded,
                    label: 'Coordinates',
                    value: EarthquakeUtils.formatCoordinates(
                      earthquake.latitude,
                      earthquake.longitude,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _DetailRow(
                    icon: Icons.vertical_align_bottom_rounded,
                    label: 'Depth',
                    value: EarthquakeUtils.formatDepth(earthquake.depth),
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    final props = earthquake.properties;

    // Build stats list dynamically
    final stats = <Map<String, dynamic>>[
      {
        'label': 'Significance',
        'value': '${props.sig ?? 0}',
        'icon': Icons.priority_high_rounded,
      },
      {
        'label': 'Felt Reports',
        'value': '${props.felt ?? 0}',
        'icon': Icons.people_rounded,
      },
    ];

    if (props.cdi != null) {
      stats.add({
        'label': 'CDI',
        'value': props.cdi!.toStringAsFixed(1),
        'icon': Icons.assessment_rounded,
      });
    }

    if (props.mmi != null) {
      stats.add({
        'label': 'MMI',
        'value': props.mmi!.toStringAsFixed(1),
        'icon': Icons.show_chart_rounded,
      });
    }

    if (props.nst != null) {
      stats.add({
        'label': 'Stations',
        'value': '${props.nst}',
        'icon': Icons.sensors_rounded,
      });
    }

    if (props.gap != null) {
      stats.add({
        'label': 'Gap',
        'value': '${props.gap!.toStringAsFixed(0)}°',
        'icon': Icons.pie_chart_rounded,
      });
    }

    return SlideUpFadeIn(
      delay: const Duration(milliseconds: 300),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Technical Details',
              icon: Icons.analytics_rounded,
            ),
            SizedBox(height: AppSpacing.lg),
            // 2x2 Stats grid
            StatsGrid(
              stats: stats.map((stat) => StatCardData(
                label: stat['label'] as String,
                value: stat['value'] as String,
                icon: stat['icon'] as IconData,
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context) {
    final props = earthquake.properties;

    return SlideUpFadeIn(
      delay: const Duration(milliseconds: 400),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Actions',
              icon: Icons.touch_app_rounded,
            ),
            SizedBox(height: AppSpacing.lg),
            // Action buttons row
            Row(
              children: [
                if (props.url != null)
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.open_in_new_rounded,
                      label: 'USGS Page',
                      onPressed: () => _openUsgsPage(props.url!),
                      isPrimary: true,
                    ),
                  ),
                if (props.url != null) SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.map_rounded,
                    label: 'Full Map',
                    onPressed: () => _openFullMap(context),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _shareEarthquake(BuildContext context) {
    // Would implement share functionality here using Share plugin
  }

  void _openFullMap(BuildContext context) {
    // Navigate to full map with this earthquake selected
  }

  Future<void> _openUsgsPage(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Floating back button with blur effect.
class _FloatingBackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.gray900.withAlpha((0.6 * 255).round())
                : Colors.white.withAlpha((0.8 * 255).round()),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              size: AppIconSize.md,
            ),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

/// Floating action button with blur effect.
class _FloatingActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _FloatingActionButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.gray900.withAlpha((0.6 * 255).round())
                : Colors.white.withAlpha((0.8 * 255).round()),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, size: AppIconSize.md),
            onPressed: onPressed,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

/// Section header with icon.
class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          icon,
          size: AppIconSize.sm,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/// Detail row for location/time info.
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha((0.1 * 255).round()),
            borderRadius: AppRadius.borderRadiusSm,
          ),
          child: Icon(
            icon,
            size: AppIconSize.sm,
            color: theme.colorScheme.primary,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
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
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Info badge for alerts and warnings.
class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
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
          Icon(icon, size: AppIconSize.xs, color: color),
          SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Action button with optional primary styling.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isPrimary) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: AppIconSize.sm),
        label: Text(label),
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      );
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: AppIconSize.sm),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
      ),
    );
  }
}

/// Skeleton loading for detail screen.
class _DetailSkeleton extends StatelessWidget {
  const _DetailSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: ShimmerEffect(
                child: Container(
                  color: isDark ? AppColors.gray800 : AppColors.gray200,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -40),
              child: Column(
                children: [
                  // Badge skeleton
                  ShimmerEffect(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.gray800 : AppColors.gray200,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),
                  Container(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: AppRadius.borderRadiusTopXl,
                    ),
                    child: Column(
                      children: [
                        // Title skeleton
                        ShimmerEffect(
                          child: Container(
                            width: 200,
                            height: 24,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.gray800 : AppColors.gray200,
                              borderRadius: AppRadius.borderRadiusSm,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.xxl),
                        // Info card skeleton
                        ShimmerEffect(
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.gray800 : AppColors.gray200,
                              borderRadius: AppRadius.borderRadiusMd,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.xxl),
                        // Stats grid skeleton
                        Row(
                          children: [
                            Expanded(
                              child: ShimmerEffect(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.gray800 : AppColors.gray200,
                                    borderRadius: AppRadius.borderRadiusMd,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: ShimmerEffect(
                                child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.gray800 : AppColors.gray200,
                                    borderRadius: AppRadius.borderRadiusMd,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
