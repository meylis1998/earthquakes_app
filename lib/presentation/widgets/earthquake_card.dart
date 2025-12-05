import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../app/theme/app_colors.dart';
import '../../app/theme/design_tokens.dart';
import '../../core/utils/earthquake_utils.dart';
import '../../data/models/earthquake.dart';
import 'magnitude_badge.dart';

/// Earthquake list card with Hero animation support and refined styling.
class EarthquakeCard extends StatefulWidget {
  final EarthquakeFeature earthquake;
  final VoidCallback? onTap;
  final bool isSelected;
  final int? animationIndex;

  const EarthquakeCard({
    super.key,
    required this.earthquake,
    this.onTap,
    this.isSelected = false,
    this.animationIndex,
  });

  @override
  State<EarthquakeCard> createState() => _EarthquakeCardState();
}

class _EarthquakeCardState extends State<EarthquakeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: AppDurations.micro,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _scaleController, curve: AppCurves.standard),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    setState(() => _isPressed = true);
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    setState(() => _isPressed = false);
    _scaleController.reverse();
    widget.onTap?.call();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _scaleController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final props = widget.earthquake.properties;
    final mag = props.mag ?? 0;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          curve: AppCurves.standard,
          margin: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceContainerDark : Colors.white,
            borderRadius: AppRadius.borderRadiusMd,
            border: widget.isSelected
                ? Border.all(
                    color: theme.colorScheme.primary,
                    width: 2,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: AppColors.gray900.withAlpha(
                  _isPressed
                      ? (isDark ? 30 : 12)
                      : (isDark ? 20 : 8),
                ),
                blurRadius: _isPressed ? 4 : 8,
                offset: Offset(0, _isPressed ? 1 : 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: AppRadius.borderRadiusMd,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: null, // Handled by GestureDetector
                borderRadius: AppRadius.borderRadiusMd,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      // Magnitude badge with Hero
                      MagnitudeBadge(
                        magnitude: mag,
                        size: 56,
                        heroTag: 'magnitude_${widget.earthquake.id}',
                      ),
                      SizedBox(width: AppSpacing.lg),
                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location
                            Text(
                              props.place ?? 'Unknown Location',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            // Metadata row
                            Row(
                              children: [
                                _MetadataChip(
                                  icon: Icons.access_time_rounded,
                                  label: timeago.format(widget.earthquake.time),
                                ),
                                SizedBox(width: AppSpacing.md),
                                _MetadataChip(
                                  icon: Icons.vertical_align_bottom_rounded,
                                  label: EarthquakeUtils.formatDepth(
                                    widget.earthquake.depth,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      // Badges column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.earthquake.hasTsunamiWarning)
                            _TsunamiBadge(),
                          if (props.alert != null) ...[
                            if (widget.earthquake.hasTsunamiWarning)
                              SizedBox(height: AppSpacing.xs),
                            _AlertBadge(alert: props.alert!),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Metadata chip for time and depth.
class _MetadataChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetadataChip({
    required this.icon,
    required this.label,
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
          color: theme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Tsunami warning badge.
class _TsunamiBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: EarthquakeUtils.tsunamiBackgroundColor,
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(
          color: EarthquakeUtils.tsunamiColor.withAlpha((0.3 * 255).round()),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.waves_rounded,
            size: AppIconSize.xs,
            color: EarthquakeUtils.tsunamiColor,
          ),
          SizedBox(width: AppSpacing.xs),
          Text(
            'Tsunami',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: EarthquakeUtils.tsunamiColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// PAGER alert level badge.
class _AlertBadge extends StatelessWidget {
  final String alert;

  const _AlertBadge({required this.alert});

  @override
  Widget build(BuildContext context) {
    final color = EarthquakeUtils.getAlertColor(alert);
    final bgColor = EarthquakeUtils.getAlertBackgroundColor(alert);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(
          color: color.withAlpha((0.3 * 255).round()),
        ),
      ),
      child: Text(
        alert.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// Compact earthquake card for horizontal lists.
class CompactEarthquakeCard extends StatelessWidget {
  final EarthquakeFeature earthquake;
  final VoidCallback? onTap;

  const CompactEarthquakeCard({
    super.key,
    required this.earthquake,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final props = earthquake.properties;
    final mag = props.mag ?? 0;
    final color = EarthquakeUtils.getMagnitudeColor(mag);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceContainerDark : Colors.white,
          borderRadius: AppRadius.borderRadiusMd,
          boxShadow: [
            BoxShadow(
              color: AppColors.gray900.withAlpha(isDark ? 20 : 8),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withAlpha((0.15 * 255).round()),
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      mag.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  timeago.format(earthquake.time, allowFromNow: true),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Text(
              props.place ?? 'Unknown',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
