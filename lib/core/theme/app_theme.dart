import 'package:flutter/material.dart';
import 'package:mochi_moon/core/theme/app_colors.dart';
import 'package:mochi_moon/core/theme/app_radii.dart';
import 'package:mochi_moon/core/theme/app_spacing.dart';
import 'package:mochi_moon/core/theme/app_typography.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lavender,
      onPrimary: AppColors.plum,
      primaryContainer: AppColors.lavenderSoft,
      onPrimaryContainer: AppColors.plum,
      secondary: AppColors.peach,
      onSecondary: AppColors.plum,
      tertiary: AppColors.pink,
      onTertiary: AppColors.plum,
      error: AppColors.error,
      onError: AppColors.creamRaised,
      surface: AppColors.cream,
      onSurface: AppColors.plum,
      onSurfaceVariant: AppColors.plumMuted,
      surfaceContainerHighest: AppColors.creamRaised,
      outline: AppColors.plumMuted,
      shadow: AppColors.shadow,
    ),
  );

  static ThemeData get dark => _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.nightLavender,
      onPrimary: AppColors.nightBackground,
      primaryContainer: AppColors.nightRaised,
      onPrimaryContainer: AppColors.nightInk,
      secondary: AppColors.peach,
      onSecondary: AppColors.nightBackground,
      tertiary: AppColors.pink,
      onTertiary: AppColors.nightBackground,
      error: AppColors.nightError,
      onError: AppColors.nightBackground,
      surface: AppColors.nightBackground,
      onSurface: AppColors.nightInk,
      onSurfaceVariant: AppColors.nightInkMuted,
      surfaceContainerHighest: AppColors.nightRaised,
      outline: AppColors.nightInkMuted,
      shadow: AppColors.shadowDark,
    ),
  );

  static ThemeData _build(ColorScheme scheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: AppTypography.textTheme(scheme.onSurface),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerHighest,
        elevation: 2,
        shadowColor: scheme.shadow,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(
            AppSpacing.minTouchTarget,
            AppSpacing.minTouchTarget,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadii.buttonRadius,
          ),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surfaceContainerHighest,
        indicatorColor: scheme.primaryContainer,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? scheme.onPrimaryContainer
                : scheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
