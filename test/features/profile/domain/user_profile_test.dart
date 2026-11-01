import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/profile/domain/birth_place.dart';
import 'package:mochi_moon/features/profile/domain/user_profile.dart';

void main() {
  final today = DateTime(2026, 10, 28, 15, 30);

  group('isValidBirthDate', () {
    test('accepts 1940 up to and including today', () {
      expect(isValidBirthDate(DateTime(1940), today), isTrue);
      expect(isValidBirthDate(DateTime(2026, 10, 28), today), isTrue);
      expect(isValidBirthDate(DateTime(1998, 2, 14), today), isTrue);
    });

    test('rejects dates before 1940 and in the future', () {
      expect(isValidBirthDate(DateTime(1939, 12, 31), today), isFalse);
      expect(isValidBirthDate(DateTime(2026, 10, 29), today), isFalse);
      expect(isValidBirthDate(DateTime(2027), today), isFalse);
    });
  });

  group('toggleFocusArea', () {
    test('adds in the order picked and removes again', () {
      var areas = <FocusArea>[];
      areas = toggleFocusArea(areas, FocusArea.calm);
      areas = toggleFocusArea(areas, FocusArea.healing);
      expect(areas, [FocusArea.calm, FocusArea.healing]);

      areas = toggleFocusArea(areas, FocusArea.calm);
      expect(areas, [FocusArea.healing]);
    });

    test('ignores a fourth pick', () {
      final three = [FocusArea.selfLove, FocusArea.calm, FocusArea.healing];
      expect(toggleFocusArea(three, FocusArea.confidence), three);
    });

    test('still lets a full list drop one', () {
      final three = [FocusArea.selfLove, FocusArea.calm, FocusArea.healing];
      expect(toggleFocusArea(three, FocusArea.calm), [
        FocusArea.selfLove,
        FocusArea.healing,
      ]);
    });
  });

  group('isValidFor', () {
    final valid = UserProfile(
      displayName: 'Mochi',
      birthDate: DateTime(1998, 11, 8),
    );

    test('needs a name', () {
      expect(valid.isValidFor(today), isTrue);
      expect(valid.copyWith(displayName: '  ').isValidFor(today), isFalse);
    });

    test('a name alone is enough; birth data is optional', () {
      expect(const UserProfile(displayName: 'Mochi').isValidFor(today), isTrue);
      expect(valid.copyWith(birthDate: null).isValidFor(today), isTrue);
    });

    test('a birth time or place without a birth date is not valid', () {
      expect(
        const UserProfile(
          displayName: 'Mochi',
          birthMinutes: 60,
        ).isValidFor(today),
        isFalse,
      );
    });

    test('keeps the name within the limit', () {
      final longest = 'a' * maxDisplayNameLength;
      expect(valid.copyWith(displayName: longest).isValidFor(today), isTrue);
      expect(
        valid.copyWith(displayName: '${longest}a').isValidFor(today),
        isFalse,
      );
    });

    test('rejects a birthday that is in the future or before 1940', () {
      expect(
        valid.copyWith(birthDate: DateTime(2026, 10, 29)).isValidFor(today),
        isFalse,
      );
      expect(
        valid.copyWith(birthDate: DateTime(1939)).isValidFor(today),
        isFalse,
      );
    });

    test('a birth time needs a birthplace', () {
      final withTime = valid.copyWith(birthMinutes: 8 * 60);
      expect(withTime.isValidFor(today), isFalse);
      expect(
        withTime
            .copyWith(
              birthPlace: const BirthPlace(
                name: 'Bangkok',
                region: 'Bangkok',
                countryCode: 'TH',
                lat: 13.75,
                lng: 100.5,
                tzId: 'Asia/Bangkok',
              ),
            )
            .isValidFor(today),
        isTrue,
      );
    });
  });

  group('UserProfile', () {
    test('the birth time is known only when minutes are set', () {
      expect(const UserProfile().timeKnown, isFalse);
      expect(const UserProfile(birthMinutes: 0).timeKnown, isTrue);
    });

    test('has an account profile with a name alone', () {
      expect(const UserProfile().hasAccountProfile, isFalse);
      expect(const UserProfile(displayName: '  ').hasAccountProfile, isFalse);
      expect(const UserProfile(displayName: 'Mochi').hasAccountProfile, isTrue);
    });

    test('has birth data only with a birth date', () {
      expect(const UserProfile(displayName: 'Mochi').hasBirthData, isFalse);
      expect(
        UserProfile(
          displayName: 'Mochi',
          birthDate: DateTime(1998),
        ).hasBirthData,
        isTrue,
      );
    });
  });

  test('focus area ids match the quote categories', () {
    expect(FocusArea.values.map((a) => a.id), [
      'self_love',
      'confidence',
      'healing',
      'study_work',
      'body_kindness',
      'calm',
    ]);
    expect(FocusArea.fromId('study_work'), FocusArea.studyWork);
    expect(FocusArea.fromId('nope'), isNull);
  });
}
