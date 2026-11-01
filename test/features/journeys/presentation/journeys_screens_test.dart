import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/journey.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/journeys/application/journey_providers.dart';
import 'package:mochi_moon/features/journeys/domain/journey_progress.dart';
import 'package:mochi_moon/features/journeys/presentation/journey_day_screen.dart';
import 'package:mochi_moon/features/journeys/presentation/journey_screen.dart';
import 'package:mochi_moon/features/journeys/presentation/journeys_screen.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

import '../../auth/support/fake_auth_repository.dart';
import '../../deck/support/fake_deck_repository.dart';
import '../support/fake_journey.dart';

final _now = DateTime(2026, 11, 2, 9);

Journey _journey(String id, {required bool premium}) => Journey(
  id: id,
  days: 2,
  title: {'en': 'Journey $id'},
  summary: {'en': 'About $id'},
  illustrationId: 'ill_$id',
  premium: premium,
  daysPlan: [
    for (var day = 1; day <= 2; day++)
      JourneyDayPlan(
        day: day,
        quoteIds: const ['q1'],
        questId: 'k1',
        reflection: {'en': 'What felt kind today?'},
      ),
  ],
);

Widget _app(
  FakeJourneyRepository repo, {
  FakeDeckRepository? deck,
  bool premium = true,
  String start = '/me/journeys',
}) => ProviderScope(
  overrides: [
    journeyRepositoryProvider.overrideWithValue(repo),
    journeyRemoteProvider.overrideWithValue(null),
    deckRepositoryProvider.overrideWithValue(deck ?? FakeDeckRepository()),
    authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    hasPremiumProvider.overrideWithValue(premium),
    clockProvider.overrideWithValue(() => _now),
    journeysProvider.overrideWith(
      (ref) async => [
        _journey('free', premium: false),
        _journey('paid', premium: true),
      ],
    ),
    quotesProvider.overrideWith(
      (ref) async => [
        const Quote(
          id: 'q1',
          text: {'en': 'I am enough'},
          category: 'self_love',
        ),
      ],
    ),
    questsProvider.overrideWith(
      (ref) async => [
        const Quest(id: 'k1', text: {'en': 'Drink some water'}),
      ],
    ),
  ],
  child: MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: GoRouter(
      initialLocation: start,
      routes: [
        GoRoute(
          path: '/me/journeys',
          builder: (context, state) => const JourneysScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  JourneyScreen(journeyId: state.pathParameters['id']!),
              routes: [
                GoRoute(
                  path: 'day',
                  builder: (context, state) =>
                      JourneyDayScreen(journeyId: state.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ),
);

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first
      ..physicalSize = const Size(1170, 2400)
      ..devicePixelRatio = 3;
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  testWidgets('the list shows each journey with its tag', (tester) async {
    await tester.pumpWidget(_app(FakeJourneyRepository()));
    await tester.pumpAndSettle();

    expect(find.text('Journey free'), findsOneWidget);
    expect(find.text('Journey paid'), findsOneWidget);
    expect(find.textContaining('Free'), findsOneWidget);
    expect(find.textContaining('Premium'), findsOneWidget);
  });

  testWidgets('a Premium journey is locked without Premium', (tester) async {
    final repo = FakeJourneyRepository();
    await tester.pumpWidget(
      _app(repo, premium: false, start: '/me/journeys/paid'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Start'), findsNothing);
    expect(find.text('Start this journey'), findsNothing);
    expect(find.text('See Premium'), findsOneWidget);
    expect(repo.saved('paid'), isNull);
  });

  testWidgets('starting the free journey opens day 1', (tester) async {
    final repo = FakeJourneyRepository();
    await tester.pumpWidget(_app(repo, start: '/me/journeys/free'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(repo.saved('free')?.currentDay, 1);
    expect(find.text('I am enough'), findsOneWidget);
  });

  testWidgets('a second journey waits while one is going', (tester) async {
    final repo = FakeJourneyRepository([
      startJourney(_journey('paid', premium: true), _now),
    ]);
    await tester.pumpWidget(_app(repo, start: '/me/journeys/free'));
    await tester.pumpAndSettle();

    expect(find.byType(FilledButton), findsNothing);
    expect(repo.saved('free'), isNull);
  });

  testWidgets('a day counts for the streak and keeps the reflection', (
    tester,
  ) async {
    final repo = FakeJourneyRepository([
      startJourney(_journey('free', premium: false), _now),
    ]);
    final deck = FakeDeckRepository();
    await tester.pumpWidget(
      _app(deck: deck, repo, start: '/me/journeys/free/day'),
    );
    await tester.pumpAndSettle();

    // The card is locked until its read-aloud timer finishes.
    await tester.pump(const Duration(seconds: 12));
    await tester.tap(find.byTooltip('This is me'));
    await tester.pumpAndSettle();
    expect(deck.events, hasLength(1));

    expect(find.text('Drink some water'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'I was kind to me');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    final run = repo.saved('free')!;
    expect(run.completedDays, [1]);
    expect(run.currentDay, 2);
    expect(run.reflections, {1: 'I was kind to me'});
  });
}
