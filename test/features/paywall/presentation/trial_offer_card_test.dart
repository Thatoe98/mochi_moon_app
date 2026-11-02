import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/paywall/application/trial_offer_providers.dart';
import 'package:mochi_moon/features/paywall/presentation/trial_offer_card.dart';
import 'package:mochi_moon/features/ritual/application/ritual_providers.dart';
import 'package:mochi_moon/features/ritual/domain/ritual_state.dart';

import '../../deck/support/fake_deck_repository.dart';
import '../../settings/support/fake_analytics_consent.dart';
import '../support/fake_trial_offer.dart';

class _FinishedRitual extends RitualController {
  @override
  Future<RitualState> build() async =>
      const RitualState(phase: RitualPhase.finished);
}

class _OpenRitual extends RitualController {
  @override
  Future<RitualState> build() async =>
      const RitualState(phase: RitualPhase.gratitude);
}

/// As in the real app, the consent answer is loaded before Today shows.
class _AfterConsent extends ConsumerWidget {
  const _AfterConsent();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(analyticsConsentControllerProvider).hasValue
      ? const Scaffold(body: TrialOfferCard())
      : const SizedBox.shrink();
}

class _Consent extends AnalyticsConsentController {
  @override
  Future<bool?> build() async => true;
}

final _today = DateTime(2026, 11, 3, 20);

class _Harness {
  _Harness({
    int ritualDays = 2,
    this.premium = false,
    this.finished = true,
    bool shown = false,
    bool hardDay = false,
  }) : decks = FakeDeckRepository(),
       trial = FakeTrialOfferRepository(shown: shown),
       sink = RecordingAnalyticsSink() {
    for (var i = 0; i < ritualDays; i++) {
      unawaited(decks.markRitualDay(DateTime(2026, 11, 3 - i)));
    }
    if (hardDay) trial.hardDay = DateTime(2026, 11, 3);
  }

  final FakeDeckRepository decks;
  final FakeTrialOfferRepository trial;
  final RecordingAnalyticsSink sink;
  final bool premium;
  final bool finished;
  String? paywallSource;

  Widget app() => ProviderScope(
    overrides: [
      deckRepositoryProvider.overrideWithValue(decks),
      trialOfferRepositoryProvider.overrideWithValue(trial),
      clockProvider.overrideWithValue(() => _today),
      hasPremiumProvider.overrideWithValue(premium),
      ritualControllerProvider.overrideWith(
        finished ? _FinishedRitual.new : _OpenRitual.new,
      ),
      analyticsSinkProvider.overrideWithValue(sink),
      analyticsConsentControllerProvider.overrideWith(_Consent.new),
    ],
    child: MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const _AfterConsent(),
          ),
          GoRoute(
            path: AppRoutes.paywall,
            builder: (context, state) {
              paywallSource = state.uri.queryParameters['source'];
              return const Text('paywall');
            },
          ),
        ],
      ),
    ),
  );

  List<String> get events => [for (final (name, _) in sink.recorded) name];
}

Future<void> _pump(WidgetTester tester, _Harness harness) async {
  await tester.pumpWidget(harness.app());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows once on the 2nd ritual day and says what it includes', (
    tester,
  ) async {
    final h = _Harness();
    await _pump(tester, h);

    expect(find.text('Mochi Premium, if you would like it'), findsOneWidget);
    expect(find.textContaining('free for 7 days'), findsOneWidget);
    expect(find.textContaining('after the 7 days'), findsOneWidget);
    expect(h.trial.shown, isTrue);
    expect(h.events, ['trial_offer_shown']);
  });

  testWidgets('also shows on the 3rd ritual day', (tester) async {
    await _pump(tester, _Harness(ritualDays: 3));
    expect(find.text('Tell me more'), findsOneWidget);
  });

  for (final (name, harness) in <(String, _Harness Function())>[
    ('on day 1', () => _Harness(ritualDays: 1)),
    ('from day 4', () => _Harness(ritualDays: 4)),
    ('before the ritual is finished', () => _Harness(finished: false)),
    ('to Premium users', () => _Harness(premium: true)),
    ('again once it was shown', () => _Harness(shown: true)),
    ('on a day she opened the hard-day kit', () => _Harness(hardDay: true)),
  ]) {
    testWidgets('never shows $name', (tester) async {
      final h = harness();
      await _pump(tester, h);

      expect(find.text('Tell me more'), findsNothing);
      expect(h.events, isEmpty);
    });
  }

  testWidgets('Not now closes it for good and logs it', (tester) async {
    final h = _Harness();
    await _pump(tester, h);

    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();

    expect(find.text('Tell me more'), findsNothing);
    expect(h.events, ['trial_offer_shown', 'trial_offer_dismissed']);
    expect(h.paywallSource, isNull);
  });

  testWidgets('Tell me more opens the paywall with its source', (tester) async {
    final h = _Harness();
    await _pump(tester, h);

    await tester.tap(find.text('Tell me more'));
    await tester.pumpAndSettle();

    expect(h.paywallSource, 'trial_offer');
  });

  testWidgets('has no countdown or pressure wording', (tester) async {
    await _pump(tester, _Harness());

    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
    final copy = '${l10n.trialOfferTitle} ${l10n.trialOfferBody}'.toLowerCase();
    for (final pressure in ['last chance', 'hurry', 'expires', 'miss out']) {
      expect(copy, isNot(contains(pressure)));
    }
  });
}
