import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// The name of [sign] in the language of [l10n].
String zodiacSignLabel(AppLocalizations l10n, ZodiacSign sign) =>
    switch (sign) {
      ZodiacSign.aries => l10n.signAries,
      ZodiacSign.taurus => l10n.signTaurus,
      ZodiacSign.gemini => l10n.signGemini,
      ZodiacSign.cancer => l10n.signCancer,
      ZodiacSign.leo => l10n.signLeo,
      ZodiacSign.virgo => l10n.signVirgo,
      ZodiacSign.libra => l10n.signLibra,
      ZodiacSign.scorpio => l10n.signScorpio,
      ZodiacSign.sagittarius => l10n.signSagittarius,
      ZodiacSign.capricorn => l10n.signCapricorn,
      ZodiacSign.aquarius => l10n.signAquarius,
      ZodiacSign.pisces => l10n.signPisces,
    };
