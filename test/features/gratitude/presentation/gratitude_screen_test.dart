import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/gratitude/application/gratitude_providers.dart';
import 'package:mochi_moon/features/gratitude/domain/gratitude.dart';
import 'package:mochi_moon/features/gratitude/presentation/gratitude_screen.dart';

import '../support/fake_gratitude.dart';

final _now = DateTime(2026, 10, 28, 12);

GratitudeNote _note(String id, int day, [String? body]) => GratitudeNote(
  id: id,
  day: DateTime(2026, 10, day),
  body: body ?? 'Thanks $id',
  createdAt: DateTime(2026, 10, day, 9),
);

Widget _app(FakeGratitudeRepository repo) => ProviderScope(
  overrides: [
    gratitudeRepositoryProvider.overrideWithValue(repo),
    gratitudeRemoteProvider.overrideWithValue(null),
    clockProvider.overrideWithValue(() => _now),
    randomProvider.overrideWithValue(Random(1)),
  ],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: GratitudeScreen(),
  ),
);

void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first
      ..physicalSize = const Size(1170, 4500)
      ..devicePixelRatio = 3;
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  testWidgets('an empty jar shows the mascot and an invitation', (
    tester,
  ) async {
    await tester.pumpWidget(_app(FakeGratitudeRepository()));
    await tester.pump();

    expect(find.text('Your jar is empty'), findsOneWidget);
    expect(find.text('Open the jar'), findsNothing);
    expect(find.bySemanticsLabel('An empty jar'), findsOneWidget);
  });

  testWidgets('adding an entry drops a star in the jar', (tester) async {
    final repo = FakeGratitudeRepository();
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'Warm tea');
    await tester.pump();
    await tester.ensureVisible(find.text('Drop a star in the jar'));
    await tester.tap(find.text('Drop a star in the jar'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(repo.all.single.body, 'Warm tea');
    expect(find.text('1 star in your jar'), findsOneWidget);
    expect(find.text('Warm tea'), findsOneWidget);
  });

  testWidgets('the box stops at 200 characters', (tester) async {
    await tester.pumpWidget(_app(FakeGratitudeRepository()));
    await tester.pump();

    await tester.enterText(find.byType(TextField), 'a' * 250);
    await tester.pump();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text.length, 200);
  });

  testWidgets('after three entries the box gives way to a kind note', (
    tester,
  ) async {
    final repo = FakeGratitudeRepository([
      _note('a', 28),
      _note('b', 28),
      _note('c', 28),
    ]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    expect(find.byType(TextField), findsNothing);
    expect(find.textContaining('three for today'), findsOneWidget);
  });

  testWidgets('opening the jar never shows an entry from today', (
    tester,
  ) async {
    final repo = FakeGratitudeRepository([
      _note('today', 28, 'Written today'),
      _note('old', 20, 'From last week'),
    ]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.ensureVisible(find.text('Open the jar'));
    await tester.tap(find.text('Open the jar'));
    await tester.pump();

    // Today's line is also in the list below, so look inside the open card.
    final card = find.ancestor(
      of: find.text('Close the jar'),
      matching: find.byType(DecoratedBox),
    );
    expect(
      find.descendant(of: card.first, matching: find.text('From last week')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: card.first, matching: find.text('Written today')),
      findsNothing,
    );
    expect(find.text('Another one'), findsNothing);
  });

  testWidgets('with only today entries the open jar says to come back', (
    tester,
  ) async {
    final repo = FakeGratitudeRepository([_note('today', 28)]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.ensureVisible(find.text('Open the jar'));
    await tester.tap(find.text('Open the jar'));
    await tester.pump();

    expect(find.textContaining('Come back tomorrow'), findsOneWidget);
  });

  testWidgets('another one cycles through earlier entries', (tester) async {
    final repo = FakeGratitudeRepository([
      _note('a', 20, 'First'),
      _note('b', 21, 'Second'),
    ]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.ensureVisible(find.text('Open the jar'));
    await tester.tap(find.text('Open the jar'));
    await tester.pump();
    expect(find.text('Another one'), findsOneWidget);
    await tester.tap(find.text('Another one'));
    await tester.pump();
    expect(find.text('Close the jar'), findsOneWidget);
  });

  testWidgets('deleting an entry asks first, then removes it', (tester) async {
    final repo = FakeGratitudeRepository([_note('a', 20, 'Old line')]);
    await tester.pumpWidget(_app(repo));
    await tester.pump();

    await tester.ensureVisible(find.byTooltip('Delete this star'));
    await tester.tap(find.byTooltip('Delete this star'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Keep it'));
    await tester.pumpAndSettle();
    expect(repo.all, hasLength(1));

    await tester.ensureVisible(find.byTooltip('Delete this star'));
    await tester.tap(find.byTooltip('Delete this star'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(repo.all, isEmpty);
  });
}
