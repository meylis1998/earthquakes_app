import 'package:flutter/material.dart';

/// App color palette following 60-30-10 rule:
/// - 60% Primary blues (monochromatic)
/// - 30% Neutral grays (blue-tinted)
/// - 10% Accent/semantic colors (magnitude, alerts)
abstract class AppColors {
  // ============================================================
  // PRIMARY BLUES (60% of UI) - Monochromatic elegance
  // ============================================================

  /// Darkest blue - for emphasis and contrast
  static const Color primary900 = Color(0xFF0D47A1);

  /// Brand color - main primary
  static const Color primary800 = Color(0xFF1565C0);

  static const Color primary700 = Color(0xFF1976D2);

  static const Color primary600 = Color(0xFF1E88E5);

  /// Medium blue - interactive elements
  static const Color primary500 = Color(0xFF2196F3);

  static const Color primary400 = Color(0xFF42A5F5);

  static const Color primary300 = Color(0xFF64B5F6);

  static const Color primary200 = Color(0xFF90CAF9);

  static const Color primary100 = Color(0xFFBBDEFB);

  /// Lightest blue - subtle backgrounds
  static const Color primary50 = Color(0xFFE3F2FD);

  // ============================================================
  // NEUTRAL GRAYS (30% of UI) - Blue-tinted for cohesion
  // ============================================================

  /// Darkest gray - text on light surfaces
  static const Color gray900 = Color(0xFF1A1D21);

  static const Color gray800 = Color(0xFF2D3139);

  static const Color gray700 = Color(0xFF404550);

  static const Color gray600 = Color(0xFF5A6070);

  /// Medium gray - secondary text
  static const Color gray500 = Color(0xFF747B8A);

  static const Color gray400 = Color(0xFF9199A8);

  static const Color gray300 = Color(0xFFB5BBC7);

  static const Color gray200 = Color(0xFFD4D8E0);

  static const Color gray100 = Color(0xFFE8EBF0);

  /// Lightest gray - subtle borders
  static const Color gray50 = Color(0xFFF5F7FA);

  // ============================================================
  // SURFACE COLORS - Soft, not pure white/black
  // ============================================================

  /// Light mode background (soft off-white)
  static const Color surfaceLight = Color(0xFFFAFBFC);

  /// Light mode card/container surface
  static const Color surfaceContainerLight = Color(0xFFF0F3F6);

  /// Light mode variant surface
  static const Color surfaceVariantLight = Color(0xFFE8ECF0);

  /// Dark mode background (deep blue-gray)
  static const Color surfaceDark = Color(0xFF0F1318);

  /// Dark mode card/container surface
  static const Color surfaceContainerDark = Color(0xFF1A1F26);

  /// Dark mode variant surface
  static const Color surfaceVariantDark = Color(0xFF252B35);

  // ============================================================
  // MAGNITUDE GRADIENT COLORS (Semantic - 10% accent)
  // Smooth gradient from safe (green) to dangerous (red)
  // ============================================================

  /// Magnitude < 2.0 - Micro (barely felt)
  static const Color magnitudeMicro = Color(0xFF78909C);

  /// Magnitude 2.0-2.9 - Minor (green)
  static const Color magnitudeMinor = Color(0xFF4CAF50);

  /// Magnitude 3.0-3.9 - Light (light green)
  static const Color magnitudeLight = Color(0xFF8BC34A);

  /// Magnitude 4.0-4.9 - Moderate (yellow)
  static const Color magnitudeModerate = Color(0xFFFDD835);

  /// Magnitude 5.0-5.9 - Strong (amber)
  static const Color magnitudeStrong = Color(0xFFFFB300);

  /// Magnitude 6.0-6.9 - Major (orange)
  static const Color magnitudeMajor = Color(0xFFFF9800);

  /// Magnitude 7.0-7.9 - Great (deep orange)
  static const Color magnitudeGreat = Color(0xFFFF5722);

  /// Magnitude 8.0+ - Massive (red)
  static const Color magnitudeMassive = Color(0xFFD32F2F);

  // ============================================================
  // ALERT COLORS (PAGER Alert Levels)
  // ============================================================

  static const Color alertGreen = Color(0xFF4CAF50);
  static const Color alertYellow = Color(0xFFFDD835);
  static const Color alertOrange = Color(0xFFFF9800);
  static const Color alertRed = Color(0xFFD32F2F);

  // ============================================================
  // SEMANTIC COLORS
  // ============================================================

  /// Tsunami warning blue
  static const Color tsunami = Color(0xFF0288D1);
  static const Color tsunamiLight = Color(0xFFB3E5FC);

  /// Error states
  static const Color error = Color(0xFFB00020);
  static const Color errorLight = Color(0xFFFFCDD2);

  /// Success states
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFC8E6C9);

  /// Warning states
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFE0B2);

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Get magnitude color based on value with smooth interpolation
  static Color getMagnitudeColor(double magnitude) {
    if (magnitude < 2.0) return magnitudeMicro;
    if (magnitude < 3.0) return _lerpColor(magnitudeMicro, magnitudeMinor, (magnitude - 1) / 1);
    if (magnitude < 4.0) return _lerpColor(magnitudeMinor, magnitudeLight, (magnitude - 3) / 1);
    if (magnitude < 5.0) return _lerpColor(magnitudeLight, magnitudeModerate, (magnitude - 4) / 1);
    if (magnitude < 6.0) return _lerpColor(magnitudeModerate, magnitudeStrong, (magnitude - 5) / 1);
    if (magnitude < 7.0) return _lerpColor(magnitudeStrong, magnitudeMajor, (magnitude - 6) / 1);
    if (magnitude < 8.0) return _lerpColor(magnitudeMajor, magnitudeGreat, (magnitude - 7) / 1);
    if (magnitude < 9.0) return _lerpColor(magnitudeGreat, magnitudeMassive, (magnitude - 8) / 1);
    return magnitudeMassive;
  }

  /// Get alert color by alert level name
  static Color getAlertColor(String? alert) {
    switch (alert?.toLowerCase()) {
      case 'green':
        return alertGreen;
      case 'yellow':
        return alertYellow;
      case 'orange':
        return alertOrange;
      case 'red':
        return alertRed;
      default:
        return gray400;
    }
  }

  /// Get gradient stops for magnitude visualization
  static List<Color> get magnitudeGradient => [
        magnitudeMinor,
        magnitudeLight,
        magnitudeModerate,
        magnitudeStrong,
        magnitudeMajor,
        magnitudeGreat,
        magnitudeMassive,
      ];

  /// Linear interpolation between two colors
  static Color _lerpColor(Color a, Color b, double t) {
    return Color.lerp(a, b, t.clamp(0.0, 1.0)) ?? a;
  }
}

/// Extension for easy color opacity adjustments
extension ColorOpacity on Color {
  Color get opacity5 => withAlpha((0.05 * 255).round());
  Color get opacity10 => withAlpha((0.10 * 255).round());
  Color get opacity15 => withAlpha((0.15 * 255).round());
  Color get opacity20 => withAlpha((0.20 * 255).round());
  Color get opacity30 => withAlpha((0.30 * 255).round());
  Color get opacity50 => withAlpha((0.50 * 255).round());
  Color get opacity70 => withAlpha((0.70 * 255).round());
}
