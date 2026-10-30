import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/cosmic/astro/placement.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/partners/application/partner_chart.dart';

import '../support/fake_partners.dart';

void main() {
  test('a date alone gives a noon chart with a Sun sign', () {
    final chart = chartOfPartner(
      partner('a', birthDate: DateTime(1998, 5, 14)),
    );

    expect(chart.timeKnown, isFalse);
    expect(chart.ascendant, isNull);
    expect(chart.placementOf(Body.sun).sign, ZodiacSign.taurus);
  });

  test('a time and a place add the Ascendant', () {
    final chart = chartOfPartner(
      partner(
        'a',
        birthDate: DateTime(1998, 5, 14),
        birthMinutes: 14 * 60 + 30,
        birthPlace: bangkok,
      ),
    );

    expect(chart.timeKnown, isTrue);
    expect(chart.ascendantSign, isNotNull);
  });

  test('the Sun changes sign on the cusp dates', () {
    ZodiacSign sunOn(int month, int day) =>
        chartOfPartner(partner('a', birthDate: DateTime(2000, month, day)))
            .placementOf(Body.sun)
            .sign;

    expect(sunOn(3, 25), ZodiacSign.aries);
    expect(sunOn(7, 4), ZodiacSign.cancer);
    expect(sunOn(12, 25), ZodiacSign.capricorn);
  });
}
