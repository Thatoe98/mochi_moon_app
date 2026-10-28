import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/profile/data/profile_codec.dart';
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
