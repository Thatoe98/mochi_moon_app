import 'package:flutter/material.dart';

/// Raw palette. Widgets must read colors from `Theme.of(context)`, never here.
abstract final class AppColors {
  // Light
  static const lavender = Color(0xFFB9A3E3);
  static const lavenderSoft = Color(0xFFE9E0FA);
  static const peach = Color(0xFFFFC4A3);
  static const pink = Color(0xFFF7B2C4);
  static const cream = Color(0xFFFFF8EE);
  static const creamRaised = Color(0xFFFFFFFF);
  static const plum = Color(0xFF3E2A4F);
  static const plumMuted = Color(0xFF6E5A80);
  static const error = Color(0xFFC2415C);

  // Dark
  static const nightBackground = Color(0xFF1F1626);
  static const nightRaised = Color(0xFF2B2035);
  static const nightLavender = Color(0xFFCDBBF2);
  static const nightInk = Color(0xFFF4ECFA);
  static const nightInkMuted = Color(0xFFB9A8C9);
  static const nightError = Color(0xFFFF8FA6);

  static const shadow = Color(0x1F3E2A4F);
  static const shadowDark = Color(0xFF000000);
}
