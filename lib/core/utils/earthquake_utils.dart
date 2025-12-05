import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Utility class for earthquake-related calculations and formatting.
class EarthquakeUtils {
  EarthquakeUtils._();

  /// Get color for magnitude with smooth gradient interpolation.
  /// Returns colors from the design system for visual consistency.
  static Color getMagnitudeColor(double? magnitude) {
    return AppColors.getMagnitudeColor(magnitude ?? 0);
  }

  /// Get magnitude classification string.
  static String getMagnitudeClass(double? magnitude) {
    final mag = magnitude ?? 0;
    if (mag < 2.0) return 'Micro';
    if (mag < 3.0) return 'Minor';
    if (mag < 4.0) return 'Light';
    if (mag < 5.0) return 'Moderate';
    if (mag < 6.0) return 'Strong';
    if (mag < 7.0) return 'Major';
    if (mag < 8.0) return 'Great';
    return 'Massive';
  }

  /// Get icon representing magnitude severity.
  static IconData getMagnitudeIcon(double? magnitude) {
    final mag = magnitude ?? 0;
    if (mag < 3.0) return Icons.circle_outlined;
    if (mag < 5.0) return Icons.warning_amber_rounded;
    if (mag < 7.0) return Icons.warning_rounded;
    return Icons.dangerous_rounded;
  }

  /// Get color for PAGER alert level.
  static Color getAlertColor(String? alert) {
    return AppColors.getAlertColor(alert);
  }

  /// Get background color for alert badge (lighter variant).
  static Color getAlertBackgroundColor(String? alert) {
    final color = AppColors.getAlertColor(alert);
    return color.withAlpha((0.15 * 255).round());
  }

  /// Format depth value with appropriate unit.
  static String formatDepth(double depth) {
    if (depth < 0) return 'Unknown';
    if (depth < 1) return '${(depth * 1000).toStringAsFixed(0)}m';
    return '${depth.toStringAsFixed(1)} km';
  }

  /// Format coordinates with direction indicators.
  static String formatCoordinates(double lat, double lng) {
    final latDir = lat >= 0 ? 'N' : 'S';
    final lngDir = lng >= 0 ? 'E' : 'W';
    return '${lat.abs().toStringAsFixed(3)}°$latDir, ${lng.abs().toStringAsFixed(3)}°$lngDir';
  }

  /// Calculate marker size based on magnitude.
  /// Uses a more dramatic scale for better visual differentiation.
  static double getMarkerSize(double? magnitude) {
    final mag = magnitude ?? 0;
    // More dramatic scaling: base 16, multiplier 5, clamped 16-56
    return (16 + (mag * 5)).clamp(16.0, 56.0);
  }

  /// Get gradient colors for magnitude visualization (legend).
  static List<Color> getMagnitudeGradient() {
    return AppColors.magnitudeGradient;
  }

  /// Get gradient stops for magnitude visualization.
  static List<double> getMagnitudeGradientStops() {
    return const [0.0, 0.15, 0.30, 0.45, 0.60, 0.75, 1.0];
  }

  /// Format magnitude value for display.
  static String formatMagnitude(double? magnitude) {
    if (magnitude == null) return '--';
    return magnitude.toStringAsFixed(1);
  }

  /// Check if magnitude is considered significant.
  static bool isSignificant(double? magnitude) {
    return (magnitude ?? 0) >= 5.0;
  }

  /// Check if magnitude is considered major.
  static bool isMajor(double? magnitude) {
    return (magnitude ?? 0) >= 7.0;
  }

  /// Get tsunami warning color.
  static Color get tsunamiColor => AppColors.tsunami;

  /// Get tsunami warning background color.
  static Color get tsunamiBackgroundColor => AppColors.tsunamiLight;
}
