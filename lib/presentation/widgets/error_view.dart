import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/design_tokens.dart';
import '../animations/animation_utils.dart';

/// Error state view with refined styling and retry action.
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SlideUpFadeIn(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon with background
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.error.withAlpha((0.1 * 255).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: AppIconSize.xxl,
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: AppSpacing.xl),
              Text(
                'Something went wrong',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              if (onRetry != null) ...[
                SizedBox(height: AppSpacing.xl),
                FilledButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try Again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state view with context-specific illustrations.
class EmptyView extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;
  final EmptyStateType type;

  const EmptyView({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
    this.type = EmptyStateType.generic,
  });

  /// Factory for no earthquakes state
  factory EmptyView.noEarthquakes({String? subtitle}) => EmptyView(
        title: 'No earthquakes found',
        subtitle: subtitle ?? 'Try adjusting your filters or check back later',
        icon: Icons.public_rounded,
        type: EmptyStateType.earthquakes,
      );

  /// Factory for no favorites state
  factory EmptyView.noFavorites({VoidCallback? onAddLocation}) => EmptyView(
        title: 'No saved locations',
        subtitle: 'Add locations to monitor earthquakes in your areas of interest',
        icon: Icons.bookmark_outline_rounded,
        type: EmptyStateType.favorites,
        action: onAddLocation != null
            ? FilledButton.icon(
                onPressed: onAddLocation,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Location'),
              )
            : null,
      );

  /// Factory for no search results
  factory EmptyView.noResults({String? query}) => EmptyView(
        title: 'No results found',
        subtitle: query != null
            ? 'No earthquakes match "$query"'
            : 'Try different search terms',
        icon: Icons.search_off_rounded,
        type: EmptyStateType.search,
      );

  /// Factory for offline state
  factory EmptyView.offline({VoidCallback? onRetry}) => EmptyView(
        title: 'You\'re offline',
        subtitle: 'Check your internet connection and try again',
        icon: Icons.wifi_off_rounded,
        type: EmptyStateType.offline,
        action: onRetry != null
            ? OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
              )
            : null,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = _getIconColor(isDark);
    final bgColor = _getBackgroundColor(isDark);

    return SlideUpFadeIn(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustrated icon
              _IllustratedIcon(
                icon: icon,
                type: type,
                iconColor: iconColor,
                backgroundColor: bgColor,
              ),
              SizedBox(height: AppSpacing.xl),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null) ...[
                SizedBox(height: AppSpacing.sm),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              if (action != null) ...[
                SizedBox(height: AppSpacing.xl),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getIconColor(bool isDark) {
    switch (type) {
      case EmptyStateType.earthquakes:
        return isDark ? AppColors.primary400 : AppColors.primary600;
      case EmptyStateType.favorites:
        return isDark ? AppColors.primary400 : AppColors.primary600;
      case EmptyStateType.search:
        return AppColors.gray500;
      case EmptyStateType.offline:
        return AppColors.warning;
      case EmptyStateType.generic:
        return AppColors.gray500;
    }
  }

  Color _getBackgroundColor(bool isDark) {
    switch (type) {
      case EmptyStateType.earthquakes:
        return isDark ? AppColors.primary900 : AppColors.primary50;
      case EmptyStateType.favorites:
        return isDark ? AppColors.primary900 : AppColors.primary50;
      case EmptyStateType.search:
        return isDark ? AppColors.gray800 : AppColors.gray100;
      case EmptyStateType.offline:
        return isDark ? AppColors.warningLight.withAlpha((0.2 * 255).round()) : AppColors.warningLight;
      case EmptyStateType.generic:
        return isDark ? AppColors.gray800 : AppColors.gray100;
    }
  }
}

/// Illustrated icon with decorative elements.
class _IllustratedIcon extends StatelessWidget {
  final IconData icon;
  final EmptyStateType type;
  final Color iconColor;
  final Color backgroundColor;

  const _IllustratedIcon({
    required this.icon,
    required this.type,
    required this.iconColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
          ),
          // Decorative elements based on type
          if (type == EmptyStateType.earthquakes) ...[
            Positioned(
              top: 10,
              right: 15,
              child: _DecorativeCircle(
                size: 12,
                color: AppColors.magnitudeMinor.withAlpha((0.6 * 255).round()),
              ),
            ),
            Positioned(
              bottom: 15,
              left: 10,
              child: _DecorativeCircle(
                size: 8,
                color: AppColors.magnitudeModerate.withAlpha((0.6 * 255).round()),
              ),
            ),
            Positioned(
              top: 25,
              left: 20,
              child: _DecorativeCircle(
                size: 6,
                color: AppColors.magnitudeLight.withAlpha((0.6 * 255).round()),
              ),
            ),
          ],
          if (type == EmptyStateType.favorites) ...[
            Positioned(
              top: 15,
              right: 20,
              child: Icon(
                Icons.star_rounded,
                size: 16,
                color: iconColor.withAlpha((0.4 * 255).round()),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 15,
              child: Icon(
                Icons.star_rounded,
                size: 12,
                color: iconColor.withAlpha((0.3 * 255).round()),
              ),
            ),
          ],
          // Main icon
          Icon(
            icon,
            size: AppIconSize.xxl,
            color: iconColor,
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _DecorativeCircle({
    required this.size,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

/// Type of empty state for styling.
enum EmptyStateType {
  generic,
  earthquakes,
  favorites,
  search,
  offline,
}

/// Loading view with optional message.
class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: AppSpacing.lg),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
