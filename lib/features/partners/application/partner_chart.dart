import 'package:mochi_moon/features/cosmic/astro/birth_time.dart';
import 'package:mochi_moon/features/cosmic/astro/natal_chart.dart';
import 'package:mochi_moon/features/partners/domain/partner.dart';

/// The natal chart of [partner], cast on the device from the saved birth data.
/// Without a birth time it is a noon chart with no Ascendant or houses.
NatalChart chartOfPartner(Partner partner) {
  final place = partner.birthPlace;
  return computeNatalChart(
    BirthData(
      birthDate: partner.birthDate,
      birthMinutes: partner.birthMinutes,
      tzId: place?.tzId ?? noPlaceTimeZone,
      latitude: place?.lat,
      longitude: place?.lng,
    ),
  );
}
