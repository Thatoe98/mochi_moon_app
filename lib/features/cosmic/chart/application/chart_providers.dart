import 'package:mochi_moon/features/cosmic/astro/birth_time.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chart_providers.g.dart';

/// The user's natal chart, or null while there is no birth date. It is cast
/// again whenever the profile changes, so editing the birth data updates it
/// (PRD §6.11).
@riverpod
Future<NatalChart?> natalChart(Ref ref) async {
  final profile = await ref.watch(profileControllerProvider.future);
  final birthDate = profile?.birthDate;
  if (birthDate == null) return null;
  final place = profile?.birthPlace;
  return computeNatalChart(
    BirthData(
      birthDate: birthDate,
      birthMinutes: profile?.birthMinutes,
      tzId: place?.tzId ?? noPlaceTimeZone,
      latitude: place?.lat,
      longitude: place?.lng,
    ),
  );
}
