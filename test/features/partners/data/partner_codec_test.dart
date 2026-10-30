import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/partners/data/partner_codec.dart';

import '../support/fake_partners.dart';

void main() {
  test('round-trips a partner with time and place', () {
    final original = partner(
      'p1',
      birthMinutes: 14 * 60 + 30,
      birthPlace: bangkok,
    );
    final map = partnerToMap(original);

    expect(map['birthDate'], '1998-05-14');
    expect(map['birthTime'], '14:30');
    expect(map['timeKnown'], isTrue);
    expect(partnerFromMap('p1', map), original);
  });

  test('round-trips a partner without time or place', () {
    final original = partner('p2');
    final map = partnerToMap(original);

    expect(map['birthTime'], isNull);
    expect(map['timeKnown'], isFalse);
    expect(map['place'], isNull);
    expect(partnerFromMap('p2', map), original);
  });

  test('has only the fields the Firestore rules allow', () {
    expect(
      partnerToMap(partner('p1')).keys,
      unorderedEquals([
        'nickname',
        'birthDate',
        'birthTime',
        'timeKnown',
        'place',
        'createdAt',
      ]),
    );
  });

  test('rejects a document without a usable nickname, date or creation', () {
    final good = partnerToMap(partner('p1'));
    expect(partnerFromMap('p1', {...good, 'nickname': '  '}), isNull);
    expect(partnerFromMap('p1', {...good, 'nickname': 3}), isNull);
    expect(partnerFromMap('p1', {...good, 'birthDate': '1998-02-30'}), isNull);
    expect(partnerFromMap('p1', {...good, 'birthDate': null}), isNull);
    expect(partnerFromMap('p1', {...good, 'createdAt': 'soon'}), isNull);
  });

  test('drops a malformed time or place but keeps the partner', () {
    final good = partnerToMap(
      partner('p1', birthMinutes: 600, birthPlace: bangkok),
    );
    final read = partnerFromMap('p1', {
      ...good,
      'birthTime': '25:99',
      'place': {'name': 'Nowhere'},
    });
    expect(read, isNotNull);
    expect(read!.birthMinutes, isNull);
    expect(read.birthPlace, isNull);
  });
}
