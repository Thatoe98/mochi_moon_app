import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';

/// The three placements the Big 3 cards explain (PRD §6.11).
enum BigThreeRole { sun, moon, rising }

/// The name of [body] in the language of [l10n].
String bodyLabel(AppLocalizations l10n, Body body) => switch (body) {
  Body.sun => l10n.chartBodySun,
  Body.moon => l10n.chartBodyMoon,
  Body.mercury => l10n.chartBodyMercury,
  Body.venus => l10n.chartBodyVenus,
  Body.mars => l10n.chartBodyMars,
  Body.jupiter => l10n.chartBodyJupiter,
  Body.saturn => l10n.chartBodySaturn,
  Body.uranus => l10n.chartBodyUranus,
  Body.neptune => l10n.chartBodyNeptune,
  Body.pluto => l10n.chartBodyPluto,
};

/// The title of a Big 3 card: Sun, Moon or Rising.
String bigThreeRoleLabel(AppLocalizations l10n, BigThreeRole role) =>
    switch (role) {
      BigThreeRole.sun => l10n.chartBodySun,
      BigThreeRole.moon => l10n.chartBodyMoon,
      BigThreeRole.rising => l10n.chartBodyRising,
    };

/// The short bundled text for [role] in [sign].
String bigThreeText(
  AppLocalizations l10n,
  BigThreeRole role,
  ZodiacSign sign,
) => switch (role) {
  BigThreeRole.sun => switch (sign) {
    ZodiacSign.aries => l10n.chartSunAries,
    ZodiacSign.taurus => l10n.chartSunTaurus,
    ZodiacSign.gemini => l10n.chartSunGemini,
    ZodiacSign.cancer => l10n.chartSunCancer,
    ZodiacSign.leo => l10n.chartSunLeo,
    ZodiacSign.virgo => l10n.chartSunVirgo,
    ZodiacSign.libra => l10n.chartSunLibra,
    ZodiacSign.scorpio => l10n.chartSunScorpio,
    ZodiacSign.sagittarius => l10n.chartSunSagittarius,
    ZodiacSign.capricorn => l10n.chartSunCapricorn,
    ZodiacSign.aquarius => l10n.chartSunAquarius,
    ZodiacSign.pisces => l10n.chartSunPisces,
  },
  BigThreeRole.moon => switch (sign) {
    ZodiacSign.aries => l10n.chartMoonAries,
    ZodiacSign.taurus => l10n.chartMoonTaurus,
    ZodiacSign.gemini => l10n.chartMoonGemini,
    ZodiacSign.cancer => l10n.chartMoonCancer,
    ZodiacSign.leo => l10n.chartMoonLeo,
    ZodiacSign.virgo => l10n.chartMoonVirgo,
    ZodiacSign.libra => l10n.chartMoonLibra,
    ZodiacSign.scorpio => l10n.chartMoonScorpio,
    ZodiacSign.sagittarius => l10n.chartMoonSagittarius,
    ZodiacSign.capricorn => l10n.chartMoonCapricorn,
    ZodiacSign.aquarius => l10n.chartMoonAquarius,
    ZodiacSign.pisces => l10n.chartMoonPisces,
  },
  BigThreeRole.rising => switch (sign) {
    ZodiacSign.aries => l10n.chartRisingAries,
    ZodiacSign.taurus => l10n.chartRisingTaurus,
    ZodiacSign.gemini => l10n.chartRisingGemini,
    ZodiacSign.cancer => l10n.chartRisingCancer,
    ZodiacSign.leo => l10n.chartRisingLeo,
    ZodiacSign.virgo => l10n.chartRisingVirgo,
    ZodiacSign.libra => l10n.chartRisingLibra,
    ZodiacSign.scorpio => l10n.chartRisingScorpio,
    ZodiacSign.sagittarius => l10n.chartRisingSagittarius,
    ZodiacSign.capricorn => l10n.chartRisingCapricorn,
    ZodiacSign.aquarius => l10n.chartRisingAquarius,
    ZodiacSign.pisces => l10n.chartRisingPisces,
  },
};

/// [degreeInSign] (0 to 30) as degrees and minutes, such as 12°34′. Minutes
/// are cut, not rounded, as astrologers do, so a placement never reads as
/// 30°00′ of the sign it is not in yet.
String formatDegrees(double degreeInSign) {
  final degrees = degreeInSign.floor();
  final minutes = ((degreeInSign - degrees) * 60).floor();
  return '$degrees°${minutes.toString().padLeft(2, '0')}′';
}
