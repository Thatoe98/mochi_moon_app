import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/moon_phase.dart';

/// The name of [phase] in the language of [l10n].
String moonPhaseLabel(AppLocalizations l10n, MoonPhaseName phase) =>
    switch (phase) {
      MoonPhaseName.newMoon => l10n.moonPhaseNewMoon,
      MoonPhaseName.waxingCrescent => l10n.moonPhaseWaxingCrescent,
      MoonPhaseName.firstQuarter => l10n.moonPhaseFirstQuarter,
      MoonPhaseName.waxingGibbous => l10n.moonPhaseWaxingGibbous,
      MoonPhaseName.fullMoon => l10n.moonPhaseFullMoon,
      MoonPhaseName.waningGibbous => l10n.moonPhaseWaningGibbous,
      MoonPhaseName.lastQuarter => l10n.moonPhaseLastQuarter,
      MoonPhaseName.waningCrescent => l10n.moonPhaseWaningCrescent,
    };

/// The affirmation that goes with [phase]: intentions at the new moon,
/// gratitude at the full moon, letting go as it wanes.
String moonAffirmation(AppLocalizations l10n, MoonPhaseName phase) =>
    switch (phase) {
      MoonPhaseName.newMoon => l10n.moonAffirmationNewMoon,
      MoonPhaseName.waxingCrescent => l10n.moonAffirmationWaxingCrescent,
      MoonPhaseName.firstQuarter => l10n.moonAffirmationFirstQuarter,
      MoonPhaseName.waxingGibbous => l10n.moonAffirmationWaxingGibbous,
      MoonPhaseName.fullMoon => l10n.moonAffirmationFullMoon,
      MoonPhaseName.waningGibbous => l10n.moonAffirmationWaningGibbous,
      MoonPhaseName.lastQuarter => l10n.moonAffirmationLastQuarter,
      MoonPhaseName.waningCrescent => l10n.moonAffirmationWaningCrescent,
    };
