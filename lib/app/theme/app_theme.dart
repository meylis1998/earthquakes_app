import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_typography.dart';
import 'design_tokens.dart';

/// App theme configuration with monochromatic elegance.
/// Provides both light and dark themes using the design system.
class AppTheme {
  AppTheme._();

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      // Primary
      primary: AppColors.primary700,
      onPrimary: Colors.white,
      primaryContainer: AppColors.primary100,
      onPrimaryContainer: AppColors.primary900,
      // Secondary (using primary family for monochromatic)
      secondary: AppColors.primary500,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.primary50,
      onSecondaryContainer: AppColors.primary800,
      // Tertiary
      tertiary: AppColors.primary400,
      onTertiary: Colors.white,
      tertiaryContainer: AppColors.primary100,
      onTertiaryContainer: AppColors.primary900,
      // Error
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorLight,
      onErrorContainer: AppColors.error,
      // Surface
      surface: AppColors.surfaceLight,
      onSurface: AppColors.gray900,
      onSurfaceVariant: AppColors.gray600,
      // Outline
      outline: AppColors.gray300,
      outlineVariant: AppColors.gray200,
      // Inverse
      inverseSurface: AppColors.gray800,
      onInverseSurface: AppColors.gray50,
      inversePrimary: AppColors.primary200,
      // Shadow & scrim
      shadow: AppColors.gray900,
      scrim: AppColors.gray900,
      // Surface containers
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: AppColors.gray50,
      surfaceContainer: AppColors.surfaceContainerLight,
      surfaceContainerHigh: AppColors.surfaceVariantLight,
      surfaceContainerHighest: AppColors.gray200,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      textTheme: AppTypography.lightTextTheme,
      scaffoldBackgroundColor: AppColors.surfaceLight,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.gray900,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: AppTypography.lightTextTheme.titleLarge,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: AppElevation.xs,
        shadowColor: AppColors.gray900.withAlpha(25),
        surfaceTintColor: Colors.transparent,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        margin: EdgeInsets.zero,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.gray100,
        selectedColor: AppColors.primary100,
        disabledColor: AppColors.gray100,
        labelStyle: AppTypography.lightTextTheme.labelMedium,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusSm,
        ),
        side: BorderSide.none,
      ),

      // FilledButton
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          textStyle: AppTypography.lightTextTheme.labelLarge,
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          side: BorderSide(color: AppColors.gray300),
          textStyle: AppTypography.lightTextTheme.labelLarge,
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusSm,
          ),
          textStyle: AppTypography.lightTextTheme.labelLarge,
        ),
      ),

      // IconButton
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusSm,
          ),
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppElevation.md,
        highlightElevation: AppElevation.lg,
        backgroundColor: AppColors.primary700,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: AppColors.primary700,
        unselectedItemColor: AppColors.gray500,
        selectedLabelStyle: AppTypography.lightTextTheme.labelSmall,
        unselectedLabelStyle: AppTypography.lightTextTheme.labelSmall,
      ),

      // NavigationBar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primary100,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.lightTextTheme.labelSmall?.copyWith(
              color: AppColors.primary700,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.lightTextTheme.labelSmall?.copyWith(
            color: AppColors.gray500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: AppColors.primary700,
              size: AppIconSize.lg,
            );
          }
          return IconThemeData(
            color: AppColors.gray500,
            size: AppIconSize.lg,
          );
        }),
      ),

      // BottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.lg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusTopXl,
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.gray300,
        dragHandleSize: const Size(32, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.xl,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusXl,
        ),
        titleTextStyle: AppTypography.lightTextTheme.titleLarge,
        contentTextStyle: AppTypography.lightTextTheme.bodyMedium,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.gray200,
        thickness: 1,
        space: 1,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        titleTextStyle: AppTypography.lightTextTheme.titleMedium,
        subtitleTextStyle: AppTypography.lightTextTheme.bodySmall,
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray50,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.primary500, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.lightTextTheme.bodyMedium?.copyWith(
          color: AppColors.gray400,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.gray800,
        contentTextStyle: AppTypography.darkTextTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppElevation.md,
      ),

      // Progress indicators
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary500,
        linearTrackColor: AppColors.primary100,
        circularTrackColor: AppColors.primary100,
      ),
    );
  }

  // ============================================================
  // DARK THEME
  // ============================================================

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      // Primary
      primary: AppColors.primary400,
      onPrimary: AppColors.primary900,
      primaryContainer: AppColors.primary800,
      onPrimaryContainer: AppColors.primary100,
      // Secondary
      secondary: AppColors.primary300,
      onSecondary: AppColors.primary900,
      secondaryContainer: AppColors.primary700,
      onSecondaryContainer: AppColors.primary50,
      // Tertiary
      tertiary: AppColors.primary200,
      onTertiary: AppColors.primary900,
      tertiaryContainer: AppColors.primary800,
      onTertiaryContainer: AppColors.primary100,
      // Error
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      // Surface
      surface: AppColors.surfaceDark,
      onSurface: AppColors.gray50,
      onSurfaceVariant: AppColors.gray400,
      // Outline
      outline: AppColors.gray600,
      outlineVariant: AppColors.gray700,
      // Inverse
      inverseSurface: AppColors.gray100,
      onInverseSurface: AppColors.gray800,
      inversePrimary: AppColors.primary700,
      // Shadow & scrim
      shadow: Colors.black,
      scrim: Colors.black,
      // Surface containers
      surfaceContainerLowest: AppColors.gray900,
      surfaceContainerLow: AppColors.surfaceDark,
      surfaceContainer: AppColors.surfaceContainerDark,
      surfaceContainerHigh: AppColors.surfaceVariantDark,
      surfaceContainerHighest: AppColors.gray700,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      textTheme: AppTypography.darkTextTheme,
      scaffoldBackgroundColor: AppColors.surfaceDark,

      // AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.gray50,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: AppTypography.darkTextTheme.titleLarge,
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: AppElevation.xs,
        shadowColor: Colors.black38,
        surfaceTintColor: Colors.transparent,
        color: AppColors.surfaceContainerDark,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        margin: EdgeInsets.zero,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.gray800,
        selectedColor: AppColors.primary800,
        disabledColor: AppColors.gray800,
        labelStyle: AppTypography.darkTextTheme.labelMedium,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusSm,
        ),
        side: BorderSide.none,
      ),

      // FilledButton
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          textStyle: AppTypography.darkTextTheme.labelLarge,
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
          side: BorderSide(color: AppColors.gray600),
          textStyle: AppTypography.darkTextTheme.labelLarge,
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusSm,
          ),
          textStyle: AppTypography.darkTextTheme.labelLarge,
        ),
      ),

      // IconButton
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(AppSpacing.sm),
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusSm,
          ),
        ),
      ),

      // FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppElevation.md,
        highlightElevation: AppElevation.lg,
        backgroundColor: AppColors.primary500,
        foregroundColor: AppColors.gray900,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusLg,
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surfaceContainerDark,
        elevation: 0,
        selectedItemColor: AppColors.primary400,
        unselectedItemColor: AppColors.gray500,
        selectedLabelStyle: AppTypography.darkTextTheme.labelSmall,
        unselectedLabelStyle: AppTypography.darkTextTheme.labelSmall,
      ),

      // NavigationBar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        backgroundColor: AppColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        indicatorColor: AppColors.primary800,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.darkTextTheme.labelSmall?.copyWith(
              color: AppColors.primary300,
              fontWeight: FontWeight.w600,
            );
          }
          return AppTypography.darkTextTheme.labelSmall?.copyWith(
            color: AppColors.gray500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: AppColors.primary300,
              size: AppIconSize.lg,
            );
          }
          return IconThemeData(
            color: AppColors.gray500,
            size: AppIconSize.lg,
          );
        }),
      ),

      // BottomSheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.lg,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusTopXl,
        ),
        showDragHandle: true,
        dragHandleColor: AppColors.gray600,
        dragHandleSize: const Size(32, 4),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceContainerDark,
        surfaceTintColor: Colors.transparent,
        elevation: AppElevation.xl,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusXl,
        ),
        titleTextStyle: AppTypography.darkTextTheme.titleLarge,
        contentTextStyle: AppTypography.darkTextTheme.bodyMedium,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: AppColors.gray700,
        thickness: 1,
        space: 1,
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.xs,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        titleTextStyle: AppTypography.darkTextTheme.titleMedium,
        subtitleTextStyle: AppTypography.darkTextTheme.bodySmall,
      ),

      // Input decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.gray800,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.primary400, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderRadiusMd,
          borderSide: BorderSide(color: AppColors.error, width: 1),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        hintStyle: AppTypography.darkTextTheme.bodyMedium?.copyWith(
          color: AppColors.gray500,
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.gray100,
        contentTextStyle: AppTypography.lightTextTheme.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.borderRadiusMd,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: AppElevation.md,
      ),

      // Progress indicators
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: AppColors.primary400,
        linearTrackColor: AppColors.primary900,
        circularTrackColor: AppColors.primary900,
      ),
    );
  }
}
