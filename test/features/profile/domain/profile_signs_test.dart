import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/profile_signs.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

const _bangkok = BirthPlace(
  name: 'Bangkok',
  region: 'Bangkok',
  countryCode: 'TH',
  lat: 13.75,
  lng: 100.5,
  tzId: 'Asia/Bangkok',
);

void main() {
  test('has no signs without a birth date', () {
    expect(signsOfProfile(const UserProfile(displayName: 'Mochi')), isNull);
  });

  test('works out Sun, Moon and Rising from a known birth time', () {
    final signs = signsOfProfile(
      UserProfile(
        displayName: 'Mochi',
        birthDate: DateTime(1998, 11, 8),
        birthMinutes: 8 * 60 + 30,
        birthPlace: _bangkok,
      ),
    )!;

    expect(signs.sun, 'scorpio');
    expect(signs.moon, 'cancer');
    expect(signs.moonApproximate, isFalse);
    expect(signs.rising, 'sagittarius');
  });

  test('leaves Rising out and marks the Moon approximate without a time', () {
    final signs = signsOfProfile(
      UserProfile(
        displayName: 'Mochi',
        birthDate: DateTime(1998, 11, 8),
        birthPlace: _bangkok,
      ),
    )!;

    expect(signs.sun, 'scorpio');
    expect(signs.moonApproximate, isTrue);
    expect(signs.rising, isNull);
  });

  test('works without a birthplace', () {
    final signs = signsOfProfile(
      UserProfile(displayName: 'Mochi', birthDate: DateTime(1998, 11, 8)),
    )!;

    expect(signs.sun, 'scorpio');
    expect(signs.rising, isNull);
  });

  test('a new birthday gives a new Sun sign', () {
    final signs = signsOfProfile(
      UserProfile(displayName: 'Mochi', birthDate: DateTime(1998, 5, 14)),
    )!;

    expect(signs.sun, 'taurus');
  });

  test('writes the PRD §8.1 profile fields', () {
    final signs = signsOfProfile(
      UserProfile(displayName: 'Mochi', birthDate: DateTime(1998, 11, 8)),
    )!;

    expect(signs.toMap(), {
      'sunSign': 'scorpio',
      'moonSign': signs.moon,
      'moonApproximate': true,
      'risingSign': null,
    });
  });
}
