import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_screen.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_status_card.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_timeline.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';

import '../support/periods.dart';

Widget _host(
  Widget home, {
  RetrogradeCalendarSource source = fakeCalendar,
  DateTime? now,
  Locale? locale,
  double textScale = 1,
}) => ProviderScope(
  overrides: [
    clockProvider.overrideWithValue(() => now ?? DateTime(2026, 10, 29, 12)),
    retrogradeCalendarSourceProvider.overrideWithValue(source),
  ],
  child: MaterialApp(
    theme: AppTheme.light,
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    builder: (context, child) => MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: TextScaler.linear(textScale)),
      child: child!,
    ),
    home: home,
  ),
);

/// Tall enough that the lazy list builds every planet.
void _tallView(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(800, 4000)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  group('RetrogradeScreen', () {
    testWidgets('shows a loader first', (tester) async {
      await tester.pumpWidget(_host(const RetrogradeScreen()));
      expect(find.byType(LoadingView), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('lists the planets with status, dates, tips and the note', (
      tester,
    ) async {
      _tallView(tester);
      await tester.pumpWidget(_host(const RetrogradeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Retrogrades'), findsOneWidget);
      expect(find.text('Mercury is retrograde until Nov 13'), findsOneWidget);
      expect(find.text('Next Venus retrograde: Dec 20'), findsOneWidget);
      expect(find.text('Starts in 52 days'), findsOneWidget);
      expect(
        find.text('Retrograde Oct 9, 2026 to Nov 13, 2026'),
        findsOneWidget,
      );
      expect(find.text('No retrogrades this year'), findsOneWidget);
      expect(find.textContaining('A lovely time to revisit'), findsOneWidget);
      expect(find.byType(RetrogradeTimeline), findsWidgets);
      expect(find.text('Pre-shadow'), findsOneWidget);
      expect(
        find.text('For entertainment and self-reflection'),
        findsOneWidget,
      );
    });

    testWidgets('keeps Jupiter and Saturn under More planets', (tester) async {
      _tallView(tester);
      await tester.pumpWidget(_host(const RetrogradeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Jupiter'), findsNothing);
      await tester.tap(find.text('More planets'));
      await tester.pumpAndSettle();
      expect(find.text('Jupiter'), findsOneWidget);
      expect(find.text('Saturn'), findsOneWidget);
    });

    testWidgets('shows an error with a retry that tries again', (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        _host(
          const RetrogradeScreen(),
          source: (year) {
            calls++;
            return calls <= 2
                ? Future.error(StateError('scan failed'))
                : fakeCalendar(year);
          },
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ErrorView), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(find.byType(ErrorView), findsNothing);
      expect(find.text('Mercury is retrograde until Nov 13'), findsOneWidget);
    });

    testWidgets('reads in Burmese', (tester) async {
      _tallView(tester);
      await tester.pumpWidget(
        _host(const RetrogradeScreen(), locale: const Locale('my')),
      );
      await tester.pumpAndSettle();

      expect(find.text('နောက်ပြန်လှည့်နေတဲ့ ဂြိုဟ်များ'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('survives 1.3x text without overflow', (tester) async {
      _tallView(tester);
      await tester.pumpWidget(_host(const RetrogradeScreen(), textScale: 1.3));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });

  group('RetrogradeStatusCard', () {
    testWidgets('says when Mercury turns direct', (tester) async {
      await tester.pumpWidget(
        _host(const Scaffold(body: RetrogradeStatusCard())),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mercury is retrograde until Nov 13'), findsOneWidget);
    });

    testWidgets('counts down to the next Mercury retrograde', (tester) async {
      await tester.pumpWidget(
        _host(
          const Scaffold(body: RetrogradeStatusCard()),
          now: DateTime(2026, 11, 20, 12),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Next Mercury retrograde: Feb 9'), findsOneWidget);
      expect(find.text('Starts in 81 days'), findsOneWidget);
    });

    testWidgets('shows nothing when the calendar fails', (tester) async {
      await tester.pumpWidget(
        _host(
          const Scaffold(body: RetrogradeStatusCard()),
          source: (year) async => throw StateError('scan failed'),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Card), findsNothing);
    });
  });
}
