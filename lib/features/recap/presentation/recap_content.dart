import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/mood/presentation/mood_labels.dart';
import 'package:mochi_moon/features/recap/application/recap_providers.dart';
import 'package:mochi_moon/features/recap/presentation/recap_image.dart';

/// The month's name in the app's language.
String recapMonthName(BuildContext context, DateTime month) =>
    DateFormat.MMMM(Localizations.localeOf(context).toString()).format(month);

/// The story image for [view], built from the app's own words only.
RecapImage buildRecapImage(BuildContext context, RecapView view) {
  final l10n = AppLocalizations.of(context);
  final lang = Localizations.localeOf(context).languageCode;
  final recap = view.recap;
  if (recap.isWelcomeBack) {
    return RecapImage(
      headline: l10n.recapWelcomeBackTitle,
      wordmark: l10n.appName,
      welcomeBody: l10n.recapWelcomeBackBody,
    );
  }
  final mood = recap.topMood;
  return RecapImage(
    headline: l10n.recapHeadline(recapMonthName(context, recap.month)),
    wordmark: l10n.appName,
    days: recap.daysShownUp,
    daysLabel: l10n.recapDays(recap.daysShownUp),
    moodEmoji: mood?.emoji,
    moodLine: mood == null ? null : l10n.recapTopMood(mood.label(l10n)),
    favouriteLabel: view.favourite == null ? null : l10n.recapFavouriteLabel,
    favouriteText: view.favourite?.textFor(lang),
  );
}
