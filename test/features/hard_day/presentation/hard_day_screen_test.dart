import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/analytics/analytics_providers.dart';
import 'package:mochi_moon/core/analytics/analytics_sink.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quote.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/hard_day/presentation/hard_day_screen.dart';
import 'package:mochi_moon/features/paywall/application/trial_offer_providers.dart';

import '../../paywall/support/expect_no_paywall.dart';
import '../../paywall/support/fake_trial_offer.dart';

class _RecordingSink implements AnalyticsSink {
  final events = <(String, Map<String, String>)>[];

  @override
  Future<void> record(String name, Map<String, String> params) async =>
      events.add((name, params));
}

Widget _app(
  _RecordingSink sink, {
  List<Quote>? quotes,
  FakeTrialOfferRepository? trial,
}) => ProviderScope(
  overrides: [
    trialOfferRepositoryProvider.overrideWithValue(
      trial ?? FakeTrialOfferRepository(),
    ),
    clockProvider.overrideWithValue(() => DateTime(2026, 10, 31, 12)),
    analyticsSinkProvider.overrideWithValue(sink),
    analyticsConsentControllerProvider.overrideWith(_Consent.new),
    quotesProvider.overrideWith(
      (ref) async =>
          quotes ??
          [
            for (var i = 0; i < 4; i++)
              Quote(
                id: 'c$i',
                text: {'en': 'Gentle words $i'},
                category: 'calm',
              ),
          ],
    ),
  ],
  child: const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    // As in the real app, the consent answer is loaded before the kit opens.
    home: _AfterConsent(),
  ),
);

class _AfterConsent extends ConsumerWidget {
  const _AfterConsent();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(analyticsConsentControllerProvider).hasValue
      ? const HardDayScreen(source: 'today')
      : const SizedBox.shrink();
}

class _Consent extends AnalyticsConsentController {
  @override
  Future<bool?> build() async => true;
}

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized().platformDispatcher.views.first
      ..physicalSize = const Size(1170, 4000)
      ..devicePixelRatio = 3;
  });
  tearDown(() {
    TestWidgetsFlutterBinding.instance.platformDispatcher.views.first
      ..resetPhysicalSize()
      ..resetDevicePixelRatio();
  });

  testWidgets('shows no paywall, lock or upsell', (tester) async {
    await tester.pumpWidget(_app(_RecordingSink()));
    await tester.pumpAndSettle();
    expectNoPaywall(tester);
  });

  testWidgets('opening the kit is noted for today, so no offer shows', (
    tester,
  ) async {
    final trial = FakeTrialOfferRepository();
    await tester.pumpWidget(_app(_RecordingSink(), trial: trial));
    await tester.pumpAndSettle();

    expect(trial.hardDay, DateTime(2026, 10, 31));
  });

  testWidgets('shows breathing, a comforting card, the jar and Help', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_RecordingSink()));
    await tester.pumpAndSettle();

    expect(find.text('Breathe with Mochi'), findsOneWidget);
    expect(find.textContaining('Gentle words'), findsWidgets);
    expect(find.text('Gratitude jar'), findsOneWidget);
    expect(find.text('Help'), findsOneWidget);
  });

  testWidgets('Help has the note and no phone numbers', (tester) async {
    await tester.pumpWidget(_app(_RecordingSink()));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('not a substitute for professional help'),
      findsOneWidget,
    );
    expect(find.textContaining('emergency services'), findsOneWidget);
    expect(find.textContaining('search for your national'), findsOneWidget);
    // No digits anywhere in the Help copy: helplines stay TODO_CONTENT.
    final help = tester
        .widgetList<Text>(find.textContaining('professional help'))
        .map((t) => t.data!)
        .join();
    expect(RegExp(r'\d').hasMatch(help), isFalse);
  });

  testWidgets('works with no cards at all', (tester) async {
    await tester.pumpWidget(_app(_RecordingSink(), quotes: const []));
    await tester.pumpAndSettle();

    expect(find.text('Help'), findsOneWidget);
    expect(find.textContaining('Gentle words'), findsNothing);
  });

  testWidgets('logs only the opened event with its source', (tester) async {
    final sink = _RecordingSink();
    await tester.pumpWidget(_app(sink));
    await tester.pumpAndSettle();

    expect(sink.events, hasLength(1));
    expect(sink.events.single.$1, 'hard_day_opened');
    expect(sink.events.single.$2, {'source': 'today'});
  });
}
