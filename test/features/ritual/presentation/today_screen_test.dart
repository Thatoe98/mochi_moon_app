import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/day_colors.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/content/sign_info.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/widgets/sparkle.dart';
import 'package:mochi_moon/features/cosmic/astro/zodiac.dart';
import 'package:mochi_moon/features/cosmic/today/application/cosmic_today_providers.dart';
import 'package:mochi_moon/features/cosmic/today/domain/cosmic_today.dart';
import 'package:mochi_moon/features/cosmic/today/domain/daily_reading.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/application/share_providers.dart';
import 'package:mochi_moon/features/deck/domain/deck_action.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/ritual/application/ritual_providers.dart';
import 'package:mochi_moon/features/ritual/domain/ritual_state.dart';
import 'package:mochi_moon/features/ritual/presentation/today_screen.dart';

import '../../deck/support/fake_deck_repository.dart';
import '../../deck/support/fake_image_sharer.dart';
import '../../mood/support/fake_mood.dart';
import '../support/fake_ritual_progress.dart';

const _deckPage = 'deck page';
const _unlockPage = 'unlock page';

Future<CosmicToday?> _noBirthData() async => null;

Future<CosmicToday?> _withBirthData() async => CosmicToday(
  date: DateTime(2026, 10, 28),
  sign: ZodiacSign.libra,
  moonSign: ZodiacSign.cancer,
  reading: const DailyReading(
    headline: 'Soft balance',
    body: 'A gentle day.',
    energy: 'Slow down and be kind to yourself.',
    love: 'Love begins with you.',
    avoid: ['Rushing', 'Doubting', 'Comparing'],
    lang: 'en',
    isFallback: true,
  ),
  luckyColors: (
    sign: const NamedColor(name: 'Rose Quartz', hex: '#F7CAC9'),
    moon: const NamedColor(name: 'Sea Glass', hex: '#B2D8D8'),
  ),
  luckyNumber: 6,
  thaiColors: (
    today: const ThaiDayColor(weekday: 3, name: 'Green', hex: '#4CAF50'),
    birthday: null,
  ),
);
final _today = DateTime(2026, 10, 28, 12);
final _midnight = DateTime(2026, 10, 28);

/// Two words, so the lock is the 3 s minimum.
List<Quote> _quotes(int count) => [
  for (var i = 0; i < count; i++)
    Quote(id: 'q$i', text: {'en': 'Soft moon $i'}, category: 'self_love'),
];

const _lock = Duration(seconds: 3, milliseconds: 100);

Widget _app(
  FakeDeckRepository repo, {
  FakeMoodRepository? moods,
  FakeRitualProgressRepository? progress,
  int limit = 10,
  bool reduceMotion = false,
  double textScale = 1,
  Future<CosmicToday?> Function() cosmic = _noBirthData,
}) => ProviderScope(
  overrides: [
    cosmicTodayProvider('en').overrideWith((ref) => cosmic()),
    deckRepositoryProvider.overrideWithValue(repo),
    ritualProgressRepositoryProvider.overrideWithValue(
      progress ?? FakeRitualProgressRepository(),
    ),
    moodRepositoryProvider.overrideWithValue(moods ?? FakeMoodRepository()),
    moodRemoteProvider.overrideWithValue(null),
    imageSharerProvider.overrideWithValue(FakeImageSharer()),
    clockProvider.overrideWithValue(() => _today),
    randomProvider.overrideWithValue(Random(1)),
    dailyCardLimitProvider.overrideWithValue(limit),
    quotesProvider.overrideWith((ref) => Future.value(_quotes(5))),
  ],
  child: MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: reduceMotion,
        textScaler: TextScaler.linear(textScale),
      ),
      child: child!,
    ),
    routerConfig: GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const TodayScreen()),
        GoRoute(path: AppRoutes.deck, builder: (_, _) => const Text(_deckPage)),
        GoRoute(
          path: AppRoutes.cosmicUnlock,
          builder: (_, _) => const Text(_unlockPage),
        ),
      ],
    ),
  ),
);

DeckEvent _done(int id, DateTime at, {String? quoteId}) => DeckEvent(
  id: id,
  quoteId: quoteId ?? 'x$id',
  action: DeckAction.skipped,
  at: at,
);

