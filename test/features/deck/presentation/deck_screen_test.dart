import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/application/share_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/presentation/deck_screen.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';

import '../../mood/support/fake_mood.dart';
import '../support/fake_deck_repository.dart';
import '../support/fake_image_sharer.dart';

/// Two words, so the lock is the 3 s minimum.
List<Quote> quotes(int count) => [
  for (var i = 0; i < count; i++)
    Quote(id: 'q$i', text: {'en': 'Soft moon $i'}, category: 'self_love'),
];

const lock = Duration(seconds: 3, milliseconds: 100);

Widget app({
  required FakeDeckRepository repo,
  FakeImageSharer? sharer,
  FakeMoodRepository? moods,
  Future<List<Quote>> Function()? loadQuotes,
  int limit = 10,
  bool reduceMotion = false,
  double textScale = 1,
}) => ProviderScope(
  overrides: [
    deckRepositoryProvider.overrideWithValue(repo),
    moodRepositoryProvider.overrideWithValue(moods ?? FakeMoodRepository()),
    moodRemoteProvider.overrideWithValue(null),
    imageSharerProvider.overrideWithValue(sharer ?? FakeImageSharer()),
    clockProvider.overrideWithValue(() => DateTime(2026, 10, 28, 12)),
    randomProvider.overrideWithValue(Random(1)),
    dailyCardLimitProvider.overrideWithValue(limit),
    quotesProvider.overrideWith(
      (ref) => loadQuotes?.call() ?? Future.value(quotes(3)),
    ),
  ],
  child: MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: reduceMotion,
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
    home: const DeckScreen(),
  ),
);

