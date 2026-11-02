import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/app/app.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/features/auth/application/auth_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/today/application/cosmic_today_providers.dart';
import 'package:mochi_moon/features/custom_cards/application/own_card_providers.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/deck/presentation/quote_card.dart';
import 'package:mochi_moon/features/explore/application/tips_providers.dart';
import 'package:mochi_moon/features/gratitude/application/gratitude_providers.dart';
import 'package:mochi_moon/features/journal/application/journal_providers.dart';
import 'package:mochi_moon/features/journeys/application/journey_providers.dart';
import 'package:mochi_moon/features/letters/application/letter_providers.dart';
import 'package:mochi_moon/features/mood/application/mood_providers.dart';
import 'package:mochi_moon/features/onboarding/application/onboarding_providers.dart';
import 'package:mochi_moon/features/partners/application/partner_providers.dart';
import 'package:mochi_moon/features/places/application/places_providers.dart';
import 'package:mochi_moon/features/places/domain/city_index.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/quests/application/quest_providers.dart';
import 'package:mochi_moon/features/ritual/application/ritual_providers.dart';
import 'package:mochi_moon/features/settings/application/announcements_providers.dart';
import 'package:mochi_moon/features/settings/application/language_providers.dart';
import 'package:mochi_moon/features/settings/application/reduce_motion_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';
import 'package:mochi_moon/features/widget_bridge/application/widget_providers.dart';

import '../features/auth/support/fake_auth_repository.dart';
import '../features/cosmic/retrograde/support/fake_alerts.dart';
import '../features/cosmic/retrograde/support/periods.dart';
import '../features/cosmic/today/support/fake_thai_colors_setting.dart';
import '../features/custom_cards/support/fake_own_cards.dart';
import '../features/deck/support/fake_deck_repository.dart';
import '../features/explore/support/fake_tips_repository.dart';
import '../features/gratitude/support/fake_gratitude.dart';
import '../features/journal/support/fake_journal_repository.dart';
import '../features/journeys/support/fake_journey.dart';
import '../features/letters/support/fake_letter.dart';
import '../features/mood/support/fake_mood.dart';
import '../features/onboarding/support/fake_onboarding_repository.dart';
import '../features/partners/support/fake_partners.dart';
import '../features/profile/support/fake_profile.dart';
import '../features/quests/support/fake_quest.dart';
import '../features/ritual/support/fake_ritual_progress.dart';
import '../features/settings/support/fake_analytics_consent.dart';
import '../features/settings/support/fake_announcements.dart';
import '../features/settings/support/fake_app_language.dart';
import '../features/settings/support/fake_reduce_motion.dart';
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
  FakeAppLanguageRepository? language,
  FakeProfileRepository? profiles,
  bool reduceMotion = false,
  bool? analyticsConsent = false,
}) => ProviderScope(
  overrides: [
    initialOnboardingCompleteProvider.overrideWithValue(onboarded),
    tipsRepositoryProvider.overrideWithValue(FakeTipsRepository()),
    onboardingRepositoryProvider.overrideWithValue(
      FakeOnboardingRepository(complete: onboarded),
    ),
    authRepositoryProvider.overrideWithValue(FakeAuthRepository()),
    profileRepositoryProvider.overrideWithValue(
      profiles ?? FakeProfileRepository(),
    ),
    profileRemoteProvider.overrideWithValue(null),
    deckRepositoryProvider.overrideWithValue(FakeDeckRepository()),
    ritualProgressRepositoryProvider.overrideWithValue(
      FakeRitualProgressRepository(),
    ),
    journalRepositoryProvider.overrideWithValue(FakeJournalRepository()),
    gratitudeRepositoryProvider.overrideWithValue(FakeGratitudeRepository()),
    gratitudeRemoteProvider.overrideWithValue(null),
    ownCardRepositoryProvider.overrideWithValue(FakeOwnCardRepository()),
    ownCardRemoteProvider.overrideWithValue(null),
    moodRepositoryProvider.overrideWithValue(FakeMoodRepository()),
    moodRemoteProvider.overrideWithValue(null),
    questRepositoryProvider.overrideWithValue(FakeQuestRepository()),
    questRemoteProvider.overrideWithValue(null),
    journeyRepositoryProvider.overrideWithValue(FakeJourneyRepository()),
    journeyRemoteProvider.overrideWithValue(null),
    letterRepositoryProvider.overrideWithValue(FakeLetterRepository()),
    letterRemoteProvider.overrideWithValue(null),
    letterSchedulerProvider.overrideWithValue(FakeLetterNotifier()),
    questsProvider.overrideWith((ref) async => const <Quest>[]),
    partnerRepositoryProvider.overrideWithValue(FakePartnerRepository()),
    partnerRemoteProvider.overrideWithValue(null),
    appLanguageRepositoryProvider.overrideWithValue(
      language ?? FakeAppLanguageRepository(),
    ),
    reduceMotionSettingRepositoryProvider.overrideWithValue(
      FakeReduceMotionSettingRepository(saved: reduceMotion),
    ),
    announcementsSettingRepositoryProvider.overrideWithValue(
      FakeAnnouncementsSettingRepository(),
    ),
    announcementsTopicProvider.overrideWithValue(FakeAnnouncementsTopic()),
    analyticsConsentRepositoryProvider.overrideWithValue(
      FakeAnalyticsConsentRepository(saved: analyticsConsent),
    ),
    reminderSettingsRepositoryProvider.overrideWithValue(
      FakeReminderSettingsRepository(),
    ),
    reminderSchedulerProvider.overrideWithValue(FakeReminderScheduler()),
    retrogradeAlertSettingsRepositoryProvider.overrideWithValue(
      FakeRetrogradeAlertSettingsRepository(),
    ),
    retrogradeAlertSchedulerProvider.overrideWithValue(
      FakeRetrogradeAlertScheduler(),
    ),
    retrogradeCalendarSourceProvider.overrideWithValue(fakeCalendar),
    widgetPublisherProvider.overrideWithValue(FakeWidgetPublisher()),
    thaiColorsSettingRepositoryProvider.overrideWithValue(
      FakeThaiColorsSettingRepository(),
    ),
    cityIndexProvider.overrideWith((ref) async => CityIndex(const [])),
    quotesProvider.overrideWith(
      (ref) => quotes?.call() ?? Future.value([_quote]),
    ),
  ],
  child: const MochiMoonApp(),
);

