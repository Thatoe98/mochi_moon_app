import 'package:mochi_moon/core/l10n/app_localizations.dart';

/// Localized name of a quote category, or null for one we have no label for.
String? categoryLabel(AppLocalizations l10n, String category) =>
    switch (category) {
      'self_love' => l10n.categorySelfLove,
      'confidence' => l10n.categoryConfidence,
      'healing' => l10n.categoryHealing,
      'study_work' => l10n.categoryStudyWork,
      'body_kindness' => l10n.categoryBodyKindness,
      'calm' => l10n.categoryCalm,
      _ => null,
    };
