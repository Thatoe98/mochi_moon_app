import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/presentation/mood_insights_card.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

import '../support/fake_mood.dart';

List<DayMood> _days(Mood mood, int count) => [
  for (var i = 0; i < count; i++)
    DayMood(
      day: DateTime(2026, 10).add(Duration(days: i)),
      mood: mood,
    ),
];

Future<void> _pump(
  WidgetTester tester, {
  required List<DayMood> moods,
  required bool premium,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        moodRepositoryProvider.overrideWithValue(FakeMoodRepository(moods)),
        ritualDaySetProvider.overrideWith((ref) => Stream.value(<DateTime>{})),
        hasPremiumProvider.overrideWithValue(premium),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: MoodInsightsCard()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('free users see the Premium invitation and no numbers', (
    tester,
  ) async {
    await _pump(tester, moods: _days(Mood.calm, 20), premium: false);

    expect(find.text('Mood insights are part of Premium'), findsOneWidget);
    expect(find.textContaining('of your 20 logged days'), findsNothing);
  });

  testWidgets('Premium with too few days says how many more are needed', (
    tester,
  ) async {
    await _pump(tester, moods: _days(Mood.calm, 10), premium: true);

    expect(
      find.text(
        'Log your mood on 4 more days and Mochi will share a few gentle '
        'patterns.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Premium with enough days shows a pattern and a kind step', (
    tester,
  ) async {
    await _pump(tester, moods: _days(Mood.calm, 14), premium: true);

    expect(
      find.text('Calm showed up on 14 of your 14 logged days.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('kind thing to do for yourself'),
      findsOneWidget,
    );
  });
}
