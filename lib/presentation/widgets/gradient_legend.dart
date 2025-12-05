import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/design_tokens.dart';
import '../../core/utils/earthquake_utils.dart';

/// Gradient legend for magnitude visualization on maps.
class GradientLegend extends StatelessWidget {
  final double width;
  final double height;
  final bool showLabels;
  final bool vertical;

  const GradientLegend({
    super.key,
    this.width = 200,
    this.height = 12,
    this.showLabels = true,
    this.vertical = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final legend = Container(
      width: vertical ? height : width,
      height: vertical ? width : height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: vertical ? Alignment.bottomCenter : Alignment.centerLeft,
          end: vertical ? Alignment.topCenter : Alignment.centerRight,
          colors: EarthquakeUtils.getMagnitudeGradient(),
          stops: EarthquakeUtils.getMagnitudeGradientStops(),
        ),
        borderRadius: BorderRadius.circular(height / 2),
        border: Border.all(
          color: isDark
              ? AppColors.gray600.withAlpha((0.5 * 255).round())
              : AppColors.gray300.withAlpha((0.5 * 255).round()),
          width: 1,
        ),
      ),
    );

    if (!showLabels) return legend;

    if (vertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '8+',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          legend,
          SizedBox(height: AppSpacing.xs),
          Text(
            '2',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        legend,
        SizedBox(height: AppSpacing.xs),
        SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '2',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '5',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '8+',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Compact floating legend for map overlay.
class FloatingLegend extends StatelessWidget {
  const FloatingLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceContainerDark.withAlpha((0.95 * 255).round())
            : Colors.white.withAlpha((0.95 * 255).round()),
        borderRadius: AppRadius.borderRadiusMd,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray900.withAlpha(isDark ? 40 : 20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Magnitude',
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          const GradientLegend(
            width: 140,
            height: 10,
          ),
        ],
      ),
    );
  }
}

/// Detailed legend with category labels.
class DetailedLegend extends StatelessWidget {
  const DetailedLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.surfaceContainerDark.withAlpha((0.95 * 255).round())
            : Colors.white.withAlpha((0.95 * 255).round()),
        borderRadius: AppRadius.borderRadiusMd,
        boxShadow: [
          BoxShadow(
            color: AppColors.gray900.withAlpha(isDark ? 40 : 20),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Magnitude Scale',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          _LegendItem(
            color: AppColors.magnitudeMicro,
            label: 'Micro',
            range: '< 2.0',
          ),
          _LegendItem(
            color: AppColors.magnitudeMinor,
            label: 'Minor',
            range: '2.0 - 2.9',
          ),
          _LegendItem(
            color: AppColors.magnitudeLight,
            label: 'Light',
            range: '3.0 - 3.9',
          ),
          _LegendItem(
            color: AppColors.magnitudeModerate,
            label: 'Moderate',
            range: '4.0 - 4.9',
          ),
          _LegendItem(
            color: AppColors.magnitudeStrong,
            label: 'Strong',
            range: '5.0 - 5.9',
          ),
          _LegendItem(
            color: AppColors.magnitudeMajor,
            label: 'Major',
            range: '6.0 - 6.9',
          ),
          _LegendItem(
            color: AppColors.magnitudeGreat,
            label: 'Great',
            range: '7.0 - 7.9',
          ),
          _LegendItem(
            color: AppColors.magnitudeMassive,
            label: 'Massive',
            range: '8.0+',
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String range;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withAlpha((0.5 * 255).round()),
                width: 2,
              ),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Text(
            range,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