/// The app opens on Today; the deck is one tap away.
Future<void> _openDeck(WidgetTester tester) async {
  await tester.tap(find.text('Deck'));
  await tester.pumpAndSettle();
}

bool _motionReduced(WidgetTester tester) =>
    MediaQuery.disableAnimationsOf(tester.element(find.byType(Scaffold).first));

void main() {
  // The deck now carries a mood check-in, so the default 800x600 surface is
  // too short for the tab screens.
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
  });

  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  testWidgets('animations stay on unless reduce motion is switched on', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(_motionReduced(tester), isFalse);
  });

  testWidgets('the Reduce motion switch calms every screen', (tester) async {
    await tester.pumpWidget(_app(reduceMotion: true));
    await tester.pumpAndSettle();

    expect(_motionReduced(tester), isTrue);
  });

  testWidgets('asks about anonymous usage once the main screens show', (
    tester,
  ) async {
    await tester.pumpWidget(_app(analyticsConsent: null));
    await tester.pumpAndSettle();

    expect(find.text('Help Mochi Moon grow?'), findsOneWidget);

    await tester.tap(find.text('No thanks'));
    await tester.pumpAndSettle();

    expect(find.text('Help Mochi Moon grow?'), findsNothing);
    await _openDeck(tester);
    expect(find.text('I am enough.'), findsOneWidget);
  });

  testWidgets('does not ask again after an answer', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Help Mochi Moon grow?'), findsNothing);
  });

  testWidgets('opens on Today, with the deck one tab away', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(find.text('Start your self-love streak today'), findsOneWidget);
    expect(find.text('I am enough.'), findsNothing);

    await _openDeck(tester);
    expect(find.text('I am enough.'), findsOneWidget);
  });

  testWidgets('the Today button opens the deck', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Browse the deck'));
    await tester.pumpAndSettle();

    expect(find.text('I am enough.'), findsOneWidget);
  });

  testWidgets('has five tabs: Today, Deck, Explore, Cosmic and Me', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    final bar = find.byType(NavigationBar);
    for (final label in ['Today', 'Deck', 'Explore', 'Cosmic', 'Me']) {
      expect(
        find.descendant(of: bar, matching: find.text(label)),
        findsOneWidget,
      );
    }
  });

  testWidgets('shows a loading state while quotes load', (tester) async {
    await tester.pumpWidget(
      _app(
        quotes: () =>
            Future.delayed(const Duration(seconds: 1), () => [_quote]),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Deck'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('shows an error state with retry', (tester) async {
    await tester.pumpWidget(
      _app(quotes: () => Future.error(Exception('boom'))),
    );
    await tester.pumpAndSettle();
    await _openDeck(tester);

    expect(find.text('Something wobbled'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('shows an empty state when there are no quotes', (tester) async {
    await tester.pumpWidget(_app(quotes: () => Future.value(<Quote>[])));
    await tester.pumpAndSettle();
    await _openDeck(tester);

    expect(find.text('Nothing here yet'), findsOneWidget);
  });

  testWidgets('bottom tabs navigate between Explore, Cosmic and Me', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cosmic'));
    await tester.pumpAndSettle();
    expect(find.text('Unlock your cosmic side'), findsOneWidget);

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    expect(find.text('Your journal'), findsOneWidget);

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    expect(find.text('Edit profile'), findsOneWidget);
  });

  testWidgets('Me opens the journal', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Your journal'));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Let's go"));
    await tester.pumpAndSettle();

    expect(find.text('Nothing saved yet'), findsOneWidget);
  });

  testWidgets('Me opens the partners list', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Explore'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Partners'));
    await tester.tap(find.text('Partners'));
    await tester.pumpAndSettle();
    await tester.tap(find.text("Let's go"));
    await tester.pumpAndSettle();

    expect(find.text('No partners yet'), findsOneWidget);
  });

  testWidgets('Me opens Edit profile', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Edit profile'));
    await tester.pumpAndSettle();

    expect(find.text('Your name'), findsOneWidget);
    expect(find.text('Birthday'), findsOneWidget);
  });

  testWidgets('Me opens About', (tester) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Me'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();

    expect(find.text('About readings'), findsOneWidget);
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

    testWidgets('a new user starts at the welcome, in English only', (
      tester,
    ) async {
      await tester.pumpWidget(_app(onboarded: false));
      await tester.pumpAndSettle();

      expect(find.text('Choose your language'), findsNothing);
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

      // No birth data is asked; focus areas come next, then the reminder.
      expect(find.text('When is your birthday?'), findsNothing);
      expect(find.text('What would you like more of?'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('A daily nudge?'), findsOneWidget);
      await tester.tap(find.text('Skip for now'));
      await tester.pumpAndSettle();

      expect(find.text('Today'), findsWidgets);
      expect(find.text('Deck'), findsOneWidget);
      expect(find.text('Welcome to Mochi Moon'), findsNothing);
      expect(profiles.profile?.displayName, 'Mochi');
      expect(profiles.profile?.birthDate, isNull);
    });
  });
}
