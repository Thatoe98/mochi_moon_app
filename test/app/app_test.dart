import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/app/app.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';
import 'package:mochi_moon/features/journal/application/journal_providers.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city_index.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_providers.dart';

import '../features/auth/support/fake_auth_repository.dart';
import '../features/deck/support/fake_deck_repository.dart';
import '../features/journal/support/fake_journal_repository.dart';
import '../features/onboarding/support/fake_onboarding_repository.dart';
import '../features/profile/support/fake_profile.dart';
import '../features/settings/support/fake_reminder.dart';
import '../features/widget_bridge/support/fake_widget_publisher.dart';

const _quote = Quote(
  id: 'q_test',
  text: {'en': 'I am enough.'},
  category: 'self_love',
);

Widget _app({
  Future<List<Quote>> Function()? quotes,
  bool onboarded = true,
  FakeProfileRepository? profiles,
}) => ProviderScope(
  overrides: [
    initialOnboardingCompleteProvider.overrideWithValue(onboarded),
    onboardingRepositoryProvider.overrideWithValue(
      FakeOnboardingRepository(complete: onboarded),
    ),
    authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    profileRepositoryProvider.overrideWithValue(
      profiles ?? FakeProfileRepository(),
    ),
    profileRemoteProvider.overrideWithValue(null),
    deckRepositoryProvider.overrideWithValue(FakeDeckRepository()),
    journalRepositoryProvider.overrideWithValue(FakeJournalRepository()),
    reminderSettingsRepositoryProvider.overrideWithValue(
      FakeReminderSettingsRepository(),
    ),
    reminderSchedulerProvider.overrideWithValue(FakeReminderScheduler()),
    widgetPublisherProvider.overrideWithValue(FakeWidgetPublisher()),
    cityIndexProvider.overrideWith((ref) async => CityIndex(const [])),
    quotesProvider.overrideWith(
      (ref) => quotes?.call() ?? Future.value([_quote]),
    ),
  ],
  child: const MochiMoonApp(),
);

void main() {
  testWidgets('opens on the deck tab and shows a quote', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('I am enough.'), findsOneWidget);
    expect(find.text('Deck'), findsOneWidget);
  });

  testWidgets('shows a loading state while quotes load', (tester) async {
    await tester.pumpWidget(
      _app(
        quotes: () =>
            Future.delayed(const Duration(seconds: 1), () => [_quote]),
      ),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('shows an error state with retry', (tester) async {
    await tester.pumpWidget(
      _app(quotes: () => Future.error(Exception('boom'))),
    );
    await tester.pumpAndSettle();

    expect(find.text('Something wobbled'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no quotes', (tester) async {
    await tester.pumpWidget(_app(quotes: () => Future.value(<Quote>[])));
    await tester.pumpAndSettle();

    expect(find.text('Nothing here yet'), findsOneWidget);
  });

  testWidgets('bottom tabs navigate between Deck, Cosmic and Me', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cosmic'));
    await tester.pumpAndSettle();
    expect(find.text('Your stars are warming up.'), findsOneWidget);

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    expect(find.text('Your journal'), findsOneWidget);
  });

  testWidgets('Me opens the journal', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Your journal'));
    await tester.pumpAndSettle();

    expect(find.text('Nothing saved yet'), findsOneWidget);
  });

  group('first run', () {
    final cards = [
      const Quote(id: 'q_a', text: {'en': 'Soft moon'}, category: 'calm'),
      const Quote(id: 'q_b', text: {'en': 'Warm light'}, category: 'healing'),
      const Quote(id: 'q_c', text: {'en': 'Gentle heart'}, category: 'trust'),
    ];

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

    testWidgets('a new user starts at the welcome screen', (tester) async {
      await tester.pumpWidget(_app(onboarded: false));
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Mochi Moon'), findsOneWidget);
      expect(find.text('Try 3 cards'), findsOneWidget);
      expect(find.text('Deck'), findsNothing, reason: 'no tab bar yet');
    });

    testWidgets('a returning user never sees the welcome screen', (
      tester,
    ) async {
      await tester.pumpWidget(_app());
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Mochi Moon'), findsNothing);
      expect(find.text('Deck'), findsOneWidget);
    });

    testWidgets('a deep link before the flow is done goes to the welcome', (
      tester,
    ) async {
      await tester.pumpWidget(_app(onboarded: false));
      await tester.pumpAndSettle();

      ProviderScope.containerOf(tester.element(find.byType(MochiMoonApp)))
          .read(routerProvider)
          .go(AppRoutes.journal);
      await tester.pumpAndSettle();

      expect(find.text('Welcome to Mochi Moon'), findsOneWidget);
      expect(find.text('Nothing saved yet'), findsNothing);
    });

    testWidgets('welcome, three cards, sign-in, profile, then the deck', (
      tester,
    ) async {
      final profiles = FakeProfileRepository();
      await tester.pumpWidget(
        _app(onboarded: false, quotes: () async => cards, profiles: profiles),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Try 3 cards'));
      await tester.pump();
      await tester.pump();
      expect(find.text('Card 1 of 3'), findsOneWidget);

      for (var i = 0; i < 3; i++) {
        await tester.pump(const Duration(seconds: 3, milliseconds: 100));
        await tester.drag(find.byType(QuoteCard).last, const Offset(400, 0));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();
      }
      await tester.tap(find.text('Continue with Google'));
      await tester.pumpAndSettle();

      // Name: filled in from the Google account.
      expect(find.text('What should we call you?'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Birth date: Continue stays off until a day is picked.
      expect(find.text('When is your birthday?'), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.tap(find.text('1998'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('15'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Birth time is optional.
      expect(find.text('What time were you born?'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // So is the birthplace, when there is no birth time.
      expect(find.text('Where were you born?'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('A daily nudge?'), findsOneWidget);
      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();

      expect(find.text('What would you like more of?'), findsOneWidget);
      await tester.tap(find.text("Let's go"));
      await tester.pumpAndSettle();

      expect(find.text('Deck'), findsOneWidget);
      expect(find.text('Welcome to Mochi Moon'), findsNothing);
      expect(profiles.profile?.displayName, 'Mochi');
      expect(profiles.profile?.birthDate, DateTime(1998, 1, 15));
    });
  });
}
