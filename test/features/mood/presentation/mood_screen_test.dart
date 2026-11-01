import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/presentation/mood_screen.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

import '../support/fake_mood.dart';

Widget _app(FakeMoodRepository repo) => ProviderScope(
  overrides: [
    moodRepositoryProvider.overrideWithValue(repo),
    ritualDaySetProvider.overrideWith((ref) => Stream.value(<DateTime>{})),
    hasPremiumProvider.overrideWithValue(false),
    clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 12)),
  ],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: MoodScreen(),
  ),
);

void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  testWidgets('choosing a mood stores it for today', (tester) async {
    final repo = FakeMoodRepository();
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.tap(find.text('Calm'));
    await tester.pump();

    expect(repo.moodOf(DateTime(2026, 10, 28)), Mood.calm);
  });

  testWidgets('choosing again replaces the mood', (tester) async {
    final repo = FakeMoodRepository([
      DayMood(day: DateTime(2026, 10, 28), mood: Mood.sad),
    ]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.tap(find.text('Happy'));
    await tester.pump();

    expect(repo.moodOf(DateTime(2026, 10, 28)), Mood.happy);
  });

  testWidgets('tapping a day says what the mood was, or that none was set', (
    tester,
  ) async {
    final repo = FakeMoodRepository([
      DayMood(day: DateTime(2026, 10, 3), mood: Mood.tired),
    ]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.tap(find.text('3'));
    await tester.pump();
    expect(find.textContaining('Tired'), findsWidgets);
    expect(find.text('No mood saved for this day.'), findsNothing);

    await tester.tap(find.text('4'));
    await tester.pump();
    expect(find.text('No mood saved for this day.'), findsOneWidget);
  });
}
