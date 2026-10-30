import 'package:flutter/material.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/utils/english_dates.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/retrograde/domain/retrograde_status.dart';

/// The name of [body] in the language of [l10n], for the planets that turn
/// retrograde.
String retrogradePlanetLabel(AppLocalizations l10n, Body body) =>
    switch (body) {
      Body.mercury => l10n.retroMercury,
      Body.venus => l10n.retroVenus,
      Body.mars => l10n.retroMars,
      Body.jupiter => l10n.retroJupiter,
      Body.saturn => l10n.retroSaturn,
      _ => throw ArgumentError.value(body, 'body', 'has no retrograde'),
    };

/// The evergreen tip for [body]'s retrogrades.
String retrogradeTip(AppLocalizations l10n, Body body) => switch (body) {
  Body.mercury => l10n.retroTipMercury,
  Body.venus => l10n.retroTipVenus,
  Body.mars => l10n.retroTipMars,
  Body.jupiter => l10n.retroTipJupiter,
  Body.saturn => l10n.retroTipSaturn,
  _ => throw ArgumentError.value(body, 'body', 'has no retrograde'),
};

/// Three short, kind things to try during [body]'s retrograde.
List<String> retrogradeTips(AppLocalizations l10n, Body body) => switch (body) {
  Body.mercury => [
    l10n.retroTipMercury1,
    l10n.retroTipMercury2,
    l10n.retroTipMercury3,
  ],
  Body.venus => [l10n.retroTipVenus1, l10n.retroTipVenus2, l10n.retroTipVenus3],
  Body.mars => [l10n.retroTipMars1, l10n.retroTipMars2, l10n.retroTipMars3],
  Body.jupiter => [
    l10n.retroTipJupiter1,
    l10n.retroTipJupiter2,
    l10n.retroTipJupiter3,
  ],
  Body.saturn => [
    l10n.retroTipSaturn1,
    l10n.retroTipSaturn2,
    l10n.retroTipSaturn3,
  ],
  _ => throw ArgumentError.value(body, 'body', 'has no retrograde'),
};

/// The headline and, when there is one, the countdown line for [status].
(String, String?) retrogradeStatusText(
  BuildContext context,
  Body body,
  RetrogradeStatus status,
) {
  final l10n = AppLocalizations.of(context);
  const dates = englishDates;
  final planet = retrogradePlanetLabel(l10n, body);
  return switch (status) {
    IsRetrograde(:final until) => (
      l10n.retroStatusRetrograde(
        planet,
        dates.formatShortMonthDay(until.toLocal()),
      ),
      null,
    ),
    NextRetrograde(:final starts, :final daysAway) => (
      l10n.retroStatusNext(planet, dates.formatShortMonthDay(starts.toLocal())),
      switch (daysAway) {
        0 => l10n.retroStartsToday,
        1 => l10n.retroStartsTomorrow,
        _ => l10n.retroStartsInDays(daysAway),
      },
    ),
  };
}
