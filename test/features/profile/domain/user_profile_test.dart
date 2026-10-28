import 'package:flutter_test/flutter_test.dart';
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

  group('UserProfile', () {
    test('the birth time is known only when minutes are set', () {
      expect(const UserProfile().timeKnown, isFalse);
      expect(const UserProfile(birthMinutes: 0).timeKnown, isTrue);
    });

    test('is complete with a name and a birth date', () {
      expect(const UserProfile().isComplete, isFalse);
      expect(const UserProfile(displayName: 'Mochi').isComplete, isFalse);
      expect(const UserProfile(displayName: '  ').isComplete, isFalse);
      expect(
        UserProfile(displayName: 'Mochi', birthDate: DateTime(1998)).isComplete,
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