/// Not pumpAndSettle: the ring is an animation and would run out the timer.
Future<void> _load(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

Future<void> _start(WidgetTester tester) async {
  await tester.tap(find.text('Begin my ritual'));
  await tester.pumpAndSettle();
}

/// Waits out the timer, then swipes the top card to the left (skip).
Future<void> _readAndSkip(WidgetTester tester) async {
  await tester.pump(_lock);
  await tester.drag(find.byType(QuoteCard).last, const Offset(-400, 0));
  await tester.pumpAndSettle();
}

void main() {
  setUp(() {
    // A drag that misses the front card would make the gate tests vacuous.
    WidgetController.hitTestWarningShouldBeFatal = true;
    TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first
      ..physicalSize = const Size(1170, 2532)
      ..devicePixelRatio = 3;
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  group('before the ritual', () {
    testWidgets('invites her to start a streak when she has none', (
      tester,
    ) async {
      await tester.pumpWidget(_app(FakeDeckRepository()));
      await tester.pumpAndSettle();

      expect(find.text('Start your self-love streak today'), findsOneWidget);
      expect(find.text('Begin my ritual'), findsOneWidget);
    });

    testWidgets('shows the streak once she has one', (tester) async {
      final repo = FakeDeckRepository([
        _done(1, DateTime(2026, 10, 27, 9)),
        _done(2, DateTime(2026, 10, 28, 9)),
      ]);
      await tester.pumpWidget(_app(repo));
      await tester.pumpAndSettle();

      expect(find.text('2 days of self-love'), findsOneWidget);
    });

    testWidgets('browse the deck opens the deck', (tester) async {
      await tester.pumpWidget(_app(FakeDeckRepository()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Browse the deck'));
      await tester.pumpAndSettle();

      expect(find.text(_deckPage), findsOneWidget);
    });

    testWidgets('survives 1.3x text without overflow', (tester) async {
      await tester.pumpWidget(_app(FakeDeckRepository(), textScale: 1.3));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await _start(tester);
      expect(find.text('Step 1 of 4'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('the ritual', () {
    testWidgets('runs end to end and counts the day', (tester) async {
      final repo = FakeDeckRepository();
      final moods = FakeMoodRepository();
      await tester.pumpWidget(_app(repo, moods: moods));
      await tester.pumpAndSettle();

      await _start(tester);
      expect(find.text('Step 1 of 4'), findsOneWidget);
      await tester.tap(find.text('Calm'));
      await tester.pumpAndSettle();
      expect(moods.moodOf(_today), Mood.calm);

      await tester.tap(find.text('Next'));
      await _load(tester);
      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(find.text('3 cards left in your ritual'), findsOneWidget);

      await _readAndSkip(tester);
      expect(find.text('2 cards left in your ritual'), findsOneWidget);
      await _readAndSkip(tester);
      await _readAndSkip(tester);
      expect(repo.events, hasLength(3));

      expect(find.text('Step 3 of 4'), findsOneWidget);
      await tester.tap(find.text('Finish my ritual'));
      await tester.pumpAndSettle();

      expect(find.text('Your ritual is done'), findsOneWidget);
      expect(await repo.ritualDays(), {_midnight});
      expect(find.text('1 day of self-love'), findsOneWidget);
    });

    testWidgets('the timer gate holds in the ritual', (tester) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(_app(repo));
      await tester.pumpAndSettle();
      await _start(tester);
      await tester.tap(find.text('Skip'));
      await _load(tester);

      final first = find.byType(QuoteCard).last;
      final before = tester.getTopLeft(first);
      await tester.pump(const Duration(seconds: 1));
      await tester.drag(first, const Offset(-400, 0));
      await tester.pump(const Duration(milliseconds: 500));

      expect(repo.events, isEmpty);
      expect(tester.getTopLeft(first), before, reason: 'card springs back');

      await tester.pump(_lock);
      await tester.drag(first, const Offset(-400, 0));
      await tester.pumpAndSettle();
      expect(repo.events, hasLength(1));
    });

    testWidgets('skipping the mood stores nothing', (tester) async {
      final moods = FakeMoodRepository();
      await tester.pumpWidget(_app(FakeDeckRepository(), moods: moods));
      await tester.pumpAndSettle();
      await _start(tester);

      await tester.tap(find.text('Skip'));
      await _load(tester);

      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(await moods.entries(), isEmpty);
    });

    testWidgets('uses the cards the free limit leaves', (tester) async {
      // Seven of eight cards are used up, so one is left.
      final repo = FakeDeckRepository([
        for (var i = 1; i <= 7; i++) _done(i, DateTime(2026, 10, 28, 8)),
      ]);
      await tester.pumpWidget(_app(repo, limit: 8));
      await tester.pumpAndSettle();
      await _start(tester);
      await tester.tap(find.text('Skip'));
      await _load(tester);

      expect(find.text('1 card left in your ritual'), findsOneWidget);
      await _readAndSkip(tester);

      expect(repo.events, hasLength(8));
      expect(find.text('Step 3 of 4'), findsOneWidget);
    });

    testWidgets('with no cards left it skips to the gratitude step', (
      tester,
    ) async {
      final repo = FakeDeckRepository();
      await tester.pumpWidget(_app(repo, limit: 0));
      await tester.pumpAndSettle();
      await _start(tester);
      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      expect(find.text('Step 3 of 4'), findsOneWidget);
      await tester.tap(find.text('Finish my ritual'));
      await tester.pumpAndSettle();

      // A ritual-only day still counts for the streak.
      expect(repo.events, isEmpty);
      expect(find.text('1 day of self-love'), findsOneWidget);
    });

    testWidgets('comes back to the same step the same day', (tester) async {
      final repo = FakeDeckRepository([
        _done(1, DateTime(2026, 10, 28, 8), quoteId: 'q0'),
      ]);
      final progress = FakeRitualProgressRepository()
        ..saved['2026-10-28'] = SavedRitual(
          day: _midnight,
          phase: RitualPhase.cards,
          quoteIds: const ['q0', 'q1', 'q2'],
        );
      await tester.pumpWidget(_app(repo, progress: progress));
      await _load(tester);
      await tester.pump();

      expect(find.text('Step 2 of 4'), findsOneWidget);
      expect(find.text('2 cards left in your ritual'), findsOneWidget);
    });

    testWidgets('a finished ritual shows the celebration on return', (
      tester,
    ) async {
      final repo = FakeDeckRepository();
      await repo.markRitualDay(_today);
      await tester.pumpWidget(_app(repo));
      await tester.pumpAndSettle();

      expect(find.text('Your ritual is done'), findsOneWidget);
      expect(find.text('Begin my ritual'), findsNothing);
    });

    testWidgets('reduce motion keeps a still celebration', (tester) async {
      final repo = FakeDeckRepository();
      await repo.markRitualDay(_today);
      await tester.pumpWidget(_app(repo, reduceMotion: true));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.auto_awesome_rounded), findsWidgets);
      expect(
        find.descendant(
          of: find.byType(Sparkle),
          matching: find.byType(AnimatedBuilder),
        ),
        findsNothing,
      );
    });
  });

  group('the cosmic reward card', () {
    Future<void> finished(
      WidgetTester tester, {
      Future<CosmicToday?> Function() cosmic = _noBirthData,
    }) async {
      final repo = FakeDeckRepository();
      await repo.markRitualDay(_today);
      await tester.pumpWidget(_app(repo, cosmic: cosmic));
      await tester.pumpAndSettle();
    }

    testWidgets('shows the energy line and lucky color with birth data', (
      tester,
    ) async {
      await finished(tester, cosmic: _withBirthData);

      expect(find.text("Today's energy"), findsOneWidget);
      expect(find.text('Slow down and be kind to yourself.'), findsOneWidget);
      expect(find.bySemanticsLabel('Rose Quartz'), findsOneWidget);
      expect(
        find.text('For entertainment and self-reflection'),
        findsOneWidget,
      );
      expect(find.text('Unlock'), findsNothing);
    });

    testWidgets('invites her to unlock the cosmic side without birth data', (
      tester,
    ) async {
      await finished(tester);

      expect(find.text('Your ritual is done'), findsOneWidget);
      expect(find.text('Unlock your cosmic side'), findsOneWidget);

      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();
      expect(find.text(_unlockPage), findsOneWidget);
    });

    testWidgets('a failing reward never blocks the celebration', (
      tester,
    ) async {
      await finished(tester, cosmic: () async => throw StateError('offline'));

      expect(find.text('Your ritual is done'), findsOneWidget);
      expect(find.text('Unlock your cosmic side'), findsNothing);
      expect(find.text("Today's energy"), findsNothing);
    });
  });
}
