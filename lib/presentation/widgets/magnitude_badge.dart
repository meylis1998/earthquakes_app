import 'package:flutter/material.dart';

import '../../app/theme/design_tokens.dart';
import '../../core/utils/earthquake_utils.dart';

/// Reusable magnitude badge with Hero animation support.
/// Displays earthquake magnitude with color-coded indicator.
class MagnitudeBadge extends StatelessWidget {
  final double magnitude;
  final double size;
  final bool showLabel;
  final String? heroTag;

  const MagnitudeBadge({
    super.key,
    required this.magnitude,
    this.size = 56,
    this.showLabel = false,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final color = EarthquakeUtils.getMagnitudeColor(magnitude);
    final badge = _MagnitudeBadgeContent(
      magnitude: magnitude,
      size: size,
      showLabel: showLabel,
      color: color,
    );

    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        flightShuttleBuilder: (
          flightContext,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ) {
          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return _MagnitudeBadgeContent(
                magnitude: magnitude,
                size: size,
                showLabel: false,
                color: color,
              );
            },
          );
        },
        child: badge,
      );
    }

    return badge;
  }
}

class _MagnitudeBadgeContent extends StatelessWidget {
  final double magnitude;
  final double size;
  final bool showLabel;
  final Color color;

  const _MagnitudeBadgeContent({
    required this.magnitude,
    required this.size,
    required this.showLabel,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSize = size * 0.32;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color.withAlpha((0.12 * 255).round()),
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withAlpha((0.25 * 255).round()),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              magnitude.toStringAsFixed(1),
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.w700,
                color: color,
                height: 1,
              ),
            ),
          ),
        ),
        if (showLabel) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            EarthquakeUtils.getMagnitudeClass(magnitude),
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

/// Large magnitude badge for detail screens.
class LargeMagnitudeBadge extends StatelessWidget {
  final double magnitude;
  final String? heroTag;

  const LargeMagnitudeBadge({
    super.key,
    required this.magnitude,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = EarthquakeUtils.getMagnitudeColor(magnitude);
    final magnitudeClass = EarthquakeUtils.getMagnitudeClass(magnitude);

    final content = Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: AppRadius.borderRadiusXl,
        border: Border.all(
          color: color.withAlpha((0.3 * 255).round()),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color.withAlpha((0.15 * 255).round()),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 3),
            ),
            child: Center(
              child: Text(
                magnitude.toStringAsFixed(1),
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SizedBox(width: AppSpacing.lg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Magnitude',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                magnitudeClass,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        child: Material(
          color: Colors.transparent,
          child: content,
        ),
      );
    }

    return content;
  }
}

/// Mini magnitude indicator for compact displays.
class MiniMagnitudeBadge extends StatelessWidget {
  final double magnitude;

  const MiniMagnitudeBadge({
    super.key,
    required this.magnitude,
  });

  @override
  Widget build(BuildContext context) {
    final color = EarthquakeUtils.getMagnitudeColor(magnitude);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha((0.15 * 255).round()),
        borderRadius: AppRadius.borderRadiusSm,
        border: Border.all(color: color),
      ),
      child: Text(
        'M${magnitude.toStringAsFixed(1)}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
