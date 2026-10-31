import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mochi_moon/core/l10n/app_localizations.dart';
import 'package:mochi_moon/features/mood/domain/mood.dart';
import 'package:mochi_moon/features/mood/presentation/mood_calendar.dart';

final _today = DateTime(2026, 10, 28);

Widget _app({
  List<DayMood> moods = const [],
  ValueChanged<DateTime>? onDayTap,
  double textScale = 1,
}) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  builder: (context, child) => MediaQuery(
    data: MediaQuery.of(context)
        .copyWith(textScaler: TextScaler.linear(textScale)),
    child: child!,
  ),
  home: Scaffold(
    body: SingleChildScrollView(
      child: MoodCalendar(
        moods: moods,
        today: _today,
        selectedDay: null,
        onDayTap: onDayTap ?? (_) {},
      ),
    ),
  ),
);

void main() {
  testWidgets('shows the current month and a dot only for logged days', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        moods: [
          DayMood(day: DateTime(2026, 10, 3), mood: Mood.happy),
          DayMood(day: DateTime(2026, 10, 9), mood: Mood.sad),
        ],
      ),
    );

    expect(find.text('October 2026'), findsOneWidget);
    expect(find.bySemanticsLabel('October 3, Happy'), findsOneWidget);
    expect(find.bySemanticsLabel('October 9, Sad'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('October 4, no mood')), findsOneWidget);
  });

  testWidgets('goes back a month, and next is off in the current month', (
    tester,
  ) async {
    await tester.pumpWidget(_app());

    IconButton button(String tip) => tester.widget<IconButton>(
      find
          .ancestor(of: find.byTooltip(tip), matching: find.byType(IconButton))
          .first,
    );
    expect(button('Next month').onPressed, isNull);

    await tester.tap(find.byTooltip('Previous month'));
    await tester.pump();

    expect(find.text('September 2026'), findsOneWidget);
    expect(button('Next month').onPressed, isNotNull);

    await tester.tap(find.byTooltip('Next month'));
    await tester.pump();
    expect(find.text('October 2026'), findsOneWidget);
  });

  testWidgets('tapping a day reports it', (tester) async {
    DateTime? tapped;
    await tester.pumpWidget(_app(onDayTap: (day) => tapped = day));

    await tester.tap(find.text('12'));
    await tester.pump();

    expect(tapped, DateTime(2026, 10, 12));
  });

  testWidgets('1.3x text scale does not overflow', (tester) async {
    await tester.pumpWidget(_app(textScale: 1.3));
    expect(tester.takeException(), isNull);
  });
}
