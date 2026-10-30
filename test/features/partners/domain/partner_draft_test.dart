import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/partners/domain/partner_draft.dart';

import '../support/fake_partners.dart';

final _today = DateTime(2026, 10, 30);

PartnerDraft _valid() =>
    PartnerDraft(nickname: 'Luna', birthDate: DateTime(1998, 5, 14));

void main() {
  test('an empty draft is not valid', () {
    expect(const PartnerDraft().isValid(_today), isFalse);
  });

  test('a nickname and a birth date are enough', () {
    expect(_valid().isValid(_today), isTrue);
  });

  test('a blank nickname is not valid', () {
    expect(_valid().copyWith(nickname: '   ').isValid(_today), isFalse);
  });

  test('a nickname of 30 characters is valid, 31 is not', () {
    expect(_valid().copyWith(nickname: 'x' * 30).isValid(_today), isTrue);
    expect(_valid().copyWith(nickname: 'x' * 31).isValid(_today), isFalse);
  });

  test('the nickname is trimmed before it is counted and saved', () {
    final draft = _valid().copyWith(nickname: '  ${'x' * 30}  ');
    expect(draft.isValid(_today), isTrue);
    expect(draft.trimmedNickname, 'x' * 30);
  });

  test('a birth date in the future or before 1940 is not valid', () {
    expect(
      _valid().copyWith(birthDate: DateTime(2026, 10, 31)).isValid(_today),
      isFalse,
    );
    expect(
      _valid().copyWith(birthDate: DateTime(1939, 12, 31)).isValid(_today),
      isFalse,
    );
  });

  test('a birth time needs a place', () {
    final timed = _valid().copyWith(birthMinutes: 14 * 60 + 30);
    expect(timed.missingPlace, isTrue);
    expect(timed.isValid(_today), isFalse);

    final placed = timed.copyWith(birthPlace: bangkok);
    expect(placed.missingPlace, isFalse);
    expect(placed.isValid(_today), isTrue);
  });

  test('a place without a time is fine', () {
    expect(_valid().copyWith(birthPlace: bangkok).isValid(_today), isTrue);
  });

  test('toPartner keeps only the date and trims the nickname', () {
    final partner = _valid()
        .copyWith(
          nickname: ' Luna ',
          birthDate: DateTime(1998, 5, 14, 17, 45),
          birthMinutes: 90,
          birthPlace: bangkok,
        )
        .toPartner(id: 'p1', createdAt: DateTime(2026, 10, 30, 9));

    expect(partner.id, 'p1');
    expect(partner.nickname, 'Luna');
    expect(partner.birthDate, DateTime(1998, 5, 14));
    expect(partner.birthMinutes, 90);
    expect(partner.birthPlace, bangkok);
    expect(partner.createdAt, DateTime(2026, 10, 30, 9));
  });

  test('PartnerDraft.of round-trips a partner', () {
    final original = partner('p1', birthMinutes: 600, birthPlace: bangkok);
    final back = PartnerDraft.of(original)
        .toPartner(id: original.id, createdAt: original.createdAt);
    expect(back, original);
  });
}
