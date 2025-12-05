import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/design_tokens.dart';

/// Glass-morphism style stat card for displaying earthquake statistics.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;
  final bool compact;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = color ?? theme.colorScheme.primary;

    return Container(
      padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.gray800.withAlpha((0.6 * 255).round())
            : Colors.white.withAlpha((0.8 * 255).round()),
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(
          color: isDark
              ? AppColors.gray700.withAlpha((0.5 * 255).round())
              : AppColors.gray200.withAlpha((0.5 * 255).round()),
        ),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: compact ? AppIconSize.sm : AppIconSize.md,
                  color: accentColor,
                ),
                SizedBox(width: AppSpacing.sm),
              ],
              Expanded(
                child: Text(
                  label,
                  style: (compact
                          ? theme.textTheme.labelSmall
                          : theme.textTheme.labelMedium)
                      ?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
          Text(
            value,
            style: (compact
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.titleLarge)
                ?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Glass-morphism stat card with blur effect.
class GlassStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  const GlassStatCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = color ?? theme.colorScheme.primary;

    return ClipRRect(
      borderRadius: AppRadius.borderRadiusMd,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withAlpha((0.08 * 255).round())
                : Colors.white.withAlpha((0.7 * 255).round()),
            borderRadius: AppRadius.borderRadiusMd,
            border: Border.all(
              color: isDark
                  ? Colors.white.withAlpha((0.1 * 255).round())
                  : Colors.white.withAlpha((0.8 * 255).round()),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: AppIconSize.md,
                      color: accentColor,
                    ),
                    SizedBox(width: AppSpacing.sm),
                  ],
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal stat row for inline display.
class StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;

  const StatRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: AppIconSize.sm,
            color: iconColor ?? theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: AppSpacing.sm),
        ],
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Stats grid for detail screens.
class StatsGrid extends StatelessWidget {
  final List<StatCardData> stats;
  final int crossAxisCount;
  final double spacing;

  const StatsGrid({
    super.key,
    required this.stats,
    this.crossAxisCount = 2,
    this.spacing = AppSpacing.md,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: stats.map((stat) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width -
                  (AppSpacing.lg * 2) -
                  (spacing * (crossAxisCount - 1))) /
              crossAxisCount,
          child: StatCard(
            label: stat.label,
            value: stat.value,
            icon: stat.icon,
            color: stat.color,
            compact: true,
          ),
        );
      }).toList(),
    );
  }
}

/// Data class for stat card.
class StatCardData {
  final String label;
  final String value;
  final IconData? icon;
  final Color? color;

  const StatCardData({
    required this.label,
    required this.value,
    this.icon,
    this.color,
  });
}
