import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mochi_moon/app/router.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/letters/application/weekly_letter_providers.dart';
import 'package:mochi_moon/features/letters/domain/weekly_letter.dart';
import 'package:mochi_moon/features/letters/presentation/weekly_letter_card.dart';
import 'package:mochi_moon/features/paywall/application/entitlement_providers.dart';

final _sunday = DateTime(2026, 11, 1, 20);
final _wednesday = DateTime(2026, 11, 4, 9);

const _letter = WeeklyLetter(
  weekStart: '2026-10-26',
  lang: 'en',
  version: 1,
  title: 'A soft week',
  body: 'You showed up. Mochi noticed every bit of it.',
);

Future<void> _pump(
  WidgetTester tester, {
  required bool premium,
  required DateTime now,
  WeeklyLetterView? view,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hasPremiumProvider.overrideWithValue(premium),
        clockProvider.overrideWithValue(() => now),
        weeklyLetterProvider.overrideWith((ref) async => view),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: WeeklyLetterCard()),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  testWidgets('the invitation opens the paywall with its source', (
    tester,
  ) async {
    String? source;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          hasPremiumProvider.overrideWithValue(false),
          clockProvider.overrideWithValue(() => _sunday),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) =>
                    const Scaffold(body: WeeklyLetterCard()),
              ),
              GoRoute(
                path: AppRoutes.paywall,
                builder: (context, state) {
                  source = state.uri.queryParameters['source'];
                  return const Text('paywall');
                },
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('See Premium'));
    await tester.pumpAndSettle();
    expect(source, 'weekly_letter');
  });

  testWidgets('a free user sees the invitation on Sunday', (tester) async {
    await _pump(tester, premium: false, now: _sunday);

    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
    expect(find.text(l10n.weeklyLetterPremiumTitle), findsOneWidget);
    expect(find.text(l10n.weeklyLetterTeaser), findsOneWidget);
    expect(find.text(l10n.weeklyLetterOpen), findsNothing);
  });

  testWidgets('a free user sees nothing on other days', (tester) async {
    await _pump(tester, premium: false, now: _wednesday);

    expect(find.byType(Card), findsNothing);
  });

  testWidgets('Premium sees the first line and opens the whole letter', (
    tester,
  ) async {
    await _pump(
      tester,
      premium: true,
      now: _sunday,
      view: const WeeklyLetterView(letter: _letter),
    );

    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
    expect(find.text('You showed up.'), findsOneWidget);

    await tester.tap(find.text(l10n.weeklyLetterOpen));
    await tester.pumpAndSettle();

    expect(find.text('A soft week'), findsOneWidget);
    expect(find.text(_letter.body), findsOneWidget);
    expect(find.text(l10n.entertainmentNote), findsOneWidget);
    expect(find.text(l10n.weeklyLetterOfflineNote), findsNothing);
  });

  testWidgets('the fallback letter says it was written offline', (
    tester,
  ) async {
    await _pump(
      tester,
      premium: true,
      now: _wednesday,
      view: const WeeklyLetterView(letter: _letter, isFallback: true),
    );

    final l10n = AppLocalizations.of(tester.element(find.byType(Scaffold)));
    await tester.tap(find.text(l10n.weeklyLetterOpen));
    await tester.pumpAndSettle();

    expect(find.text(l10n.weeklyLetterOfflineNote), findsOneWidget);
  });

  testWidgets('Premium with no letter shows no card', (tester) async {
    await _pump(tester, premium: true, now: _wednesday);

    expect(find.byType(Card), findsNothing);
  });
}
