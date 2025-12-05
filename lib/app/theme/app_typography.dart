import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography system with clear hierarchy for readability and visual appeal.
/// Uses system fonts (Roboto on Android, SF Pro on iOS) for optimal rendering.
abstract class AppTypography {
  /// Creates the complete TextTheme for light mode
  static TextTheme get lightTextTheme => _createTextTheme(
        primaryColor: AppColors.gray900,
        secondaryColor: AppColors.gray600,
      );

  /// Creates the complete TextTheme for dark mode
  static TextTheme get darkTextTheme => _createTextTheme(
        primaryColor: AppColors.gray50,
        secondaryColor: AppColors.gray400,
      );

  static TextTheme _createTextTheme({
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    return TextTheme(
      // ============================================================
      // DISPLAY - Hero elements (magnitude numbers)
      // ============================================================

      /// Large display text - for hero magnitude numbers
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        height: 1.12,
        color: primaryColor,
      ),

      /// Medium display - for prominent numbers
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.16,
        color: primaryColor,
      ),

      /// Small display - for stats
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.22,
        color: primaryColor,
      ),

      // ============================================================
      // HEADLINE - Screen titles and headers
      // ============================================================

      /// Large headline - screen titles
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
        color: primaryColor,
      ),

      /// Medium headline - section titles
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
        color: primaryColor,
      ),

      /// Small headline - subsections
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
        letterSpacing: 0,
        height: 1.33,
        color: primaryColor,
      ),

      // ============================================================
      // TITLE - Card titles and list items
      // ============================================================

      /// Large title - card headers
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
        color: primaryColor,
      ),

      /// Medium title - list item titles
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.50,
        color: primaryColor,
      ),

      /// Small title - compact titles
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
        color: primaryColor,
      ),

      // ============================================================
      // BODY - Main content text
      // ============================================================

      /// Large body - primary content
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
        color: primaryColor,
      ),

      /// Medium body - standard content
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        color: primaryColor,
      ),

      /// Small body - secondary content
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        color: secondaryColor,
      ),

      // ============================================================
      // LABEL - Buttons, chips, badges
      // ============================================================

      /// Large label - buttons
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
        color: primaryColor,
      ),

      /// Medium label - chips, tabs
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.33,
        color: primaryColor,
      ),

      /// Small label - badges, captions
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        height: 1.45,
        color: secondaryColor,
      ),
    );
  }
}

/// Extension for common text style modifications
extension TextStyleModifiers on TextStyle {
  /// Make text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);

  /// Make text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Make text medium weight
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Make text regular weight
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);

  /// Make text light weight
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  /// Apply secondary color (for less prominent text)
  TextStyle secondary(BuildContext context) => copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      );

  /// Apply primary brand color
  TextStyle primary(BuildContext context) => copyWith(
        color: Theme.of(context).colorScheme.primary,
      );

  /// Apply error color
  TextStyle error(BuildContext context) => copyWith(
        color: Theme.of(context).colorScheme.error,
      );
}
