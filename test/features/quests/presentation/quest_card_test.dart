import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/core/content/content_providers.dart';
import 'package:mochi_moon/core/content/quest.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/weekly_letter_providers.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';
import 'package:mochi_moon/features/profile/application/profile_providers.dart';
import 'package:mochi_moon/features/quests/application/quest_providers.dart';
import 'package:mochi_moon/features/quests/presentation/quest_card.dart';

import '../../letters/support/fake_weekly_letter.dart';
import '../../profile/support/fake_profile.dart';
import '../support/fake_quest.dart';

Widget _app(
  FakeQuestRepository repo,
  List<Quest> quests, {
  bool premium = true,
  List<String>? paywallSources,
}) => ProviderScope(
  overrides: [
    hasPremiumProvider.overrideWithValue(premium),
    questRepositoryProvider.overrideWithValue(repo),
    questDoneLogProvider.overrideWithValue(FakeQuestDoneLog()),
    questsProvider.overrideWith((ref) async => quests),
    profileRepositoryProvider.overrideWithValue(FakeProfileRepository()),
    profileRemoteProvider.overrideWithValue(null),
    clockProvider.overrideWithValue(() => DateTime(2026, 11, 2, 9)),
  ],
  child: MaterialApp.router(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: QuestCard()),
        ),
        GoRoute(
          path: '/paywall',
          builder: (context, state) {
            paywallSources?.add(state.uri.queryParameters['source']!);
            return const Scaffold(body: Text('paywall'));
          },
        ),
      ],
    ),
  ),
);

final List<Quest> _quests = [
  for (var i = 1; i <= 4; i++) Quest(id: 'q$i', text: {'en': 'Be kind $i'}),
];

void main() {
  testWidgets('shows nothing when there are no quests', (tester) async {
    await tester.pumpWidget(_app(FakeQuestRepository(), const []));
    await tester.pumpAndSettle();

    expect(find.text("Today's tiny kindness"), findsNothing);
  });

  testWidgets('shows the quest, then done without buttons', (tester) async {
    final repo = FakeQuestRepository();
    await tester.pumpWidget(_app(repo, _quests));
    await tester.pumpAndSettle();

    expect(find.text("Today's tiny kindness"), findsOneWidget);
    expect(find.textContaining('Be kind'), findsOneWidget);

    await tester.tap(find.text('I did it'));
    await tester.pumpAndSettle();

    expect(find.text('Done for today. Well done, you.'), findsOneWidget);
    expect(find.text('I did it'), findsNothing);
    expect(find.text('Try another'), findsNothing);
    expect(repo.saved?.done, isTrue);
  });

  testWidgets('a free user sees Try another locked and it opens the paywall', (
    tester,
  ) async {
    final repo = FakeQuestRepository();
    final sources = <String>[];
    await tester.pumpWidget(
      _app(repo, _quests, premium: false, paywallSources: sources),
    );
    await tester.pumpAndSettle();
    final first = tester.widget<Text>(find.textContaining('Be kind')).data;

    expect(find.byIcon(Icons.lock_rounded), findsOneWidget);
    await tester.tap(find.text('Try another'));
    await tester.pumpAndSettle();

    expect(sources, ['quest_swap']);
    expect(repo.saved, isNull);
    expect(first, isNotNull);
  });

  testWidgets('Premium: Try another changes the quest once', (tester) async {
    final repo = FakeQuestRepository();
    await tester.pumpWidget(_app(repo, _quests));
    await tester.pumpAndSettle();
    final first = tester.widget<Text>(find.textContaining('Be kind')).data;

    await tester.tap(find.text('Try another'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<Text>(find.textContaining('Be kind')).data,
      isNot(first),
    );
    expect(find.text('Try another'), findsNothing);
    expect(find.text('I did it'), findsOneWidget);
  });
}
