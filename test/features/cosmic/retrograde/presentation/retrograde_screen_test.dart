import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/core/theme/app_theme.dart';
import 'package:mochi_moon/core/widgets/state_views.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_alert_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/application/retrograde_providers.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_screen.dart';
import 'package:mochi_moon/features/cosmic/retrograde/presentation/retrograde_status_card.dart';
import 'package:mochi_moon/features/deck/application/deck_providers.dart';
import 'package:mochi_moon/features/settings/application/reminder_providers.dart';

import '../../../settings/support/fake_reminder.dart';
import '../support/fake_alerts.dart';
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
    retrogradeAlertSettingsRepositoryProvider.overrideWithValue(
      FakeRetrogradeAlertSettingsRepository(),
    ),
    retrogradeAlertSchedulerProvider.overrideWithValue(
      FakeRetrogradeAlertScheduler(),
    ),
    reminderSchedulerProvider.overrideWithValue(FakeReminderScheduler()),
    reminderLanguageProvider.overrideWithValue('en'),
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

    testWidgets('shows only what is retrograde now, with the gentle tips', (
      tester,
    ) async {
      _tallView(tester);
      await tester.pumpWidget(_host(const RetrogradeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Right now'), findsOneWidget);
      expect(find.text('Mercury is retrograde until Nov 13'), findsOneWidget);
      expect(find.text('Gentle tips'), findsOneWidget);
      expect(find.textContaining('A lovely time to revisit'), findsOneWidget);
      expect(
        find.text(
          'Back up your photos and re-read messages before you send them.',
        ),
        findsOneWidget,
      );
      // Planets that are moving forward, and every date list, are gone.
      expect(find.textContaining('Next Venus'), findsNothing);
      expect(find.textContaining('Shadows'), findsNothing);
      expect(find.textContaining('Retrograde Oct'), findsNothing);
      expect(
        find.text('For entertainment and self-reflection'),
        findsOneWidget,
      );
    });

    testWidgets('says so when every planet is moving forward', (tester) async {
      _tallView(tester);
      await tester.pumpWidget(
        _host(const RetrogradeScreen(), now: DateTime(2026, 12, 1, 12)),
      );
      await tester.pumpAndSettle();

      expect(find.text('All planets are moving forward'), findsOneWidget);
      expect(find.text('Gentle tips'), findsNothing);
    });

    testWidgets('shows a card for each planet that is retrograde', (
      tester,
    ) async {
      _tallView(tester);
      await tester.pumpWidget(
        _host(const RetrogradeScreen(), now: DateTime(2026, 11, 5, 12)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Gentle tips'), findsOneWidget);

      await tester.pumpWidget(
        _host(const RetrogradeScreen(), now: DateTime(2026, 12, 25, 12)),
      );
      await tester.pumpAndSettle();
      expect(find.text('Venus'), findsWidgets);
      expect(find.text('Venus is retrograde until Jan 31'), findsOneWidget);
    });

    testWidgets('keeps the heads-up switches on this screen', (tester) async {
      _tallView(tester);
      await tester.pumpWidget(_host(const RetrogradeScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Retrograde heads-ups'), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNWidgets(3));
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
