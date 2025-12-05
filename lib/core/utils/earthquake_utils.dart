import 'package:flutter/material.dart';

class EarthquakeUtils {
  EarthquakeUtils._();

  static Color getMagnitudeColor(double? magnitude) {
    final mag = magnitude ?? 0;
    if (mag < 2.0) return Colors.grey;
    if (mag < 3.0) return Colors.green;
    if (mag < 4.0) return Colors.lightGreen;
    if (mag < 5.0) return Colors.yellow.shade700;
    if (mag < 6.0) return Colors.orange;
    if (mag < 7.0) return Colors.deepOrange;
    if (mag < 8.0) return Colors.red;
    return Colors.red.shade900;
  }

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

  static IconData getMagnitudeIcon(double? magnitude) {
    final mag = magnitude ?? 0;
    if (mag < 3.0) return Icons.circle_outlined;
    if (mag < 5.0) return Icons.warning_amber_outlined;
    if (mag < 7.0) return Icons.warning_outlined;
    return Icons.dangerous_outlined;
  }

  static Color getAlertColor(String? alert) {
    switch (alert?.toLowerCase()) {
      case 'green':
        return Colors.green;
      case 'yellow':
        return Colors.yellow.shade700;
      case 'orange':
        return Colors.orange;
      case 'red':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  static String formatDepth(double depth) {
    if (depth < 0) return 'Unknown';
    if (depth < 1) return '${(depth * 1000).toStringAsFixed(0)}m';
    return '${depth.toStringAsFixed(1)} km';
  }

  static String formatCoordinates(double lat, double lng) {
    final latDir = lat >= 0 ? 'N' : 'S';
    final lngDir = lng >= 0 ? 'E' : 'W';
    return '${lat.abs().toStringAsFixed(3)}°$latDir, ${lng.abs().toStringAsFixed(3)}°$lngDir';
  }

  static double getMarkerSize(double? magnitude) {
    final mag = magnitude ?? 0;
    return (mag * 4).clamp(12.0, 48.0);
  }
}
