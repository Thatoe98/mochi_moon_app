import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/widgets/premium_preview.dart';

/// Guard for the safety flows: no soft lock, lock icon or Premium wording is
/// on screen. (A push to the paywall would also fail the tests that host the
/// screen without a `/paywall` route.)
void expectNoPaywall(WidgetTester tester) {
  expect(find.byType(PremiumPreview), findsNothing);
  expect(find.byIcon(Icons.lock_rounded), findsNothing);
  expect(find.byIcon(Icons.lock_outline_rounded), findsNothing);
  expect(find.textContaining('Premium'), findsNothing);
  expect(find.textContaining('free for 7 days'), findsNothing);
}
