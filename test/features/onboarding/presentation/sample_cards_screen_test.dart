import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/onboarding/presentation/sample_cards_screen.dart';

import '../../deck/support/fake_deck_repository.dart';
import '../support/fake_onboarding_repository.dart';

/// Two words each, so the lock is the 3 s minimum. One card per category, as
/// the sample picker wants.
List<Quote> quotes() => const [
  Quote(id: 'q0', text: {'en': 'Soft moon'}, category: 'calm'),
  Quote(id: 'q1', text: {'en': 'Warm light'}, category: 'healing'),
  Quote(id: 'q2', text: {'en': 'Gentle heart'}, category: 'confidence'),
];

const lock = Duration(seconds: 3, milliseconds: 100);

Widget app({
  required FakeDeckRepository repo,
  Future<List<Quote>> Function()? loadQuotes,
  double textScale = 1,
}) => ProviderScope(
  overrides: [
    initialOnboardingCompleteProvider.overrideWithValue(false),
    onboardingRepositoryProvider.overrideWithValue(FakeOnboardingRepository()),
    deckRepositoryProvider.overrideWithValue(repo),
    clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 12)),
    quotesProvider.overrideWith(
      (ref) => loadQuotes?.call() ?? Future.value(quotes()),
    ),
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: const SampleCardsScreen(),
  ),
);

/// Not pumpAndSettle: the ring is an animation and would run out the timer.
Future<void> load(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

Future<void> swipeCardRight(WidgetTester tester) async {
  await tester.drag(find.byType(QuoteCard).last, const Offset(400, 0));
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  setUp(() {
    // A drag that misses the front card would make the gate tests vacuous.
    WidgetController.hitTestWarningShouldBeFatal = true;
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

  testWidgets('shows the first card with its progress', (tester) async {
    await tester.pumpWidget(app(repo: FakeDeckRepository()));
    await load(tester);

    expect(find.text('Card 1 of 3'), findsOneWidget);
    expect(find.text('Soft moon'), findsOneWidget);
  });

  testWidgets('a swipe before the timer ends is cancelled', (tester) async {
    final repo = FakeDeckRepository();
    await tester.pumpWidget(app(repo: repo));
    await load(tester);
    final first = find.byType(QuoteCard).last;
    final before = tester.getTopLeft(first);

    await tester.pump(const Duration(seconds: 1));
    await swipeCardRight(tester);

    expect(repo.events, isEmpty);
    expect(tester.getTopLeft(first), before, reason: 'card springs back');
    expect(find.text('Card 1 of 3'), findsOneWidget);
  });

  testWidgets('a swipe after the timer ends is allowed', (tester) async {
    final repo = FakeDeckRepository();
    await tester.pumpWidget(app(repo: repo));
    await load(tester);

    await tester.pump(lock);
    await swipeCardRight(tester);
    await tester.pumpAndSettle();

    expect(repo.events.map((e) => e.action), [DeckAction.saved]);
    expect(find.text('Card 2 of 3'), findsOneWidget);
  });

  testWidgets('sharing is not offered before sign-in', (tester) async {
    await tester.pumpWidget(app(repo: FakeDeckRepository()));
    await load(tester);

    expect(find.byIcon(Icons.ios_share_rounded), findsNothing);
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
  });

  testWidgets('the pitch follows the third card', (tester) async {
    final repo = FakeDeckRepository();
    await tester.pumpWidget(app(repo: repo));
    await load(tester);

    for (var i = 0; i < 3; i++) {
      await tester.pump(lock);
      await swipeCardRight(tester);
      await tester.pumpAndSettle();
    }

    expect(repo.events, hasLength(3));
    expect(find.text('Save your cards and get your cosmic reading'), findsOne);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.byType(QuoteCard), findsNothing);
  });

  testWidgets('cards from an earlier run are not dealt again', (tester) async {
    final repo = FakeDeckRepository([
      for (final id in ['q0', 'q1', 'q2'])
        DeckEvent(
          id: 1,
          quoteId: id,
          action: DeckAction.saved,
          at: DateTime(2026, 10, 28, 9),
        ),
    ]);
    await tester.pumpWidget(app(repo: repo));
    await load(tester);

    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('goes straight to the pitch when there is no content', (
    tester,
  ) async {
    await tester.pumpWidget(
      app(repo: FakeDeckRepository(), loadQuotes: () async => <Quote>[]),
    );
    await load(tester);

    expect(find.text('Continue'), findsOneWidget);
  });

  testWidgets('shows a loading state while quotes load', (tester) async {
    await tester.pumpWidget(
      app(
        repo: FakeDeckRepository(),
        loadQuotes: () => Future.delayed(const Duration(seconds: 1), quotes),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
  });

  testWidgets('shows an error state, and retry loads the cards', (
    tester,
  ) async {
    var failing = true;
    await tester.pumpWidget(
      app(
        repo: FakeDeckRepository(),
        loadQuotes: () =>
            failing ? Future.error(Exception('boom')) : Future.value(quotes()),
      ),
    );
    // No ring is running in the error state, and Riverpod retries first.
    await tester.pumpAndSettle();
    expect(find.text('Something wobbled'), findsOneWidget);

    failing = false;
    await tester.tap(find.text('Try again'));
    await load(tester);

    expect(find.text('Card 1 of 3'), findsOneWidget);
  });

  testWidgets('fits at 1.3x text scale', (tester) async {
    await tester.pumpWidget(app(repo: FakeDeckRepository(), textScale: 1.3));
    await load(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Card 1 of 3'), findsOneWidget);
  });
}
