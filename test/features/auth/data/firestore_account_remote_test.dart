import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/features/auth/data/firestore_account_remote.dart';

void main() {
  test('deletes every user subcollection named in firestore.rules', () {
    final rules = File('firestore.rules').readAsStringSync();
    final inRules =
        RegExp(r'match /(\w+)/')
            .allMatches(rules)
            .map((m) => m.group(1)!)
            .toSet()
          ..remove('users')
          ..remove('databases')
          // Only the server writes reports, so the server removes them.
          ..remove('reports');

    expect(inRules, isNotEmpty);
    expect(FirestoreAccountRemote.subcollections.toSet(), inRules);
  });
}
