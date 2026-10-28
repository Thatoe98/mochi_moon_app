import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/profile/data/profile_codec.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

void main() {
  test('writes the Firestore shape from PRD 8.1', () {
    final map = profileToMap(
      UserProfile(
        displayName: 'Mochi',
        birthDate: DateTime(1998, 2, 4),
        birthMinutes: 7 * 60 + 5,
        focusAreas: const [FocusArea.calm, FocusArea.studyWork],
      ),
    );

    expect(map, {
      'displayName': 'Mochi',
      'profile': {
        'birthDate': '1998-02-04',
        'birthTime': '07:05',
        'timeKnown': true,
        'place': null,
        'focusAreas': ['calm', 'study_work'],
      },
    });
  });

  test('an unknown birth time is null and timeKnown is false', () {
    final map = profileToMap(
      UserProfile(displayName: 'Mochi', birthDate: DateTime(1998, 2, 4)),
    );

    final profile = map['profile']! as Map<String, Object?>;
    expect(profile['birthTime'], isNull);
    expect(profile['timeKnown'], isFalse);
  });

  test('reads back what it wrote', () {
    final original = UserProfile(
      displayName: 'Mochi',
      birthDate: DateTime(1998, 2, 4),
      birthMinutes: 0,
      focusAreas: const [FocusArea.healing],
    );

    expect(profileFromMap(profileToMap(original)), original);
  });

  test('missing or malformed fields read as empty', () {
    expect(profileFromMap({}), const UserProfile());
    expect(
      profileFromMap({
        'displayName': 7,
        'profile': {
          'birthDate': '1998-02-30',
          'birthTime': '25:00',
          'focusAreas': ['calm', 'nope', 3],
        },
      }),
      const UserProfile(focusAreas: [FocusArea.calm]),
    );
  });

  const bangkok = BirthPlace(
    name: 'Bangkok',
    region: 'Bangkok',
    countryCode: 'TH',
    lat: 13.754,
    lng: 100.5014,
    tzId: 'Asia/Bangkok',
  );

  test('writes the birthplace in the PRD 8.1 shape', () {
    final map = profileToMap(const UserProfile(birthPlace: bangkok));

    final profile = map['profile']! as Map<String, Object?>;
    expect(profile['place'], {
      'name': 'Bangkok',
      'region': 'Bangkok',
      'countryCode': 'TH',
      'lat': 13.754,
      'lng': 100.5014,
      'tzId': 'Asia/Bangkok',
    });
  });

  test('reads the birthplace back, including whole-number coordinates', () {
    expect(
      profileFromMap(profileToMap(const UserProfile(birthPlace: bangkok))),
      const UserProfile(birthPlace: bangkok),
    );
    final map = profileToMap(const UserProfile(birthPlace: bangkok));
    final place =
        (map['profile']! as Map<String, Object?>)['place']!
            as Map<String, Object?>;
    place['lat'] = 14;
    place['lng'] = 100;

    expect(profileFromMap(map).birthPlace?.lat, 14.0);
  });

  test('a birthplace missing its zone or coordinates is dropped', () {
    Map<String, Object?> withPlace(Map<String, Object?> place) => {
      'profile': {'place': place},
    };
    final full = {
      'name': 'Bangkok',
      'region': 'Bangkok',
      'countryCode': 'TH',
      'lat': 13.754,
      'lng': 100.5014,
      'tzId': 'Asia/Bangkok',
    };

    expect(profileFromMap(withPlace(full)).birthPlace, isNotNull);
    for (final key in ['name', 'countryCode', 'lat', 'lng', 'tzId']) {
      expect(
        profileFromMap(withPlace({...full}..remove(key))).birthPlace,
        isNull,
        reason: 'without $key',
      );
    }
    expect(
      profileFromMap(withPlace({...full}..remove('region'))).birthPlace?.region,
      '',
    );
  });

  test('formats and parses dates and times', () {
    expect(formatDate(DateTime(1999, 1, 2)), '1999-01-02');
    expect(parseDate('1999-01-02'), DateTime(1999, 1, 2));
    expect(parseDate('1999-1-2'), isNull);
    expect(formatMinutes(0), '00:00');
    expect(formatMinutes(23 * 60 + 59), '23:59');
    expect(parseMinutes('08:30'), 510);
    expect(parseMinutes('8:30'), isNull);
  });
}
