import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

/// The words, the face and the colour that stand for each [Mood].
extension MoodLabels on Mood {
  String label(AppLocalizations l10n) => switch (this) {
    Mood.happy => l10n.moodHappy,
    Mood.calm => l10n.moodCalm,
    Mood.tired => l10n.moodTired,
    Mood.sad => l10n.moodSad,
    Mood.anxious => l10n.moodAnxious,
    Mood.inLove => l10n.moodInLove,
  };

  /// A symbol, not a word: it needs no translation.
  String get emoji => switch (this) {
    Mood.happy => '😊',
    Mood.calm => '😌',
    Mood.tired => '😴',
    Mood.sad => '😢',
    Mood.anxious => '😟',
    Mood.inLove => '🥰',
  };

  /// The dot colour on the calendar, from the theme so dark mode follows.
  Color color(ColorScheme scheme) => switch (this) {
    Mood.happy => scheme.secondary,
    Mood.calm => scheme.primary,
    Mood.tired => scheme.outline,
    Mood.sad => scheme.onSurfaceVariant,
    Mood.anxious => scheme.error,
    Mood.inLove => scheme.tertiary,
  };
}