/// Not pumpAndSettle: the ring is an animation and would run out the timer.
Future<void> load(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

VoidCallback? onPressedOf(WidgetTester tester, IconData icon) =>
    tester.widget<IconButton>(find.widgetWithIcon(IconButton, icon)).onPressed;

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

  group('mood check-in', () {
    testWidgets('choosing a mood stores it for today', (tester) async {
      final moods = FakeMoodRepository();
      await tester.pumpWidget(app(repo: FakeDeckRepository(), moods: moods));
      await load(tester);

      await tester.tap(find.text('Calm'));
      await tester.pump();

      expect(moods.moodOf(DateTime(2026, 10, 28)), Mood.calm);
    });

    testWidgets('a mood chosen earlier today is already selected', (
      tester,
    ) async {
      final moods = FakeMoodRepository([
        DayMood(day: DateTime(2026, 10, 28), mood: Mood.sad),
      ]);
      await tester.pumpWidget(app(repo: FakeDeckRepository(), moods: moods));
      await load(tester);

      final chip = tester.widget<ChoiceChip>(
        find.widgetWithText(ChoiceChip, 'Sad'),
      );
      expect(chip.selected, isTrue);
    });

    testWidgets('a mood that fits a card puts it on top', (tester) async {
      await tester.pumpWidget(
        app(
          repo: FakeDeckRepository(),
          loadQuotes: () async => [
            const Quote(id: 'a', text: {'en': 'Soft moon a'}, category: 'calm'),
            const Quote(id: 'b', text: {'en': 'Soft moon b'}, category: 'calm'),
            const Quote(
              id: 'c',
              text: {'en': 'Gentle light c'},
              category: 'calm',
              moods: ['sad'],
            ),
          ],
        ),
      );
      await load(tester);

      await tester.ensureVisible(find.text('Sad'));
      await tester.pump();
      await tester.tap(find.text('Sad'));
      await tester.pump();
      await tester.pump();

      final top = tester.widgetList<QuoteCard>(find.byType(QuoteCard)).last;
      expect(top.text, 'Gentle light c');
    });
  });

  group('timer gate', () {
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
      expect(find.text('Read it out loud ✨'), findsOneWidget);
      expect(find.text('3 cards left today'), findsOneWidget);
    });

    testWidgets('all swipe directions work once the timer ends', (
      tester,
    ) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo));
      await load(tester);

      await tester.pump(lock);
      expect(find.text('Ready to swipe'), findsOneWidget);
      await swipeCardRight(tester);
      await tester.pumpAndSettle();
      expect(repo.events.map((e) => e.action), [DeckAction.saved]);
      expect(find.text('2 cards left today'), findsOneWidget);

      // Next card: locked again, then left.
      await tester.pump(lock);
      await tester.drag(find.byType(QuoteCard).last, const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(repo.events.last.action, DeckAction.skipped);

      // And up.
      await tester.pump(lock);
      await tester.drag(find.byType(QuoteCard).last, const Offset(0, -500));
      await tester.pumpAndSettle();
      expect(repo.events.last.action, DeckAction.shared);
    });

    testWidgets('the next card is locked again', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo));
      await load(tester);

      await tester.pump(lock);
      await swipeCardRight(tester);
      await tester.pumpAndSettle();
      expect(repo.events, hasLength(1));

      await swipeCardRight(tester);
      expect(repo.events, hasLength(1));
    });

    testWidgets('buttons are disabled until the timer ends', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo));
      await load(tester);

      await tester.pump(const Duration(seconds: 1));
      for (final icon in [
        Icons.close_rounded,
        Icons.ios_share_rounded,
        Icons.favorite_rounded,
      ]) {
        expect(onPressedOf(tester, icon), isNull);
      }

      await tester.pump(lock);
      for (final icon in [
        Icons.close_rounded,
        Icons.ios_share_rounded,
        Icons.favorite_rounded,
      ]) {
        expect(onPressedOf(tester, icon), isNotNull);
      }
    });

    testWidgets('a new deal locks the front card again', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo));
      await load(tester);
      await tester.pump(lock);
      expect(find.text('Ready to swipe'), findsOneWidget);

      // The card of the day is dealt first on every deal, so the same card
      // faces the reader; only the cleared read state can lock it.
      ProviderScope.containerOf(tester.element(find.byType(DeckScreen)))
          .invalidate(deckProvider);
      await load(tester);

      expect(find.text('Ready to swipe'), findsNothing);
      expect(find.text('Read it out loud ✨'), findsOneWidget);
      expect(onPressedOf(tester, Icons.favorite_rounded), isNull);
    });
  });

  group('sharing', () {
    /// Rendering needs a real event loop and a pumped frame.
    Future<void> waitForShare(WidgetTester tester, FakeImageSharer sharer) =>
        tester.runAsync(() async {
          for (var i = 0; i < 50 && sharer.shared.isEmpty; i++) {
            await Future<void>.delayed(const Duration(milliseconds: 20));
            await tester.pump();
          }
        });

    testWidgets('swiping up shares the card as an image', (tester) async {
      final repo = FakeDeckRepository();
      final sharer = FakeImageSharer();
      await tester.pumpWidget(app(repo: repo, sharer: sharer));
      await load(tester);
      await tester.pump(lock);

      await tester.drag(find.byType(QuoteCard).last, const Offset(0, -500));
      await tester.pumpAndSettle();
      await waitForShare(tester, sharer);

      expect(repo.events.single.action, DeckAction.shared);
      expect(sharer.shared, hasLength(1));
      expect(sharer.shared.single.png.take(4), [0x89, 0x50, 0x4E, 0x47]);
    });

    testWidgets('the share button shares too', (tester) async {
      final repo = FakeDeckRepository();
      final sharer = FakeImageSharer();
      await tester.pumpWidget(app(repo: repo, sharer: sharer));
      await load(tester);
      await tester.pump(lock);

      await tester.tap(find.byTooltip('Share'));
      await tester.pumpAndSettle();
      await waitForShare(tester, sharer);

      expect(sharer.shared, hasLength(1));
    });

    testWidgets('saving and skipping do not share', (tester) async {
      final repo = FakeDeckRepository();
      final sharer = FakeImageSharer();
      await tester.pumpWidget(app(repo: repo, sharer: sharer));
      await load(tester);
      await tester.pump(lock);

      await tester.tap(find.byTooltip('This is me'));
      await tester.pumpAndSettle();

      expect(sharer.shared, isEmpty);
    });

    testWidgets('a failing share sheet still records the card', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(
        app(
          repo: repo,
          sharer: FakeImageSharer(error: Exception('nope')),
        ),
      );
      await load(tester);
      await tester.pump(lock);

      await tester.tap(find.byTooltip('Share'));
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        await tester.pump();
      });
      await tester.pump();

      expect(repo.events.single.action, DeckAction.shared);
      expect(
        find.textContaining("Couldn't open the share sheet"),
        findsOneWidget,
      );
    });
  });

  group('actions', () {
    testWidgets('the save button records a saved card', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo));
      await load(tester);
      await tester.pump(lock);

      await tester.tap(find.byTooltip('This is me'));
      await tester.pumpAndSettle();

      expect(repo.events.single.action, DeckAction.saved);
      expect(find.text('2 cards left today'), findsOneWidget);
    });

    testWidgets('undo takes the last card back and keeps it unlocked', (
      tester,
    ) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo));
      await load(tester);
      expect(onPressedOf(tester, Icons.undo_rounded), isNull);
      await tester.pump(lock);

      await tester.tap(find.byTooltip('Next card'));
      await tester.pumpAndSettle();
      expect(repo.events, hasLength(1));
      expect(onPressedOf(tester, Icons.undo_rounded), isNotNull);

      await tester.tap(find.byTooltip('Undo'));
      await tester.pumpAndSettle();

      expect(repo.events, isEmpty);
      expect(find.text('3 cards left today'), findsOneWidget);
      expect(find.text('Ready to swipe'), findsOneWidget);
      expect(onPressedOf(tester, Icons.undo_rounded), isNull);
    });

    testWidgets('the streak shows in the app bar once a card is done', (
      tester,
    ) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo));
      await load(tester);
      expect(find.bySemanticsLabel('1 day streak'), findsNothing);

      await tester.pump(lock);
      await tester.tap(find.byTooltip('Next card'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('1 day streak'), findsOneWidget);
    });
  });

  group('daily limit', () {
    testWidgets('shows the glowing card after the last free card', (
      tester,
    ) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo, limit: 1));
      await load(tester);
      await tester.pump(lock);

      await tester.tap(find.byTooltip('This is me'));
      await tester.pumpAndSettle();

      expect(find.text("You're glowing ✨"), findsOneWidget);
      expect(find.byType(QuoteCard), findsNothing);
      expect(
        tester.widget<Image>(find.byType(Image)).semanticLabel,
        contains('Mochi the moon bunny'),
      );
    });

    testWidgets('starts on the glowing card when today is already done', (
      tester,
    ) async {
      final repo = FakeDeckRepository([
        DeckEvent(
          id: 1,
          quoteId: 'q0',
          action: DeckAction.skipped,
          at: DateTime(2026, 10, 28, 8),
        ),
      ]);
      await tester.pumpWidget(app(repo: repo, limit: 1));
      await tester.pumpAndSettle();

      expect(find.text("You're glowing ✨"), findsOneWidget);
    });

    testWidgets('undo from the glowing card brings the last card back', (
      tester,
    ) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo, limit: 1));
      await load(tester);
      await tester.pump(lock);
      await tester.tap(find.byTooltip('This is me'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();

      expect(repo.events, isEmpty);
      expect(find.byType(QuoteCard), findsWidgets);
      expect(find.text('Ready to swipe'), findsOneWidget);
    });
  });

  group('accessibility', () {
    testWidgets('reduce motion drops the sparkle but keeps the timer', (
      tester,
    ) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo, reduceMotion: true));
      await load(tester);

      await tester.pump(const Duration(seconds: 1));
      expect(onPressedOf(tester, Icons.favorite_rounded), isNull);

      await tester.pump(lock);
      await tester.pump(const Duration(milliseconds: 100));
      expect(onPressedOf(tester, Icons.favorite_rounded), isNotNull);
      expect(find.byIcon(Icons.auto_awesome_rounded), findsNothing);
    });

    testWidgets('the sparkle plays when motion is allowed', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo));
      await load(tester);

      await tester.pump(lock);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byIcon(Icons.auto_awesome_rounded), findsWidgets);
      await tester.pumpAndSettle();
    });

    testWidgets('1.3x text scale does not overflow', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo, textScale: 1.3));
      await load(tester);
      await tester.pump(lock);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('the ring and image have semantic labels', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(app(repo: repo));
      await load(tester);

      expect(find.bySemanticsLabel('Read-aloud timer'), findsOneWidget);
      expect(
        find.bySemanticsLabel(
          'Mochi the moon bunny holding up a hand mirror that shows a glowing heart',
        ),
        findsWidgets,
      );
      await tester.pumpAndSettle();
    });
  });

  group('states', () {
    testWidgets('shows loading, then the first card', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(
        app(
          repo: repo,
          loadQuotes: () =>
              Future.delayed(const Duration(seconds: 1), () => quotes(3)),
        ),
      );
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      expect(find.byType(QuoteCard), findsWidgets);
      await tester.pumpAndSettle();
    });

    testWidgets('shows an error with retry', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(
        app(repo: repo, loadQuotes: () => Future.error(Exception('boom'))),
      );
      await tester.pumpAndSettle();

      expect(find.text('Something wobbled'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('shows an empty state with no quotes', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(
        app(repo: repo, loadQuotes: () => Future.value(<Quote>[])),
      );
      await tester.pumpAndSettle();

      expect(find.text('Nothing here yet'), findsOneWidget);
    });
  });
}
