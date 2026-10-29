import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/features/cosmic/astro/ephemeris.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/sun_moon_signs.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/today/data/bundled_daily_reading_repository.dart';
import 'package:mochi_moon/features/cosmic/today/data/prefs_thai_colors_setting_repository.dart';
import 'package:mochi_moon/features/cosmic/today/domain/cosmic_today.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading_repository.dart';
import 'package:mochi_moon/features/cosmic/today/domain/lucky_picks.dart';
import 'package:mochi_moon/features/cosmic/today/domain/thai_colors_setting.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'cosmic_today_providers.g.dart';

/// The zone used to read a birth date when no birthplace was given. UTC can
/// put a birth within half a day of a sign change in the neighbouring sign.
const _noPlaceZone = 'UTC';

@Riverpod(keepAlive: true)
DailyReadingRepository dailyReadingRepository(Ref ref) =>
    BundledDailyReadingRepository(ref.watch(contentRepositoryProvider));

@Riverpod(keepAlive: true)
ThaiColorsSettingRepository thaiColorsSettingRepository(Ref ref) =>
    PrefsThaiColorsSettingRepository(SharedPreferencesAsync());

/// The user's choice on the Thai colors switch for [lang], falling back to
/// the default for that language.
@riverpod
class ShowThaiColors extends _$ShowThaiColors {
  @override
  Future<bool> build(String lang) async {
    final saved = await ref.watch(thaiColorsSettingRepositoryProvider).load();
    return saved ?? thaiColorsDefaultFor(lang);
  }

  Future<void> set({required bool enabled}) async {
    await ref.read(thaiColorsSettingRepositoryProvider).save(enabled: enabled);
    state = AsyncData(enabled);
  }
}

/// The user's Sun sign, or null while there is no birth date.
@riverpod
Future<ZodiacSign?> userSunSign(Ref ref) async {
  final profile = await ref.watch(profileControllerProvider.future);
  final birthDate = profile?.birthDate;
  if (birthDate == null) return null;
  return sunMoonSigns(
    birthDate: birthDate,
    tzId: profile?.birthPlace?.tzId ?? _noPlaceZone,
    birthMinutes: profile?.birthMinutes,
  ).sun;
}

/// Today's page for the user in [lang], or null until the profile has a birth
/// date. Rebuilds when the language or the profile changes.
@riverpod
Future<CosmicToday?> cosmicToday(Ref ref, String lang) async {
  final sun = await ref.watch(userSunSignProvider.future);
  if (sun == null) return null;
  final profile = ref.watch(profileControllerProvider).value;
  final now = ref.watch(clockProvider)();
  final date = DateTime(now.year, now.month, now.day);

  final signs = await ref.watch(signsProvider.future);
  final colors = await ref.watch(dayColorsProvider.future);
  final reading = await ref
      .watch(dailyReadingRepositoryProvider)
      .readingFor(sign: sun, date: date, lang: lang);

  final moonSign = signOfLongitude(longitudeAt(Body.moon, now.toUtc()));
  return CosmicToday(
    date: date,
    sign: sun,
    moonSign: moonSign,
    reading: reading,
    luckyColors: luckyColors(
      sign: signs[sun.index],
      moonElement: signs[moonSign.index].element,
      colors: colors,
      date: date,
    ),
    luckyNumber: luckyNumber(signIndex: sun.index, date: date),
    thaiColors: thaiColors(
      colors: colors,
      date: date,
      birthDate: profile?.birthDate,
    ),
  );
}
