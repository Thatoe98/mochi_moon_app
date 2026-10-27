// TODO(fonts): drop this ignore once the font families below are non-null.
// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';

/// Bundled font families. Font files are declared in `pubspec.yaml` once added
/// to `assets/fonts/`; until then the platform default is used.
abstract final class AppFonts {
  // TODO(fonts): bundle Fredoka (display) and Nunito (body), see PRD M0.
  static const String? display = null;
  static const String? body = null;

  /// Glyph coverage for Burmese regardless of the active locale.
  /// Noto Sans Thai is added when Thai ships (deferred).
  static const List<String> fallback = ['Noto Sans Myanmar'];
}

abstract final class AppTypography {
  static TextTheme textTheme(Color ink) {
    TextStyle base(double size, FontWeight weight, {String? family}) =>
        TextStyle(
          fontFamily: family ?? AppFonts.body,
          fontFamilyFallback: AppFonts.fallback,
          fontSize: size,
          fontWeight: weight,
          color: ink,
          height: 1.35,
        );

    return TextTheme(
      displaySmall: base(32, FontWeight.w600, family: AppFonts.display),
      headlineMedium: base(26, FontWeight.w600, family: AppFonts.display),
      titleLarge: base(22, FontWeight.w600, family: AppFonts.display),
      titleMedium: base(18, FontWeight.w600),
      bodyLarge: base(16, FontWeight.normal),
      bodyMedium: base(14, FontWeight.normal),
      labelLarge: base(14, FontWeight.w700),
    );
  }
}
