import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/aspects.dart';
import 'package:mochi_moon/features/cosmic/astro/synastry.dart';
import 'package:mochi_moon/features/cosmic/chart/presentation/chart_labels.dart';
import 'package:mochi_moon/features/partners/domain/compatibility_band.dart';

/// The one-line summary under the meter.
String compatibilitySummary(AppLocalizations l10n, CompatibilityBand band) =>
    switch (band) {
      CompatibilityBand.low => l10n.compatSummaryLow,
      CompatibilityBand.mid => l10n.compatSummaryMid,
      CompatibilityBand.high => l10n.compatSummaryHigh,
    };

String synastryThemeLabel(AppLocalizations l10n, SynastryTheme theme) =>
    switch (theme) {
      SynastryTheme.romance => l10n.compatThemeRomance,
      SynastryTheme.emotional => l10n.compatThemeEmotional,
      SynastryTheme.communication => l10n.compatThemeCommunication,
    };

/// The name of a compared point; the Ascendant reads as Rising.
String synastryPointLabel(AppLocalizations l10n, SynastryPoint point) {
  final body = point.body;
  return body == null ? l10n.chartBodyRising : bodyLabel(l10n, body);
}

/// The plain-language sentence for an aspect type.
String aspectText(AppLocalizations l10n, AspectType type) => switch (type) {
  AspectType.conjunction => l10n.compatAspectConjunction,
  AspectType.sextile => l10n.compatAspectSextile,
  AspectType.trine => l10n.compatAspectTrine,
  AspectType.square => l10n.compatAspectSquare,
  AspectType.opposition => l10n.compatAspectOpposition,
};
