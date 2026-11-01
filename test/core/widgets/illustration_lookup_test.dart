import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/widgets/mochi_illustration.dart';

void main() {
  test('every mascot item in the content has its art on disk', () {
    final items = jsonDecode(
      File('assets/content/mascot/mascot_items.json').readAsStringSync(),
    ) as dynamic;
    final list = (items is List ? items : (items as Map)['items']) as List;
    for (final item in list) {
      final art = AppIllustrations.forMascotItem(
        (item as Map)['illustrationId'] as String,
      );
      expect(art, isNotNull, reason: '${item['id']} has no art');
      expect(File(art!).existsSync(), isTrue, reason: art);
    }
  });

  test('every mood and known journey cover exists on disk', () {
    for (final id in ['happy', 'calm', 'tired', 'sad', 'anxious', 'in_love']) {
      expect(
        File(AppIllustrations.forMood(id)).existsSync(),
        isTrue,
        reason: id,
      );
    }
    expect(AppIllustrations.forJourney('ill_journey_confidence'), isNotNull);
    expect(AppIllustrations.forJourney('nope'), isNull);
  });
}
