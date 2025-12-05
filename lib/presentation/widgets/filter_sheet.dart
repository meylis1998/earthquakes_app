import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/design_tokens.dart';
import '../../data/models/filter_options.dart';
import '../bloc/bloc_exports.dart';
import 'gradient_legend.dart';

/// Filter bottom sheet with backdrop blur and refined styling.
class FilterSheet extends StatelessWidget {
  const FilterSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<FilterCubit, FilterOptions>(
      builder: (context, filters) {
        return ClipRRect(
          borderRadius: AppRadius.borderRadiusTopXl,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceContainerDark.withAlpha((0.9 * 255).round())
                    : Colors.white.withAlpha((0.95 * 255).round()),
                borderRadius: AppRadius.borderRadiusTopXl,
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? AppColors.gray700.withAlpha((0.3 * 255).round())
                        : AppColors.gray200.withAlpha((0.5 * 255).round()),
                  ),
                ),
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
                        Icons.tune_rounded,
                        size: AppIconSize.lg,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Text(
                        'Filters',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          context.read<FilterCubit>().resetFilters();
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // Magnitude section
                  _SectionHeader(
                    title: 'Magnitude',
                    icon: Icons.speed_rounded,
                  ),
                  SizedBox(height: AppSpacing.md),

                  // Magnitude gradient preview
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.gray800.withAlpha((0.5 * 255).round())
                          : AppColors.gray50,
                      borderRadius: AppRadius.borderRadiusMd,
                    ),
                    child: Column(
                      children: [
                        const GradientLegend(
                          width: double.infinity,
                          height: 8,
                        ),
                        SizedBox(height: AppSpacing.md),
                        _SegmentedSelector<MagnitudeFilter>(
                          values: MagnitudeFilter.values,
                          selected: filters.magnitude,
                          labelBuilder: (v) => v.label,
                          onSelected: (v) {
                            context.read<FilterCubit>().setMagnitude(v);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.xl),

                  // Time period section
                  _SectionHeader(
                    title: 'Time Period',
                    icon: Icons.schedule_rounded,
                  ),
                  SizedBox(height: AppSpacing.md),
                  _SegmentedSelector<TimePeriod>(
                    values: TimePeriod.values,
                    selected: filters.period,
                    labelBuilder: (v) => v.label,
                    onSelected: (v) {
                      context.read<FilterCubit>().setPeriod(v);
                    },
                  ),
                  SizedBox(height: AppSpacing.xxl),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        final cubit = context.read<FilterCubit>();
                        context.read<EarthquakeBloc>().add(LoadEarthquakes(
                          magnitude: cubit.state.magnitude,
                          period: cubit.state.period,
                        ));
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
        );
      },
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
          color: theme.colorScheme.onSurfaceVariant,
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Segmented selector for filter options.
class _SegmentedSelector<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final String Function(T) labelBuilder;
  final ValueChanged<T> onSelected;

  const _SegmentedSelector({
    required this.values,
    required this.selected,
    required this.labelBuilder,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.gray800.withAlpha((0.5 * 255).round())
            : AppColors.gray100,
        borderRadius: AppRadius.borderRadiusMd,
      ),
      padding: EdgeInsets.all(AppSpacing.xs),
      child: Row(
        children: values.map((value) {
          final isSelected = value == selected;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(value),
              child: AnimatedContainer(
                duration: AppDurations.fast,
                curve: AppCurves.standard,
                padding: EdgeInsets.symmetric(
                  vertical: AppSpacing.sm,
                  horizontal: AppSpacing.xs,
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
                child: Text(
                  labelBuilder(value),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: isSelected
                        ? (isDark
                            ? AppColors.primary200
                            : theme.colorScheme.primary)
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
