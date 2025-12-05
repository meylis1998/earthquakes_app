import 'package:flutter/material.dart';

/// Design tokens for consistent spacing, sizing, and timing across the app.
/// Based on a 4-point grid system for visual harmony.
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  /// Common padding presets
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  /// Horizontal padding presets
  static const EdgeInsets paddingHorizontalLg =
      EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets paddingHorizontalXl =
      EdgeInsets.symmetric(horizontal: xl);
}

/// Border radius tokens for consistent rounded corners.
abstract class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double full = 9999;

  /// BorderRadius presets
  static final BorderRadius borderRadiusSm = BorderRadius.circular(sm);
  static final BorderRadius borderRadiusMd = BorderRadius.circular(md);
  static final BorderRadius borderRadiusLg = BorderRadius.circular(lg);
  static final BorderRadius borderRadiusXl = BorderRadius.circular(xl);

  /// Top-only radius for bottom sheets
  static final BorderRadius borderRadiusTopXl = BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );
}

/// Animation duration tokens following Material 3 motion guidelines.
/// Micro-interactions: 50-200ms
/// Standard transitions: 150-350ms
abstract class AppDurations {
  /// Ultra-fast feedback (button press, icon change)
  static const Duration micro = Duration(milliseconds: 100);

  /// Fast transitions (fade, small movements)
  static const Duration fast = Duration(milliseconds: 150);

  /// Standard transitions (page changes, cards)
  static const Duration normal = Duration(milliseconds: 250);

  /// Slow transitions (complex animations, emphasis)
  static const Duration slow = Duration(milliseconds: 350);

  /// Extra slow for dramatic effect
  static const Duration slower = Duration(milliseconds: 500);

  /// Stagger delay between list items
  static const Duration stagger = Duration(milliseconds: 50);
}

/// Animation curve tokens for natural motion.
abstract class AppCurves {
  /// Standard easing for most transitions
  static const Curve standard = Curves.easeInOutCubic;

  /// Enter transitions (elements appearing)
  static const Curve enter = Curves.easeOutCubic;

  /// Exit transitions (elements leaving)
  static const Curve exit = Curves.easeInCubic;

  /// Emphasized transitions
  static const Curve emphasized = Curves.easeInOutQuart;

  /// Bounce effect for playful feedback
  static const Curve bounce = Curves.elasticOut;

  /// Spring effect for natural physics
  static const Curve spring = Curves.easeOutBack;
}

/// Elevation/shadow tokens
abstract class AppElevation {
  static const double none = 0;
  static const double xs = 1;
  static const double sm = 2;
  static const double md = 4;
  static const double lg = 8;
  static const double xl = 16;
}

/// Icon size tokens
abstract class AppIconSize {
  static const double xs = 14;
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}
